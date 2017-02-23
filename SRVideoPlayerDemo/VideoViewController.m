//
//  VideoViewController.m
//  SRVideoPlayerDemo
//
//  Created by 郭伟林 on 17/1/5.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "VideoViewController.h"
#import "SRVideoPlayer.h"

@interface VideoViewController ()

@property (nonatomic, strong) SRVideoPlayer *videoPlayer;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self showVideoPlayer];
}

- (void)showVideoPlayer {
    
    UIView *playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    playerView.center = self.view.center;
    [self.view addSubview:playerView];
    _videoPlayer = [SRVideoPlayer playerWithVideoURL:_videoURL playerView:playerView playerSuperView:playerView.superview];
    _videoPlayer.videoName = @"Here Is The Video Name";
    _videoPlayer.playerEndAction = SRVideoPlayerEndActionStop;
    [_videoPlayer play];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [_videoPlayer destroyPlayer];
}

@end
