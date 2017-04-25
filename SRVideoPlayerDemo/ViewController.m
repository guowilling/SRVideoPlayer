//
//  ViewController.m
//  SRVideoPlayerDemo
//
//  Created by 郭伟林 on 17/1/5.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "VideoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"SRVideoPlayer";
}

- (IBAction)localBtnAction {
    
    VideoViewController *videoVC = [[VideoViewController alloc] init];
    videoVC.videoURL = [[NSBundle mainBundle] URLForResource:@"好好(你的名字)" withExtension:@"mp4"];
    [self.navigationController pushViewController:videoVC animated:YES];
}

- (IBAction)networkBtnAction {
    
    VideoViewController *videoVC = [[VideoViewController alloc] init];
    videoVC.videoURL = [NSURL URLWithString:@"http://yxfile.idealsee.com/9f6f64aca98f90b91d260555d3b41b97_mp4.mp4"];
    [self.navigationController pushViewController:videoVC animated:YES];
}

@end
