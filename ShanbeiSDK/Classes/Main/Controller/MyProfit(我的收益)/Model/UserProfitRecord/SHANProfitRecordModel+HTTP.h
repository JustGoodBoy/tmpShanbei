//
//  SHANProfitRecordModel+HTTP.h
//  Pods
//
//  Created by GoodBoy on 2021/9/18.
//

#import "SHANProfitRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, SHANRecordType) {
    SHANRecordTypeCoin = 0, // 积分
    SHANRecordTypeCash      // cash
};

typedef void(^successCompletion)(id data);
typedef void(^failureCompletion)(NSString *errorMessage);

@interface SHANProfitRecordModel (HTTP)


/// 获取coin/cash记录
/// @param type coin/cash
+ (void)shanGetCoinRecordWithType:(SHANRecordType)type
                          success:(successCompletion)success
                          failure:(failureCompletion)failure;
@end

NS_ASSUME_NONNULL_END
