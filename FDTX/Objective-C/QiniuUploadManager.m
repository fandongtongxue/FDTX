//
//  QiniuUploadManager.m
//  Qiniu
//
//  Created by 范东 on 16/8/8.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "QiniuUploadManager.h"
#import "QiniuSDK.h"

@implementation QiniuUploadManager

+ (QiniuUploadManager *)default{
    static QiniuUploadManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)uploadImage:(UIImage *)image Key:(NSString *)key Token:(NSString *)token SuccessBlock:(void(^)(NSDictionary *info))successBlock failBlock:(void(^)(NSError *error))failBlock ProgressBlock:(void(^)(float percent))progressBlock{
    QNUploadOption *option = [[QNUploadOption alloc]initWithProgressHandler:^(NSString *key, float percent) {
        progressBlock(percent);
    }];
    QNUploadManager *manager = [[QNUploadManager alloc]init];
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    [manager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (resp) {
            successBlock(resp);
        }else{
            failBlock([NSError errorWithDomain:@"com.QiniuCloudStorge" code:1 userInfo:@{@"info":@"Upload Failed"}]);
        }
    } option:option];
}

- (void)uploadMutiImage:(NSArray *)imageArray Key:(NSString *)key Token:(NSString *)token SuccessBlock:(void(^)(NSArray *imgUrlArray))successBlock failBlock:(void(^)(NSError *error))failBlock ProgressBlock:(void(^)(float percent))progressBlock{
    QNUploadOption *option = [[QNUploadOption alloc]initWithProgressHandler:^(NSString *key, float percent) {
        progressBlock(percent);
    }];
    QNUploadManager *manager = [[QNUploadManager alloc]init];
    NSMutableArray *imgUrlArray = [NSMutableArray array];
    for (UIImage *image in imageArray) {
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        [manager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (resp) {
                NSString *imgUrl = [NSString stringWithFormat:@"http://ov2uvg3mg.bkt.clouddn.com/%@",key];
                [imgUrlArray addObject:imgUrl];
                if (imgUrlArray.count == imageArray.count) {
                    successBlock(imgUrlArray);
                }
            }else{
                failBlock([NSError errorWithDomain:@"com.QiniuCloudStorge" code:1 userInfo:@{@"info":@"Upload Failed"}]);
            }
        } option:option];
    }
}

@end
