//
//  SHANCashOutModel.h
//  Pods
//
//  Created by GoodBoy on 2021/9/23.
//

#import <Foundation/Foundation.h>
@class SHANWXUserInfoModel;
@class SHANCashDrawalModel;

NS_ASSUME_NONNULL_BEGIN

@interface SHANCashOutModel : NSObject

@property (nonatomic, strong) SHANWXUserInfoModel *weChatInfo;  // 微信信息
@property (nonatomic, strong) NSArray<SHANCashDrawalModel *> *cashWithdrawalAmountList; // 提现金额列表
@property (nonatomic, copy) NSString *cash;   // 可提现金额，分
@property (nonatomic, copy) NSString *withdrawDepositCount; // 提现成功次数
@end

NS_ASSUME_NONNULL_END
