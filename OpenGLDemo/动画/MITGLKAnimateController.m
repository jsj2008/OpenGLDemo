//
//  MITGLKAnimateController.m
//  OpenGLDemo
//
//  Created by MENGCHEN on 2017/3/17.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//

#import "MITGLKAnimateController.h"
#import "MITGLContext.h"
#import <GLKit/GLKit.h>

//纹理 + 方法
@interface GLKEffectPropertyTexture(MITAddtions)

- (void)setParameter:(GLenum)paramterID value:(GLint)value;


@end


@implementation GLKEffectPropertyTexture(MITAddtions)

-(void)setParameter:(GLenum)paramterID value :(GLint)value{
    glBindTexture(self.target, self.name);
    glTexParameteri(self.target, paramterID, value);
}

@end


@implementation MITGLKAnimateController
@synthesize baseEffect;
@synthesize vertexBuffer;
@synthesize shouldUseLinearFilter;
@synthesize sCoordinateOffset;
typedef struct {
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
}SceneVertex;

static SceneVertex vertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
};
static const SceneVertex defaultVertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}},
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}},
};

//移动坐标系
static GLKVector3 movementVectors[3] = {
    {-0.02f,  -0.01f, 0.0f},
    {0.01f,  -0.005f, 0.0f},
    {-0.01f,   0.01f, 0.0f},
};

#pragma mark action 刷新纹理
- (void)updateTextureParameters
{
    //  - GL_LINEAR 无论何时出现多个纹素对应一个片元时没从相配的多个纹素中取样颜色，然后使用线性内插法来混合这些颜色已得到片元的颜色。产生的片元颜色可能最终是一个纹理中不存在的颜色。流一个纹理是由交替的黑色和白色纹素组成的，线性取样会混合纹素的颜色，因此片元最终会是灰色的。
    [self.baseEffect.texture2d0 setParameter:GL_TEXTURE_WRAP_S value:GL_REPEAT];
//    [self.baseEffect.texture2d0 setParameter:GL_TEXTURE_WRAP_S value:GL_CLAMP_TO_EDGE];
//    [self.baseEffect.texture2d0 setParameter:GL_TEXTURE_MAG_FILTER value:GL_LINEAR];
    //  - GL_NEAREST 会产生不同的结果，与片元的 U、V 坐标最接近的纹素的颜色会被取样。如果一个纹理是由交替的黑色和白色温宿组成的，GL_NEAREST 取样模式会拾取其中的一个纹素或者另一个，并且最终的片元要么是白色的，要么是黑色的。
    [self.baseEffect.texture2d0 setParameter:GL_TEXTURE_MAG_FILTER value:GL_NEAREST];
    //  - GL_TEXTURE_MAG_FILTER 参数用于在没有足够的可用纹素来唯一性地映射一个或者多个纹素到每个片元上时配置取样。在这种情况下 GL_LINEAR 会个哦苏 OpenGL ES 混合附近纹素的颜色来计算片元的颜色。GL_LINEAR 值会有一个放大纹理的效果，并会让它模糊的出现在渲染的三角形上。GL_NEAREST 仅仅会拾取与片元的 U/V 位置接近的纹素的颜色，并放大纹理，这会使它有点像素化地出现在渲染的三角形上。
    
    /*  - 关于 MIP 贴图，多个纹素对应一个片元时候，线性取样会导致 GPU 仅仅为了计算一个片元的最终颜色而读取多个纹素的颜色值。
        - MIP贴图是一个为纹理存储多个细节级别的技术。高细节的纹理会沿着 S 轴和 T 轴存储很多纹素。低细节的纹理沿着每个轴存储很少的纹素。最低细节的纹理只保存一个纹素。多个细节级别增加了在 S、T 轴上的纹素和每个片元的 U,V 坐标之间有紧密的对应关系的可能性。当存在一个紧密的对应关系时，GPU 会减少取样纹素的数量，进而会减少内存访问的次数。
        - MIP 贴图通常会减少 GPU 取样的数量来提高渲染的性能，但是 MIP 贴图是使每个纹理所需要的内存增加了1/3，通常逐个使用和不使用 MIP 贴图来测试性能。
     
     
     */
    
    
}

#pragma mark action 刷新动画定点坐标
- (void)updateAnimatedVertexPositions
{
    int    i;  // by convention, 'i' is current vertex index
    
    for(i = 0; i < 3; i++)
    {
        vertices[i].positionCoords.x += movementVectors[i].x;
        if(vertices[i].positionCoords.x >= 1.0f ||
           vertices[i].positionCoords.x <= -1.0f)
        {
            movementVectors[i].x = -movementVectors[i].x;
        }
        vertices[i].positionCoords.y += movementVectors[i].y;
        if(vertices[i].positionCoords.y >= 1.0f ||
           vertices[i].positionCoords.y <= -1.0f)
        {
            movementVectors[i].y = -movementVectors[i].y;
        }
        vertices[i].positionCoords.z += movementVectors[i].z;
        if(vertices[i].positionCoords.z >= 1.0f ||
           vertices[i].positionCoords.z <= -1.0f)
        {
            movementVectors[i].z = -movementVectors[i].z;
        }
    }
    {
        // Adjust the S texture coordinates to slide texture and
        // reveal effect of texture repeat vs. clamp behavior
        // 'i' is current vertex index
        int i;
        for(i = 0; i < 3; i++)
        {
            vertices[i].textureCoords.s =
            (defaultVertices[i].textureCoords.s + 
             sCoordinateOffset);
        }
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredFramesPerSecond = 60;
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    // Create an OpenGL ES 2.0 context and provide it to the
    // view
    view.context = [[MITGLContext alloc]
                    initWithAPI:kEAGLRenderingAPIOpenGLES2];
    // Make the new context current
    [MITGLContext setCurrentContext:view.context];
    // Create a base effect that provides standard OpenGL ES 2.0
    // shading language programs and set constants to be used for
    // all subsequent rendering
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(
                                                   1.0f, // Red
                                                   1.0f, // Green
                                                   1.0f, // Blue
                                                   1.0f);// Alpha
    
    // Set the background color stored in the current context
    ((MITGLContext *)view.context).clearColor = GLKVector4Make(
                                                              0.0f, // Red
                                                              0.0f, // Green
                                                              0.0f, // Blue
                                                              1.0f);// Alpha
    
    // Create vertex buffer containing vertices to draw
    self.vertexBuffer = [[MITGLKVertexAttribArrayBuffer alloc]initWithAttribBtride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices)/sizeof(SceneVertex) data:vertices usage:GL_DYNAMIC_DRAW];
    //设置纹理
    CGImageRef imageRef = 
    [[UIImage imageNamed:@"grid.png"] CGImage];
    
    GLKTextureInfo *textureInfo = [GLKTextureLoader 
                                   textureWithCGImage:imageRef 
                                   options:nil 
                                   error:NULL];
    
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
}



-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    [self.baseEffect prepareToDraw];
    
    [(MITGLContext*)view.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:true];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:true];
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:3];
}


#pragma mark action 会自动调用刷新的方法
- (void)update
{
    [self updateAnimatedVertexPositions];
    [self updateTextureParameters];
    [vertexBuffer reinitWithAttribStride:sizeof(SceneVertex)
                        numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
                                   bytes:vertices];
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
