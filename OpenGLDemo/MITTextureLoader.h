//
//  MITTextureLoader.h
//  OpenGLDemo
//
//  Created by MENGCHEN on 2017/3/20.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//


#import <GLKit/GLKit.h>
@interface MITTextureInfo : NSObject
{
    @private
    GLuint name;
    GLenum target;
    GLuint width;
    GLuint height;
}
@property(readonly)GLuint name;
@property(readonly)GLenum target;
@property(readonly)GLuint width;
@property(readonly)GLuint height;
@end

@interface MITTextureLoader : NSObject


+ (MITTextureInfo *)textureWithCGImage:(CGImageRef)cgImage
                               options:(nullable NSDictionary<NSString *,NSNumber *> *)options error:(NSError *__autoreleasing  _Nullable * _Nullable)outError;

@end
