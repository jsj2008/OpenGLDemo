//
//  MITGLContext.h
//  OpenGLDemo
//
//  Created by MENGCHEN on 2017/3/16.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface MITGLContext : EAGLContext
{
    GLKVector4 clearColor;
}


/**  Description */
@property(nonatomic, assign)GLKVector4 clearColor;

- (void)clear:(GLbitfield)mask;
- (void)enable:(GLenum)capability;
- (void)disable:(GLenum)capability;
- (void)setBlendSourceFunction:(GLenum)sfactor destinationFunction:(GLenum)dfactor;


@end
