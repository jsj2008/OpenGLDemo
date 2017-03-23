//
//  MITGLKView.h
//  OpenGLDemo
//
//  Created by MENGCHEN on 2017/3/15.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>


@class EAGLContext;
@class MITGLKView;
@protocol MITGLKViewDelegate<NSObject>

@required
- (void)glkView:(MITGLKView *)view drawInRect:(CGRect)rect;


@end

@interface MITGLKView : UIView
{
    EAGLContext * context;
    GLuint defaultFrameBuffer;
    GLuint colorRenderBuffer;
    GLint drawableWidth;
    GLint drawableHeight;
    
}
/**  */
@property(nonatomic, weak)id<MITGLKViewDelegate> delegate;
/**  */
@property(nonatomic, strong)EAGLContext * context;
/**  */
@property(nonatomic) NSInteger drawableWidth;
/**  */
@property(nonatomic) NSInteger drawableHeight;

- (void)display;

@end



