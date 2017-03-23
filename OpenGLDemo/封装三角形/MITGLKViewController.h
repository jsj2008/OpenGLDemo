//
//  MITGLKViewController.h
//  OpenGLDemo
//
//  Created by MENGCHEN on 2017/3/16.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//

#import <GLKit/GLKit.h>
@class MITGLKVertexAttribArrayBuffer;

@interface MITGLKViewController : GLKViewController
{
    MITGLKVertexAttribArrayBuffer * vertexBuffer;
}


/**  <#Description#>*/
@property(nonatomic, strong)GLKBaseEffect * baseEffect;
/**  <#Description#>*/
@property(nonatomic, strong)MITGLKVertexAttribArrayBuffer * vertexBuffer;

@end
