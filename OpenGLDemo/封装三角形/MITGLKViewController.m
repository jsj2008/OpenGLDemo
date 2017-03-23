//
//  MITGLKViewController.m
//  OpenGLDemo
//
//  Created by MENGCHEN on 2017/3/16.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//

#import "MITGLKViewController.h"
#import "MITGLKVertexAttribArrayBuffer.h"
#import "MITGLContext.h"


typedef struct{
    GLKVector3 posotionCoords;
}SceneVertex;

static const SceneVertex vertices[] =
{
    {{-0.5f,-0.5f,0.0}},
    {{0.5f,-0.5f,0.0}},
    {{-0.5f,0.5f,0.0}}
};

@interface MITGLKViewController ()

@end

@implementation MITGLKViewController

@synthesize baseEffect;
@synthesize vertexBuffer;




- (void)viewDidLoad {
    [super viewDidLoad];

    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View controller's view is not a GLKviEW");
    //创建上下文
    view.context = [[MITGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    //设置当前上下文
    [MITGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    ((MITGLContext *)view.context).clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    self.vertexBuffer  = [[MITGLKVertexAttribArrayBuffer alloc]initWithAttribBtride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices)/sizeof(SceneVertex) data:vertices usage:GL_STATIC_DRAW];
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    [self.baseEffect prepareToDraw];
    
    [(MITGLContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    //使用 MITGLContext 将之前的渲染方法封装
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, posotionCoords) shouldEnable:true];
}


- (void)dealloc{
    GLKView * view = (GLKView *)self.view;
    [MITGLContext setCurrentContext:view.context];
    self.vertexBuffer = nil;
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
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
