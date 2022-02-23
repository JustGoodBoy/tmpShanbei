//
//  SHANShareModel.h
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/10/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^successCompletion)(id data);
typedef void(^failureCompletion)(NSString *errorMessage);

@interface SHANShareModel : NSObject

@property (nonatomic, copy) NSString *content; // 内容
@property (nonatomic, copy) NSString *shortDescription;    // 简短描述
@property (nonatomic, copy) NSString *invitationCode;   // 邀请码
@property (nonatomic, copy) NSString *image;  // 二维码图片
@property (nonatomic, copy) NSString *url;   // 地址
@property (nonatomic, copy) NSString *Description;  // 描述

@end

@interface SHANShareModel (HTTP)
/// 获取分享信息
+ (void)shanGetShareInfoSuccess:(successCompletion)success
                        Failure:(failureCompletion)failure;
@end

NS_ASSUME_NONNULL_END
