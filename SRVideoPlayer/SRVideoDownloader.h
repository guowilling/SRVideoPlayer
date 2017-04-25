//
//  SRVideoDownloader.h
//  SRVideoPlayer
//
//  Created by 郭伟林 on 17/4/6.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SRVideoDownloaderDelegate <NSObject>

- (void)notFindCacheVideoFile;
- (void)didFindCacheVideoFilePath:(NSString *)filePath;

@end

@interface SRVideoDownloader : NSObject

@property(nonatomic, weak) id <SRVideoDownloaderDelegate> delegate;

+ (instancetype)sharedDownloader;

- (void)downloadVideoOfURL:(NSURL *)URL;

/**
 Cancel download video actions, you can call this method when destroy the video player.
 */
- (void)cancelDownloadActions;

/**
 Clear all cached videos.
 */
- (void)clearCachedVideos;

@end
