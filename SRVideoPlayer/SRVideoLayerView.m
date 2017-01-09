//
//  SRVideoLayerView.m
//  SRVideoPlayerDemo
//
//  Created by 郭伟林 on 17/1/5.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRVideoLayerView.h"
#import <AVFoundation/AVFoundation.h>

@implementation SRVideoLayerView

+ (Class)layerClass {
    
    return [AVPlayerLayer class];
}


@end
