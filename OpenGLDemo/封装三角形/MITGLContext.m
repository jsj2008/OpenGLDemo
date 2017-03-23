//
//  MITGLContext.m
//  OpenGLDemo
//
//  Created by MENGCHEN on 2017/3/16.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//

#import "MITGLContext.h"

@implementation MITGLContext


-(void)setClearColor:(GLKVector4)color{
    clearColor = color;
    NSAssert(self == [[self class] currentContext], @"Receiving context required to be current context");
    glClearColor(color.r, color.g, color.b, color.a);
    
}
-(GLKVector4)clearColor{
    return clearColor;
}


-(void)clear:(GLbitfield)mask{
    NSAssert(self == [[self class] currentContext], @"Receiving context required to be current context");
    glClear(mask);
}
-(void)enable:(GLenum)capability{
    
    NSAssert(self==[[self class] currentContext], @"Receiving context required to be current context");
    //开启 gl
    glEnable(capability);
}

-(void)disable:(GLenum)capability{
    NSAssert(self == [[self class] currentContext], @"Receiving context required to be current context");
    //关闭 gl 功能
    glDisable(capability);
}

-(void)setBlendSourceFunction:(GLenum)sfactor destinationFunction:(GLenum)dfactor{
    /*设置混合函数
     sfactor 用于指定每个片元的最终颜色元素是怎么影响混合的。
     dfactor 用于指定在目标帧缓存中已经存在的颜色元素会怎么影响混合。
     常用配置： sfactor -> GL_SRC_ALPHA
              dfactor -> GL_ONE_MINUS_SRC_ALPHA
     GL_SRC_ALPHA 用于让源片元的透明度元素挨个与其他的片元颜色元素相乘。
     GL_ONE_MINUS_SRC_ALPHA 用于让源片元的透明度元素(1.0)与在帧缓存内的正被更新的像素的颜色元素相乘。
     结果是，如果片元的透明度值为0，那么没有片元的颜色会出现在帧缓存中，如果片元的透明度值为1，那么片元的颜色会完全替代在帧缓存中的对应的像素颜色。
     意味着片元颜色的一部分会被添加到帧缓存内对应的像素颜色的一部分中来产生一个混合的结果。
     glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA) 计算方程如下：
     Red(final) = Alpha(fragment)+ Red(fragment) + (1.0 - Alpha(fragment))*Red(frame Buffer)
     Green(final) = Alpha(fragment)+ Green(fragment) + (1.0 - Alpha(fragment))*Green(frame Buffer)
     Blue(final) = Alpha(fragment) + Blue(fragment) + (1.0 - Alpha(fragment))* Blue(frame Buffer)
     Alpha(final) = Alpha(fragment) + (1.0 - Alpha(fragment))*Alpha(frameBuffer)
     */
    
    
    glBlendFunc(sfactor, dfactor);
}

@end
