//
//  MITMITPICViewController.m
//  OpenGLDemo
//
//  Created by MENGCHEN on 2017/3/20.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//

#import "MITMITPICViewController.h"
#import "MITGLKVertexAttribArrayBuffer.h"
#import "MITGLContext.h"

@implementation MITMITPICViewController

@synthesize baseEffect;
@synthesize vertexBuffer;


typedef struct{
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
}SceneVertex;

static const SceneVertex vertices[] = {
//    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // lower left corner
//    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
//    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 1.0f}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
};




- (void)viewDidLoad {
    [super viewDidLoad];

    //获取 glkView
    GLKView * view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"不是 glkview");
    //初始化 context
    view.context = [[MITGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    //设置当前 context
    [MITGLContext setCurrentContext:view.context];
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(
                                                   1.0f,
                                                   1.0f,
                                                   1.0f,
                                                   1.0f);
    ((MITGLContext *)view.context).clearColor = GLKVector4Make(
                                                               0.0f,
                                                               0.0f,
                                                               0.0f,
                                                               1.0f);
    //创建顶点数组缓存
    self.vertexBuffer = [[MITGLKVertexAttribArrayBuffer alloc] initWithAttribBtride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices) / sizeof(SceneVertex) data:vertices usage:GL_STATIC_DRAW];

    //创建纹理
    CGImageRef imageRef = [[UIImage imageNamed:@"leaves.gif"] CGImage];
    //纹理缓存信息，保存配置信息。
    /*
     GLKTextureLoader 
     
     
     */
    GLKTextureInfo * textInfo = [GLKTextureLoader textureWithCGImage:imageRef options:nil error:NULL];
    self.baseEffect.texture2d0.name = textInfo.name;
    self.baseEffect.texture2d0.target = textInfo.target;
}

#pragma mark action 刷新
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    //做好准备
    [self.baseEffect prepareToDraw];
    [(MITGLContext *)view.context clear:GL_DEPTH_BUFFER_BIT];
    //为渲染顶点做好准备
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, positionCoords)
                                  shouldEnable:YES];
    //为每个定点的两个纹理坐标的渲染做好准备
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SceneVertex, textureCoords)
                                  shouldEnable:YES];
    
    //渲染有纹理的三角形
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:3];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
