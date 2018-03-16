//
//  SRVideoDownloader.m
//  SRVideoPlayer
//
//  Created by https://github.com/guowilling on 17/4/6.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRVideoDownloader.h"
#import <UIKit/UIKit.h>

#define SRVideoDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] \
                           stringByAppendingPathComponent:NSStringFromClass([self class])]

@interface SRVideoDownloader () <NSURLSessionDataDelegate>

@property (nonatomic, copy) NSString *tmpVideoPath;
@property (nonatomic, copy) NSString *cacheVideoPath;

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSFileHandle *fileHandle;

@property (nonatomic, assign) NSInteger downloadedLength;
@property (nonatomic, assign) NSInteger expectedLength;

@property (nonatomic, copy) SRDownloadProgressBlock progress;
@property (nonatomic, copy) SRDownloadCompletionBlock completion;

@end

@implementation SRVideoDownloader

- (NSURLSession *)session {
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                 delegate:self
                                            delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

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
        [self createVideoDirectory];
    }
    return self;
}

- (void)createVideoDirectory {
    NSString *videosDirectory = SRVideoDirectory;
    BOOL isDirectory = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:videosDirectory isDirectory:&isDirectory];
    if (!isExists || !isDirectory) {
        [fileManager createDirectoryAtPath:videosDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (NSString *)querySandboxWithURL:(NSURL *)URL {
    NSString *videoName = URL.lastPathComponent;
    NSString *cachePath = [SRVideoDirectory stringByAppendingPathComponent:videoName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        return cachePath;
    }
    return nil;
}

- (void)downloadVideoOfURL:(NSURL *)URL progress:(SRDownloadProgressBlock)progress completion:(SRDownloadCompletionBlock)completion {
    if (!URL) {
        return;
    }
    if (![URL.absoluteString containsString:@"http"] && ![URL.absoluteString containsString:@"https"]) {
        NSLog(@"It is not a remote video");
        return;
    }
    self.progress = progress;
    self.completion = completion;
    
    NSString *videoName = URL.lastPathComponent;
    self.cacheVideoPath = [SRVideoDirectory stringByAppendingPathComponent:videoName];
    
    self.tmpVideoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:videoName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.tmpVideoPath]) {
        self.fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.tmpVideoPath];
        self.downloadedLength = [self.fileHandle seekToEndOfFile];
    } else {
        [[NSFileManager defaultManager] createFileAtPath:self.tmpVideoPath contents:nil attributes:nil];
        self.fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.tmpVideoPath];
        self.downloadedLength = 0;
    }
    
    NSMutableURLRequest *requesetM = [NSMutableURLRequest requestWithURL:URL];
    [requesetM setValue:[NSString stringWithFormat:@"bytes=%ld-", _downloadedLength] forHTTPHeaderField:@"Range"];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:requesetM];
    [dataTask resume];
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(nonnull NSURLSessionDataTask *)dataTask didReceiveResponse:(nonnull NSURLResponse *)response completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
    NSDictionary *allHeaderFields = [httpURLResponse allHeaderFields];
    NSString *contentRange = [allHeaderFields valueForKey:@"Content-Range"];
    self.expectedLength = [contentRange componentsSeparatedByString:@"/"].lastObject.integerValue;
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.fileHandle writeData:data];
    self.downloadedLength += data.length;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.progress) {
            self.progress(1.0 * self.downloadedLength / self.expectedLength);
        }
    });
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        if (self.completion) {
            self.completion(nil, error);
        }
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.completion) {
            self.completion(self.cacheVideoPath, nil);
        }
    });
    NSError *moveItemError;
    if (![[NSFileManager defaultManager] moveItemAtPath:self.tmpVideoPath toPath:self.cacheVideoPath error:&moveItemError]) {
        NSLog(@"moveItemAtPath error: %@", moveItemError);
    }
}

#pragma mark - Public Methods

- (void)cancelDownloadActions {
    [self.session invalidateAndCancel];
    [self setSession:nil];
}

- (void)clearCachedVideos {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:SRVideoDirectory]) {
        [fileManager removeItemAtPath:SRVideoDirectory error:nil];
        [self createVideoDirectory];
    }
}

@end
