//
//  MITGLKVertexAttribArrayBuffer.h
//  OpenGLDemo
//
//  Created by MENGCHEN on 2017/3/16.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//

#import <GLKit/GLKit.h>

typedef enum {
    MITGLKVertexAttribPosition = GLKVertexAttribPosition,
    MITGLKVertexAttribNormal = GLKVertexAttribNormal,
    MITGLKVertexAttribColor = GLKVertexAttribColor,
    MITGLKVertexAttribTexCoord0 = GLKVertexAttribTexCoord0,
    MITGLKVertexAttribTexCoord1 = GLKVertexAttribTexCoord1,
} MITGLKVertexAttrib;



@interface MITGLKVertexAttribArrayBuffer : NSObject
{
    GLsizeiptr stride;
    GLsizeiptr bufferSizeBytes;
    GLuint glName;
}

@property(nonatomic, readonly)GLuint glName;
@property(nonatomic, readonly)GLsizeiptr bufferSizeBytes;
@property(nonatomic, readonly)GLsizeiptr stride;

- (instancetype)initWithAttribBtride:(GLsizeiptr)aStride numberOfVertices:(GLsizei)count data:(const GLvoid *)dataPtr usage:(GLenum)usage;

- (void)prepareToDrawWithAttrib:(GLuint)index numberOfCoordinates:(GLint)count attribOffset:(GLsizeiptr)offset shouldEnable:(BOOL)shouldEnable;

- (void)drawArrayWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertices:(GLsizei)count;

- (void)reinitWithAttribStride:(GLsizei)stride
              numberOfVertices:(GLsizei)count
                         bytes:(const GLvoid *)dataPtr;
+ (void)drawPreparedArraysWithMode:(GLenum)mode
                  startVertexIndex:(GLint)first
                  numberOfVertices:(GLsizei)count;


@end
