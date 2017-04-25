//
//  SRVideoDownloader.m
//  SRVideoPlayer
//
//  Created by 郭伟林 on 17/4/6.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRVideoDownloader.h"
#import <UIKit/UIKit.h>

#define SRVideosDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] \
                            stringByAppendingPathComponent:NSStringFromClass([self class])]

@interface SRVideoDownloader () <NSURLSessionDataDelegate>

@property (nonatomic, copy) NSString *tmpVideoPath;
@property (nonatomic, copy) NSString *cacheVideoPath;

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSFileHandle *fileHandle;

@property (nonatomic, assign) NSInteger downloadedLength;
@property (nonatomic, assign) NSInteger expectedLength;

@end

@implementation SRVideoDownloader

+ (instancetype)sharedDownloader {
    
    static SRVideoDownloader *videoDownloader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        videoDownloader = [[self alloc] init];
    });
    return videoDownloader;
}

- (instancetype)init {
    
    if (self = [super init]) {
        [self createVideosDirectory];
    }
    return self;
}

- (void)createVideosDirectory {
    
    NSString *videosDirectory = SRVideosDirectory;
    BOOL isDirectory = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:videosDirectory isDirectory:&isDirectory];
    if (!isExists || !isDirectory) {
        [fileManager createDirectoryAtPath:videosDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (NSURLSession *)session {
    
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                 delegate:self
                                            delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

- (void)downloadVideoOfURL:(NSURL *)URL {
    
    NSString *videoName = URL.lastPathComponent;
    
    self.cacheVideoPath = [SRVideosDirectory stringByAppendingPathComponent:videoName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.cacheVideoPath]) {
        if ([self.delegate respondsToSelector:@selector(didFindCacheVideoFilePath:)]) {
            [self.delegate didFindCacheVideoFilePath:self.cacheVideoPath];
        }
    } else {
        self.tmpVideoPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:videoName];
        if ([self.delegate respondsToSelector:@selector(notFindCacheVideoFile)]) {
            [self.delegate notFindCacheVideoFile];
        }
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.tmpVideoPath]) {
            _fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.tmpVideoPath];
            _downloadedLength = [_fileHandle seekToEndOfFile];
        } else {
            [[NSFileManager defaultManager] createFileAtPath:self.tmpVideoPath contents:nil attributes:nil];
            _fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.tmpVideoPath];
            _downloadedLength = 0;
        }
        
        NSMutableURLRequest *requeset = [NSMutableURLRequest requestWithURL:URL];
        [requeset setValue:[NSString stringWithFormat:@"bytes=%ld-", _downloadedLength] forHTTPHeaderField:@"Range"];
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:requeset];
        [dataTask resume];
    }
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(nonnull NSURLSessionDataTask *)dataTask didReceiveResponse:(nonnull NSURLResponse *)response completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary *allHeaderFields = [httpResponse allHeaderFields];
    NSString *contentRange = [allHeaderFields valueForKey:@"Content-Range"];
    _expectedLength = [contentRange componentsSeparatedByString:@"/"].lastObject.integerValue;
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    [_fileHandle writeData:data];
    _downloadedLength += data.length;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if (error) {
        NSLog(@"error: %@", error);
        return;
    }
    if ([[NSFileManager defaultManager] moveItemAtPath:self.tmpVideoPath toPath:self.cacheVideoPath error:nil]) {
        NSLog(@"cacheVideoPath: %@", self.cacheVideoPath);
    }
}

#pragma mark - Public Methods

- (void)cancelDownloadActions {
    
    [self.session invalidateAndCancel];
    [self setSession:nil];
}

- (void)clearCachedVideos {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:SRVideosDirectory]) {
        [fileManager removeItemAtPath:SRVideosDirectory error:nil];
        [self createVideosDirectory];
    }
}

@end
