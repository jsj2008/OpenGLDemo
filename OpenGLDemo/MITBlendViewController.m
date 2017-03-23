//
//  MITBlendViewController.m
//  OpenGLDemo
//
//  Created by MENGCHEN on 2017/3/21.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//

#import "MITBlendViewController.h"
#import "MITGLKVertexAttribArrayBuffer.h"
#import "MITGLContext.h"






@implementation MITBlendViewController


@synthesize baseEffect;
@synthesize vertexBuffer;
@synthesize textureInfo0;
@synthesize textureInfo1;


typedef struct {
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
}SceneVertex;

static const SceneVertex vertices[] = {
    {{-1.0f, -0.67f, 0.0f}, {0.0f, 0.0f}},  // first triangle
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},  // second triangle
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f,  0.67f, 0.0f}, {1.0f, 1.0f}},
};


- (void)viewDidLoad {
    [super viewDidLoad];

    //设置上下文
    GLKView * view = (GLKView *)self.view;
    view.context = [[MITGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [MITGLContext setCurrentContext:view.context];
    
    //设置着色器
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    //设置背景颜色
    ((MITGLContext *)view.context).clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    //创建顶点缓存
    self.vertexBuffer = [[MITGLKVertexAttribArrayBuffer alloc]initWithAttribBtride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices)/sizeof(SceneVertex) data:vertices usage:GL_STATIC_DRAW];
    
    //设置纹理0
    CGImageRef imageRef0 = [[UIImage imageNamed:@"leaves.gif"] CGImage];
    self.textureInfo0 = [GLKTextureLoader textureWithCGImage:imageRef0 options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:true], GLKTextureLoaderOriginBottomLeft,nil] error:NULL];
    //设置纹理1
    CGImageRef imageRef1 = [[UIImage imageNamed:@"beetle.png"] CGImage];
    self.textureInfo1 = [GLKTextureLoader textureWithCGImage:imageRef1 options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil] error:NULL];
    
    //方式1：混合实现方式
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    //方式2：混合模式实现
    self.baseEffect.texture2d1.envMode = GLKTextureEnvModeDecal;

}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [(MITGLContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
    //方式1：
    /*混合实现，有两个缺点：
     1、每次显示更新时集合图形必须要被渲染一到更多次，混合函数需要从像素颜色渲染缓存读取颜色数据以便于片元颜色混合。然后结果被写回帧缓存。当带有透明度数据的多个纹理层叠时，每个像素颜色渲染缓存的颜色会被再次读取、混合、重写。
     2、多次读写像素颜色渲染缓存来创建一个最终的渲染像素点额过程叫做多通道渲染。内存访问限制了性能。
     */
//    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:true];
//    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:true];
//    self.baseEffect.texture2d0.name = self.textureInfo0.name;
//    self.baseEffect.texture2d0.target = self.textureInfo0.target;
//    [self.baseEffect prepareToDraw];
//    
//    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(vertices)/sizeof(SceneVertex)];
//    self.baseEffect.texture2d0.name = self.textureInfo1.name;
//    self.baseEffect.texture2d0.target = self.textureInfo1.target;
//    [self.baseEffect prepareToDraw];
    //方式2：
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:true];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:true];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord1 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:true];
    [self.baseEffect prepareToDraw];
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(vertices)/sizeof(SceneVertex)];
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
