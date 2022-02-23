//
//  ShanOpenAppRecordModel.h
//  Pods
//
//  Created by GoodBoy on 2022/2/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 获取用户打开app信息
@interface ShanOpenAppRecordModel : NSObject
// 用户类型  new新用户   old老用户
@property (nonatomic, copy) NSString *userType;
// 距离上一次打开天数 0为当天有打开  1为昨天有打开   类推
@property (nonatomic, copy) NSString *intervalDays;

@end

@interface ShanOpenAppRecordModel (HTTP)

/// 获取用户打开app信息
+ (void)shan_openAppRecordOfSuccess:(void(^)(ShanOpenAppRecordModel *model))success
                            failure:(void(^)(NSString *errMsg))failure;

@end

NS_ASSUME_NONNULL_END
