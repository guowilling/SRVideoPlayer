//
//  SRVideoDownloader.h
//  SRVideoPlayer
//
//  Created by https://github.com/guowilling on 17/4/6.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SRDownloadProgressBlock)(CGFloat progress);
typedef void (^SRDownloadCompletionBlock)(NSString *cacheVideoPath, NSError *error);

@interface SRVideoDownloader : NSObject

+ (instancetype)sharedDownloader;

- (NSString *)querySandboxWithURL:(NSURL *)URL;

- (void)downloadVideoOfURL:(NSURL *)URL progress:(SRDownloadProgressBlock)progress completion:(SRDownloadCompletionBlock)completion;

- (void)cancelDownloadActions;

- (void)clearCachedVideos;

@end
