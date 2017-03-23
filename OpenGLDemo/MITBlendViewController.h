//
//  MITBlendViewController.h
//  OpenGLDemo
//
//  Created by MENGCHEN on 2017/3/21.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//

#import <GLKit/GLKit.h>

@class MITGLKVertexAttribArrayBuffer;

@interface MITBlendViewController : GLKViewController


/**  着色器 */
@property(nonatomic, strong)GLKBaseEffect * baseEffect;
/**  顶点坐标 */
@property(nonatomic, strong)MITGLKVertexAttribArrayBuffer * vertexBuffer;
/**  纹理信息0 */
@property(nonatomic, strong)GLKTextureInfo * textureInfo0;
/**  纹理信息1 */
@property(nonatomic, strong)GLKTextureInfo * textureInfo1;


@end
