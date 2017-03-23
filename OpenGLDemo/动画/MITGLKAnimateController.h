//
//  MITGLKAnimateController.h
//  OpenGLDemo
//
//  Created by MENGCHEN on 2017/3/17.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//

#import <GLKit/GLKit.h>

#import "MITGLKVertexAttribArrayBuffer.h"

@interface MITGLKAnimateController : GLKViewController

/**  <#Description#>*/
@property(nonatomic, strong)GLKBaseEffect * baseEffect;
/**  <#Description#>*/
@property(nonatomic, strong)MITGLKVertexAttribArrayBuffer * vertexBuffer;
/**  <#Description#> */
@property(nonatomic, assign)BOOL shouldUseLinearFilter;
/**  <#Description#> */
@property(nonatomic, assign)BOOL shouldRepeatTextrue;
/**  <#Description#> */
@property(nonatomic, assign)GLfloat sCoordinateOffset;

@end
