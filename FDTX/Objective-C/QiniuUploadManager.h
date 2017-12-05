//
//  QiniuUploadManager.h
//  Qiniu
//
//  Created by 范东 on 16/8/8.
//  Copyright © 2016年 范东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QiniuUploadManager : NSObject

+ (QiniuUploadManager *)default;


/**
 Upload Single Image

 @param image image Object
 @param key key
 @param token token
 @param successBlock successBlock
 @param failBlock failBlock
 @param progressBlock progressBlock
 */
- (void)uploadImage:(UIImage *)image Key:(NSString *)key Token:(NSString *)token SuccessBlock:(void(^)(NSDictionary *info))successBlock failBlock:(void(^)(NSError *error))failBlock ProgressBlock:(void(^)(float percent))progressBlock;


/**
 Upload Muti Image

 @param imageArray imageArray
 @param keyArray keyArray
 @param token token
 @param successBlock successBlock
 @param failBlock failBlock
 @param progressBlock progressBlock
 */
- (void)uploadMutiImage:(NSArray *)imageArray KeyArray:(NSArray *)keyArray Token:(NSString *)token SuccessBlock:(void(^)(NSArray *imgUrlArray))successBlock failBlock:(void(^)(NSError *error))failBlock ProgressBlock:(void(^)(float percent))progressBlock;

/**
 MutiPHAsset

 @param PHAssetArray PHAssetArray
 @param keyArray keysArray
 @param token token
 @param successBlock successBlock
 @param failBlock failBlock
 @param progressBlock progressBlock
 */
- (void)uploadMutiPHAsset:(NSArray *)PHAssetArray KeyArray:(NSArray *)keyArray Token:(NSString *)token SuccessBlock:(void(^)(NSArray *imgUrlArray))successBlock failBlock:(void(^)(NSError *error))failBlock ProgressBlock:(void(^)(float percent))progressBlock;

@end
