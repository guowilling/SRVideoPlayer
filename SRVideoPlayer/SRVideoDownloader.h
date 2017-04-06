//
//  SRVideoDownloader.h
//  SRVideoPlayerDemo
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
 Cancel the current download video action, you can call this method when destroy the video player.
 */
- (void)cancelDownloadAction;

/**
 Clear all cached videos.
 */
- (void)clearCachedVideos;

@end
