//
//  MITMultiTextureViewController.m
//  OpenGLDemo
//
//  Created by MENGCHEN on 2017/3/21.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//

#import "MITMultiTextureViewController.h"



@interface GLKEffectPropertyTexture(MITAddtions)
- (void)mitSetParameter:(GLenum)parameterID value:(GLuint)value;


@end
@implementation GLKEffectPropertyTexture(MITAddtions)
- (void)mitSetParameter:(GLenum)parameterID value:(GLuint)value{
    glBindTexture(self.target, self.name);
    glTexParameteri(self.target, parameterID, value);
}




@end




@interface MITMultiTextureViewController ()





@end

@implementation MITMultiTextureViewController

@synthesize baseEffect;
@synthesize vertexBuffer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
