//
//  SRVideoTopBar.m
//  SRVideoPlayer
//
//  Created by 郭伟林 on 17/1/6.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRVideoTopBar.h"
#import "Masonry.h"

#define SRVideoPlayerImageName(fileName) [@"SRVideoPlayer.bundle" stringByAppendingPathComponent:fileName]

@implementation SRVideoTopBar

- (UIButton *)closeBtn {
    
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:SRVideoPlayerImageName(@"close")] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

+ (instancetype)videoTopBar {
    
    return [[SRVideoTopBar alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        
        __weak typeof(self) weakSelf = self;
        
        [self addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(44);
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.closeBtn.mas_right);
            make.right.equalTo(weakSelf.mas_right).offset(-44);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)closeBtnAction {
    
    if ([_delegate respondsToSelector:@selector(videoTopBarDidClickCloseBtn)]) {
        [_delegate videoTopBarDidClickCloseBtn];
    }
}

@end
