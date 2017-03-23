//
//  GLVertexViewController.m
//  OpenGLDemo
//
//  Created by MENGCHEN on 2017/3/13.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//

#import "GLVertexViewController.h"

typedef struct {
    GLKVector3 positionCoords;
}SceneVertex;

static const SceneVertex vertices[] = {
    {{-0.5f,-0.5f,0.0}},//左下
    {{0.5f,-0.5f,0.0}},//右下
    {{-0.5f,0.5f,0.0}},//上
    {{-0.5,-0.5,-0.5}}//左后
};


@interface GLVertexViewController (){
    GLuint buffer;
    
}
/**  着色器 */
@property(nonatomic, strong)GLKBaseEffect * baseEffect;
@end

@implementation GLVertexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    [self setupConfig];
    //设置顶点坐标
    [self uploadVertexArray];
}

#pragma mark action 初始化
- (void)setupConfig{
    GLKView * view = (GLKView*)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View controller's view is not aGLKView");
    view.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    [EAGLContext setCurrentContext:view.context];
    
    


    
}
#pragma mark action 设置定点坐标
- (void)uploadVertexArray {

    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    //red ，green，blue，alpha
    self.baseEffect.constantColor = GLKVector4Make(0.1f, 0.5f, 0.5f, 0.25f);
    //背景颜色
    glClearColor(0.5f, 0.4f, 0.6f, 1.0f);
    //STEP1:生成，绑定并且初始化在 GPU 内存中存储的缓存内容（为缓存生成一个独一无二的标识符）
    glGenBuffers(1, &buffer);
    //STEP2:绑定（为接下来的运算绑定缓存）
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    //STEP3:哪一个缓存，赋值进这个缓存的字节的数量，字节的地址，未来的运算中怎么样使用（复制数据到缓存中）
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
}


#pragma mark action 重绘方法
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [self.baseEffect prepareToDraw];
    //清空帧缓存
    glClear(GL_COLOR_BUFFER_BIT);
    //STEP4: 使用当前顶点缓冲（启动）
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //STEP5: 每个顶点三个组件，数据是浮点，没有缩放，数据大小，NULL 告诉 GPU 从缓存的开始启动（设置指针）
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE,sizeof(SceneVertex), NULL);
    //STEP6:绘制三角形（绘图）
    glDrawArrays(GL_TRIANGLES, 0, 4);
    
}


-(void)dealloc{
    
    GLKView * view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    if (0!=buffer) {
        glDeleteBuffers(1, &buffer);
        buffer = 0;
    }
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
