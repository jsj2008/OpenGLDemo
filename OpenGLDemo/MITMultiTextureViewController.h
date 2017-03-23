//
//  MITMultiTextureViewController.h
//  OpenGLDemo
//
//  Created by MENGCHEN on 2017/3/21.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//

#import <GLKit/GLKit.h>


@class MITGLKVertexAttribArrayBuffer;

@interface MITMultiTextureViewController : GLKViewController
{
    GLuint _program;
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    GLfloat _rotation;
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    GLuint _texture0ID;
    GLuint _texture1ID;
}
/** 着色器 */
@property(nonatomic, strong)GLKBaseEffect * baseEffect;
/** 缓存 */
@property(nonatomic, strong)MITGLKVertexAttribArrayBuffer * vertexBuffer;

@end
