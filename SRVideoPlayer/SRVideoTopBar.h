//
//  SRVideoTopBar.h
//  SRVideoPlayerDemo
//
//  Created by 郭伟林 on 17/1/6.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SRVideoTopBarBarDelegate <NSObject>

- (void)videoTopBarDidClickCloseBtn;

@end

@interface SRVideoTopBar : UIView

@property (nonatomic, weak) id<SRVideoTopBarBarDelegate> delegate;

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel  *titleLabel;

+ (instancetype)videoTopBar;

@end
