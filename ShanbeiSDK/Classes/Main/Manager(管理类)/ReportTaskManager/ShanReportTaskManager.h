//
//  ShanReportTaskManager.h
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/11/19.
//

#import <Foundation/Foundation.h>
#import "SHANMenu.h"
NS_ASSUME_NONNULL_BEGIN

@interface ShanReportTaskManager : NSObject

/// 接口上报
+ (void)shanReportTaskWithType:(SHANTaskListType)type
                        taskId:(NSString *)taskId
                       success:(void(^)(NSDictionary *dic))success
                       failure:(void(^)(NSString *errorMessage))failure;

/// 获取token
+ (void)shan_getEncryptTokenOfSuccess:(void(^)(NSString *token))success
                              failure:(void(^)(NSString *errorMessage))failure;
@end

NS_ASSUME_NONNULL_END
