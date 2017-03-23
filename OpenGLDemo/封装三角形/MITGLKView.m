//
//  MITGLKView.m
//  OpenGLDemo
//
//  Created by MENGCHEN on 2017/3/15.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//

#import "MITGLKView.h"
#import <QuartzCore/QuartzCore.h>

//探究 GLKView 的实现

@implementation MITGLKView

@synthesize delegate;
@synthesize context;
@synthesize drawableWidth = _drawableWidth;
@synthesize drawableHeight = _drawableHeight;


/**
 每一个 UIView 实例都有一个相关联的被 CocoaTouch 按需自动床架你的 CoreAnimation 层，CocoaTouch 会调用+LayerClass 方法来确定要创建什么类型的层。
 这里返回 CAEAGLLayer 而不是 CALyaer，因为CAEAGLLayer 会与一个 OpenGlES 的帧缓存共享它的像素颜色仓库
 */
+ (Class)layerClass{
    return [CAEAGLLayer class];
}



#pragma mark ------------------ 访问器方法 ------------------
//因为 MITGLKView 实例需要创建和配置一个帧缓存和一个像素颜色渲染缓存来与视图的 CoreAnimation 层一起使用，所以设置上下文会引起一些副作用。由于上下文保存缓存，因此修改视图的上下文会导致先前创建的所有缓存全部失效，并需要创建和配置新的缓存。
-(instancetype)initWithFrame:(CGRect)frame context:(EAGLContext *)aContext{
    if (self = [super initWithFrame:frame]) {
        CAEAGLLayer * eaglLayer = (CAEAGLLayer *)self.layer;
        //保存层中用到的 OpenGLES 帧缓存类型的信息
        /*kEAGLDrawablePropertyRetainedBacking 是否使用背景保留
         false 的意思就是不使用背景保留，告诉 CoreAnimation 在层的任何部分需要在屏幕上显示的时候都要绘制整个层的内容。CoreAnimation 不要试图保留任何以前绘制的图像留作以后的重用*/
        /*
         kEAGLColorFormatRGBA8 告诉 CoreAnimation 用8位来保存层内的每个像素的每个颜色元素的值
         */
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat,nil];
        
        self.context = aContext;
    }
    return self;
}

//当使用 xib 或者 storyborad 的时候会自动调用
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        CAEAGLLayer * eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat,nil];
        
    }
    return self;
}


#pragma mark action 设置上下文
//这个方法设置接收器的 OPENGLES 上下文。如果接受者已经有了一个不同的上下文，这个方法删除旧的上下文中 OpenGLES 帧缓存资源并且重新在新的上下文中创建他们。
-(void)setContext:(EAGLContext *)aContext{
    if (context!= aContext) {
        //在旧的上下文中删除之前的缓存
        [EAGLContext setCurrentContext:aContext];
        //删除帧缓存
        if (0!=defaultFrameBuffer) {
            glDeleteFramebuffers(1, &defaultFrameBuffer);
            defaultFrameBuffer = 0;
        }
        //删除颜色缓存
        if (0!=colorRenderBuffer) {
            glDeleteRenderbuffers(1, &colorRenderBuffer);
            colorRenderBuffer = 0;
        }
        context = aContext;
        if (nil!= context) {
            //设置新的 context
            context = aContext;
            [EAGLContext setCurrentContext:context];
            //绑定帧缓存
            glGenFramebuffers(1, &defaultFrameBuffer);
            glBindFramebuffer(GL_FRAMEBUFFER, defaultFrameBuffer);
            //绑定颜色缓存
            glGenRenderbuffers(1, &colorRenderBuffer);
            glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
            
            //将颜色渲染缓存绑定到帧缓存上
            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderBuffer);
        }
    }

}

#pragma mark action 返回当前上下文
- (EAGLContext *)context{
    return context;
}

-(void)display{
    [EAGLContext setCurrentContext:self.context];
    //控制渲染到帧缓存的子集，在这里使用的是整个帧缓存
    glViewport(0, 0, (GLsizei)self.drawableWidth, (GLsizei)self.drawableHeight);
    [self drawRect:[self bounds]];
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}
-(void)drawRect:(CGRect)rect{
    if (self.delegate) {
        [self.delegate glkView:self drawInRect:[self bounds]];
    }
}
- (void)layoutSubviews{
    CAEAGLLayer * eaglLayer = (CAEAGLLayer *)self.layer;
    //初始化当前帧缓存的像素颜色缓存
    //调整视图的缓存的尺寸以匹配层的新尺寸
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
    //使颜色渲染缓冲区的当前缓冲区显示
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
    
    //检查是否有错
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    
    if (status!=GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"failed to make complete frame buffer object %x",status);
    }
    
}

//返回当前上下文的帧缓存像素渲染缓存的宽度
- (NSInteger)drawableWidth{
    GLint backingWidth;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    return (NSInteger)backingWidth;
}
-(void)setDrawableWidth:(NSInteger)width{
    _drawableWidth = width;
}


//返回当前上下文的帧缓存像素渲染帧的高度
- (NSInteger)drawableHeight{
    GLint backingHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    return (NSInteger)backingHeight;
}
-(void)setDrawableHeight:(NSInteger)height{
    _drawableHeight = height;
}


/*
 在对象被回收时候调用 dealloc，在这里需要确保视图上下文不再是当前上下文，其次是为了设置上下文属性为 nil。
 */
- (void)dealloc{
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    //删除接受者的 OPENGLES 上下文
    context = nil;
}

@end
