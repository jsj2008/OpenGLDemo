//
//  MITTextureLoader.m
//  OpenGLDemo
//
//  Created by MENGCHEN on 2017/3/20.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//

#import "MITTextureLoader.h"


typedef enum{
    MITGLK1 = 1,
    MITGLK2 = 2,
    MITGLK4 = 4,
    MITGLK8 = 8,
    MITGLK16 = 16,
    MITGLK32 = 32,
    MITGLK64 = 64,
    MITGLK128 = 128,
    MITGLK256 = 256,
    MITGLK512 = 512,
    MITGLK1024 = 1024,



}MITPowerOf2;



static MITPowerOf2 MITCalculatePowerOf2ForDimension(GLuint dimension);


static NSData * MITDataWithResizedCGImageBytes(CGImageRef cgImage,size_t *widthPtr,size_t * heightPtr);


@interface MITTextureInfo(MITTextureloader)


- (id)initWithName:(GLuint)aName
            target:(GLenum)aTarget
             width:(GLuint)aWidth
            height:(GLuint)aHeight;

@end

@implementation MITTextureInfo(MITTextureloader)


-(id)initWithName:(GLuint)aName target:(GLenum)aTarget width:(GLuint)aWidth height:(GLuint)aHeight{
    
    if (self == [super init]) {
        
        name = aName;
        target = aTarget;
        width = aWidth;
        height = aHeight;
    }
    return self;
    
}


@end


@implementation MITTextureInfo

@synthesize name;
@synthesize target;
@synthesize width;
@synthesize height;


@end



@implementation MITTextureLoader


+(MITTextureInfo *)textureWithCGImage:(CGImageRef)cgImage options:(NSDictionary<NSString *,NSNumber *> *)options error:(NSError * _Nullable __autoreleasing *)outError{
    size_t width;
    size_t height;
    NSData * imageData = MITDataWithResizedCGImageBytes(cgImage, &width, &height);
    GLuint textureBufferID;
    glGenTextures(1, &textureBufferID);
    glBindTexture(GL_TEXTURE_2D, textureBufferID);
    /*赋值图片像素的颜色数据到绑定的纹理缓存中，
     glTextImage2D 函数的第一个参数是用于2D 纹理的 GL_TEXTURE_2D
     第二个参数用于指定 MIP 贴图的初始细节级别。如果没有 MIP 贴图，第二个参数必须是0,如果开启了贴图，第二个参数来初始化每个细节级别，全分辨率到只有一纹素的每个级别都必须被指定，否则 GPU 将不会接受这个纹理缓存。
     internalFormat： 用于指定在纹理缓存内每个纹素需要保存的信息的数量。对于 iOS 来说纹素信息要么是 GL_RGB,要么是 GL_RGBA
     GL_RGB 为每个纹素保存红、绿、蓝三种颜色
     GL_RGBA 保存一个额外的用于指定每个纹素透明度的透明度元素。
     第四个/第五个参数用于指定图像的宽度和高度。（宽度和高度需要是2的幂。）
     border：border 参数用来确定围绕纹理的纹素的一个边界的大小，但是在 OpenGLES 中它总是被设置为0.
     format：用于指定初始化所使用的图像数据中每个像素所要保存的信息。应该总与 internalformat 参数相同。
     type：用于指定缓存中的纹素数据所使用的位编码类型，GL_UNSIGNED_BYTE会提供最佳色彩质量，但是每个纹素中每个颜色元素的保存需要一字节的存储空间。
     结果是每次取样一个 RGB 类型的纹素，GPU 都必须最少读取3字节，每个 RGBA 类型的纹素需要读取4字节。其他纹素格式使用多种编码方式来吧每个纹素的所有颜色元素的信息保存在2字节中。
     pixels:被赋值到绑定的纹素缓存中的图片的像素颜色数据的指针。    
     */

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLuint)width, (GLuint)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, [imageData bytes]);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    MITTextureInfo * result = [[MITTextureInfo alloc]initWithName:textureBufferID target:GL_TEXTURE_2D width:(GLuint)width height:(GLuint)height];
    return result;
}



@end


static NSData * MITDataWithResizedCGImageBytes(CGImageRef cgImage,size_t *widthPtr,size_t * heightPtr){
    NSCParameterAssert(NULL != cgImage);
    NSCParameterAssert(NULL != widthPtr);
    NSCParameterAssert(NULL != heightPtr);
    //高度宽度
    GLuint originWidth = (GLuint)CGImageGetWidth(cgImage);
    GLuint originHeight = (GLuint)CGImageGetHeight(cgImage);
    
    NSCAssert(0 < originWidth, @"Invalid image width");
    NSCAssert(0 < originHeight, @"Invalid image width");
    
    GLuint width = MITCalculatePowerOf2ForDimension(originWidth);
    GLuint height = MITCalculatePowerOf2ForDimension(originHeight);
    
    NSMutableData * imageData = [NSMutableData dataWithLength:height*width*4];
    NSCAssert(nil != imageData,@"Unable to allocate image storage");
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef cgContext = CGBitmapContextCreate([imageData mutableBytes], width, height, 8, 4*width, colorSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    CGContextTranslateCTM(cgContext, 1.0, -1.0);
    
    CGContextDrawImage(cgContext, CGRectMake(0, 0, width, height), cgImage);
    
    CGContextRelease(cgContext);
    *widthPtr = width;
    *heightPtr = height;
    
    return imageData;
}

static MITPowerOf2 MITCalculatePowerOf2ForDimension(
                                                      GLuint dimension)
{
    MITPowerOf2  result = MITGLK1;
    
    if(dimension > (GLuint)MITGLK512)
    {
        result = MITGLK1024;
    }
    else if(dimension > (GLuint)MITGLK256)
    {
        result = MITGLK512;
    }
    else if(dimension > (GLuint)MITGLK128)
    {
        result = MITGLK256;
    }
    else if(dimension > (GLuint)MITGLK64)
    {
        result = MITGLK128;
    }
    else if(dimension > (GLuint)MITGLK32)
    {
        result = MITGLK64;
    }
    else if(dimension > (GLuint)MITGLK16)
    {
        result = MITGLK32;
    }
    else if(dimension > (GLuint)MITGLK8)
    {
        result = MITGLK16;
    }
    else if(dimension > (GLuint)MITGLK4)
    {
        result = MITGLK8;
    }
    else if(dimension > (GLuint)MITGLK2)
    {
        result = MITGLK4;
    }
    else if(dimension > (GLuint)MITGLK1)
    {
        result = MITGLK2;
    }
    
    return result;
}


