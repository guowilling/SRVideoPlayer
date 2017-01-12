//
//  ViewController.m
//  SRVideoPlayerDemo
//
//  Created by 郭伟林 on 17/1/5.
//  Copyright © 2017年 SR. All rights reserved.
//

/**
 *  If you have any question, please issue or contact me.
 *  QQ: 1990991510
 *  Email: guowilling@qq.com
 *
 *  If you like it, please star it, thanks a lot.
 *  Github: https://github.com/guowilling/SRVideoPlayer
 *
 *  Have Fun.
 */

#import "ViewController.h"
#import "VideoViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *localBtn;
@property (weak, nonatomic) IBOutlet UIButton *netBtn;

@end

@implementation ViewController

- (IBAction)localBtnAction {
    
    VideoViewController *videoVC = [[VideoViewController alloc] init];
    videoVC.videoURL = [[NSBundle mainBundle] URLForResource:@"好好(你的名字)" withExtension:@"mp4"];
    [self.navigationController pushViewController:videoVC animated:YES];
}

- (IBAction)netBtnAction {
    
    VideoViewController *videoVC = [[VideoViewController alloc] init];
    videoVC.videoURL = [NSURL URLWithString:@"http://baobab.wdjcdn.com/1442142801331138639111.mp4"];
    [self.navigationController pushViewController:videoVC animated:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"SRVideoPlayer";
    
    [self.localBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.netBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self.localBtn setTitle:@"Local Video" forState:UIControlStateNormal];
    [self.netBtn setTitle:@"Network Video" forState:UIControlStateNormal];
}

@end
