//
//  SRVideoBottomView.m
//  SRVideoPlayerDemo
//
//  Created by 郭伟林 on 17/1/5.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRVideoBottomBar.h"
#import "Masonry.h"

#define SRVideoPlayerImageName(fileName) [@"SRVideoPlayer.bundle" stringByAppendingPathComponent:fileName]

@interface SRVideoBottomBar ()

@end

@implementation SRVideoBottomBar

- (UIButton *)playPauseBtn {
    
    if (!_playPauseBtn) {
        _playPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playPauseBtn setImage:[UIImage imageNamed:SRVideoPlayerImageName(@"pause")] forState:UIControlStateNormal];
        [_playPauseBtn addTarget:self action:@selector(playPauseBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playPauseBtn;
}

- (UIButton *)changeScreenBtn {
    
    if (!_changeScreenBtn) {
        _changeScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeScreenBtn setImage:[UIImage imageNamed:SRVideoPlayerImageName(@"full_screen")] forState:UIControlStateNormal];
        [_changeScreenBtn addTarget:self action:@selector(changeScreenBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeScreenBtn;
}

- (UILabel *)currentTimeLabel {
    
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc]init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:12.0];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (UILabel *)totalTimeLabel {
    
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc]init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:12.0];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UISlider *)videoProgressSlider {
    
    if (!_videoProgressSlider) {
        _videoProgressSlider = [[UISlider alloc] init];
        _videoProgressSlider.minimumTrackTintColor = [UIColor whiteColor];
        _videoProgressSlider.maximumTrackTintColor = [UIColor colorWithWhite:0 alpha:0.5];
        [_videoProgressSlider setThumbImage:[UIImage imageNamed:SRVideoPlayerImageName(@"dot")] forState:UIControlStateNormal];
        [_videoProgressSlider addTarget:self action:@selector(sliderChanging:) forControlEvents:UIControlEventValueChanged];
        [_videoProgressSlider addTarget:self action:@selector(sliderDidEndChange:) forControlEvents:UIControlEventTouchUpInside];
        [_videoProgressSlider addTarget:self action:@selector(sliderDidEndChange:) forControlEvents:UIControlEventTouchUpOutside];
        [_videoProgressSlider addTarget:self action:@selector(sliderDidEndChange:) forControlEvents:UIControlEventTouchCancel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapAction:)];
        [self.videoProgressSlider addGestureRecognizer:tap];
    }
    return _videoProgressSlider;
}

- (UIProgressView *)videoCacheProgress {
    
    if (!_videoCacheProgress) {
        _videoCacheProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _videoCacheProgress.progressTintColor = [UIColor colorWithWhite:1 alpha:0.75];
        _videoCacheProgress.trackTintColor = [UIColor clearColor];
        _videoCacheProgress.layer.cornerRadius = 0.5;
        _videoCacheProgress.layer.masksToBounds = YES;
    }
    return _videoCacheProgress;
}

+ (instancetype)videoBottomBar {
    
    return [[SRVideoBottomBar alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        __weak typeof(self) weakSelf = self;
        
        [self addSubview:self.playPauseBtn];
        [self.playPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(44);
        }];
        
        [self addSubview:self.currentTimeLabel];
        [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.playPauseBtn.mas_right);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(55);
            make.height.mas_equalTo(44);
        }];
        
        [self addSubview:self.changeScreenBtn];
        [self.changeScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(44);
        }];
        
        [self addSubview:self.totalTimeLabel];
        [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.equalTo(weakSelf.changeScreenBtn.mas_left);
            make.width.mas_equalTo(55);
            make.height.mas_equalTo(44);
        }];
        
        [self addSubview:self.videoProgressSlider];
        [self.videoProgressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.currentTimeLabel.mas_right);
            make.top.mas_equalTo(0);
            make.right.equalTo(weakSelf.totalTimeLabel.mas_left);
            make.bottom.mas_equalTo(0);
        }];
        
        [self addSubview:self.videoCacheProgress];
        [self.videoCacheProgress mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.currentTimeLabel.mas_right);
            make.right.equalTo(weakSelf.totalTimeLabel.mas_left);
            make.centerY.equalTo(weakSelf.videoProgressSlider.mas_centerY).offset(1);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)playPauseBtnAction {
    
    if ([_delegate respondsToSelector:@selector(videoBottomBarDidClickPlayPauseBtn)]) {
        [_delegate videoBottomBarDidClickPlayPauseBtn];
    }
}

- (void)changeScreenBtnAction {
    
    if ([_delegate respondsToSelector:@selector(videoBottomBarDidClickChangeScreenBtn)]) {
        [_delegate videoBottomBarDidClickChangeScreenBtn];
    }
}

- (void)sliderChanging:(UISlider *)sender {
    
    if ([_delegate respondsToSelector:@selector(videoBottomBarChangingSlider:)]) {
        [_delegate videoBottomBarChangingSlider:sender];
    }
}

- (void)sliderDidEndChange:(UISlider *)sender {
    
    if ([_delegate respondsToSelector:@selector(videoBottomBarDidEndChangeSlider:)]) {
        [_delegate videoBottomBarDidEndChangeSlider:sender];
    }
}

- (void)sliderTapAction:(UITapGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(videoBottomBarDidTapSlider:withTap:)]) {
        [_delegate videoBottomBarDidTapSlider:self.videoProgressSlider withTap:tap];
    }
}

@end
