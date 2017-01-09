//
//  SRVideoBottomView.h
//  SRVideoPlayerDemo
//
//  Created by 郭伟林 on 17/1/5.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SRVideoBottomBarDelegate <NSObject>

- (void)videoBottomBarDidClickPlayPauseBtn;
- (void)videoBottomBarDidClickChangeScreenBtn;
- (void)videoBottomBarDidTapSlider:(UISlider *)slider withTap:(UITapGestureRecognizer *)tap;
- (void)videoBottomBarChangingSlider:(UISlider *)slider;
- (void)videoBottomBarDidEndChangeSlider:(UISlider *)slider;

@end

@interface SRVideoBottomBar : UIView

@property (nonatomic, weak) id<SRVideoBottomBarDelegate> delegate;

@property (nonatomic, strong) UIButton       *playPauseBtn;
@property (nonatomic, strong) UIButton       *changeScreenBtn;

@property (nonatomic, strong) UILabel        *currentTimeLabel;
@property (nonatomic, strong) UILabel        *totalTimeLabel;

@property (nonatomic, strong) UISlider       *videoProgressSlider;
@property (nonatomic, strong) UIProgressView *videoCacheProgress;

+ (instancetype)videoBottomBar;

@end
