//
//  ViewController.m
//  OpenGLDemo
//
//  Created by MENGCHEN on 2017/3/13.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//

#import "ViewController.h"
#import "GLVertexViewController.h"
#import "MITGLKAnimateController.h"
#import "MITMITPICViewController.h"
#import "MITBlendViewController.h"
@interface ViewController ()
{
    EAGLContext * mContext;
    GLKBaseEffect * mEffect;
    
}
@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化设置
    [self setupConfig];
    //设置定点坐标
    [self uploadVertexArray];
    //设置纹理
    [self uploadTexture];
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 50);
    [btn addTarget:self action:@selector(btnCLick) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:btn];
    
}
- (void)btnCLick{
    //三角形
//    GLVertexViewController * vc = [GLVertexViewController new];
//    [self presentViewController:vc animated:true completion:nil];
    
    //纹理动画三角形
//    MITGLKAnimateController * vc = [MITGLKAnimateController new];
//    [self presentViewController:vc animated:true completion:nil];
    
    //贴图
//    MITMITPICViewController * vc = [MITMITPICViewController new];
//    [self presentViewController:vc animated:true completion:nil];
    
    //混合纹理
    MITBlendViewController * vc = [MITBlendViewController new];
    [self presentViewController:vc animated:true completion:nil];
    
}


#pragma mark action 初始化
- (void)setupConfig{
    mContext = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    GLKView * view = (GLKView*)self.view;
    view.context = mContext;
    //设置颜色缓冲区格式
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    [EAGLContext setCurrentContext:mContext];
    
}
#pragma mark action 设置定点坐标
- (void)uploadVertexArray {
    GLfloat squareVertexData[] = {
        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
        0.5, 0.5, -0.0f,    1.0f, 1.0f, //右上
        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
        
        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
        -0.5, -0.5, 0.0f,   0.0f, 0.0f, //左下
    };
    GLuint buffer;
    //请求 OPENGL ES 为图形处理器控制的缓存生成一个独一无二的标识符
    glGenBuffers(1, &buffer);
    //把标示符绑定到 GL_ARRAY_BUFFER 上，告诉 OpenGLES 为接下来的运算使用的缓存
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    //把顶点数据从 cpu 内存中赋值到 gpu 上。让 OpenGLES 为当前绑定的缓存分配并初始化足够的连续内存
    glBufferData(GL_ARRAY_BUFFER,sizeof(squareVertexData), squareVertexData, GL_STATIC_DRAW);
    //顶点数据缓存，开启对应的顶点属性 - 告诉 OpenGLES 在接下来的渲染中书否使用缓存中的数据。
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //设置合适的格式从 buffer 中读取数据，告诉 OpenGLES在缓存中的数据的类型和所有需要访问的数据的内存偏移值
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, (GLfloat*)NULL+0);
    //纹理
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2,GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, (GLfloat*)NULL+3);

}

#pragma mark action 设置纹理
- (void)uploadTexture{
    //纹理贴图
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"111" ofType:@"png"];
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];//GLKTextureLoaderOriginBottomLeft 纹理坐标系是相反的
    GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    //着色器
    mEffect = [[GLKBaseEffect alloc]init];
    mEffect.texture2d0.enabled = GL_TRUE;
    mEffect.texture2d0.name = textureInfo.name;
    
}



- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClearColor(0.3f, 0.6f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    //启动着色器
    [mEffect prepareToDraw];
    //告诉 OpenGLES 使用当前绑定并启用的缓存中额数据渲染整个场景或者某个场景的一部分、
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{

}

@end
