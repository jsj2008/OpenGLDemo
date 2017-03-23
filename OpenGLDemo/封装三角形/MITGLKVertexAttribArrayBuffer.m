//
//  MITGLKVertexAttribArrayBuffer.m
//  OpenGLDemo
//
//  Created by MENGCHEN on 2017/3/16.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//

#import "MITGLKVertexAttribArrayBuffer.h"

@interface MITGLKVertexAttribArrayBuffer()

@property(nonatomic, assign)GLsizeiptr bufferSizeBytes;

@property(nonatomic, assign)GLsizeiptr stride;


@end


@implementation MITGLKVertexAttribArrayBuffer

@synthesize glName;
@synthesize bufferSizeBytes;
@synthesize stride;


-(instancetype)initWithAttribBtride:(GLsizeiptr)aStride numberOfVertices:(GLsizei)count data:(const GLvoid *)dataPtr usage:(GLenum)usage{
    NSParameterAssert(0<aStride);
    NSParameterAssert(0<count);
    NSParameterAssert(NULL != dataPtr);
    if (nil != (self = [super init])) {
        stride = aStride;
        bufferSizeBytes = stride * count;
        //step1
        glGenBuffers(1, &glName);
        //step2
        glBindBuffer(GL_ARRAY_BUFFER, self.glName);
        //step3
        glBufferData(GL_ARRAY_BUFFER, bufferSizeBytes, dataPtr, usage);
        NSAssert(0!=glName, @"Failed to generate glName");
    }
    return self;
}

-(void)reinitWithAttribStride:(GLsizei)aStride numberOfVertices:(GLsizei)count bytes:(const GLvoid *)dataPtr{
    NSParameterAssert(0 < aStride);
    NSParameterAssert(0 < count);
    NSParameterAssert(NULL != dataPtr);
    NSAssert(0 != glName, @"Invalid name");
    
    self.stride = aStride;
    self.bufferSizeBytes = aStride * count;
    
    glBindBuffer(GL_ARRAY_BUFFER,  // STEP 2
                 self.glName);
    glBufferData(                  // STEP 3
                 GL_ARRAY_BUFFER,  // Initialize buffer contents
                 bufferSizeBytes,  // Number of bytes to copy
                 dataPtr,          // Address of bytes to copy
                 GL_DYNAMIC_DRAW);
}


-(void)prepareToDrawWithAttrib:(GLuint)index numberOfCoordinates:(GLint)count attribOffset:(GLsizeiptr)offset shouldEnable:(BOOL)shouldEnable{
    NSParameterAssert((0<count)&&(count<4));
    NSParameterAssert(offset<self.stride);
    NSAssert(0!=glName, @"invalid glName");
    //step2
    glBindBuffer(GL_ARRAY_BUFFER, self.glName);
    if (shouldEnable) {
        //step4
        glEnableVertexAttribArray(index);
    }
    //step5
    glVertexAttribPointer(index, count, GL_FLOAT, GL_FALSE, (GLsizei)self.stride, NULL+offset);
}

-(void)drawArrayWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertices:(GLsizei)count{
    NSAssert(self.bufferSizeBytes>=((first+count)*self.stride), @"Attempt to draw more vertex data than available");
    //step6
    glDrawArrays(mode, first, count);
}

-(void)dealloc{
    if (0!=glName) {
        //step7
        glDeleteBuffers(1, &glName);
        glName = 0;
    }
}
+ (void)drawPreparedArraysWithMode:(GLenum)mode
                  startVertexIndex:(GLint)first
                  numberOfVertices:(GLsizei)count;
{
    glDrawArrays(mode, first, count); // Step 6
}


@end
