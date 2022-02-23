//
//  SHANSignInModel.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/10/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHANSignInModel : NSObject

@property (nonatomic, copy) NSString *continuousSignIn; // 连续签到天数
@property (nonatomic, copy) NSString *title;    // 任务标题
@property (nonatomic, copy) NSString *awardCoin;   // 奖励金币数
@property (nonatomic, copy) NSString *Description;  // 描述
@property (nonatomic, assign) BOOL isSignIn;    // 是否签到

@end

NS_ASSUME_NONNULL_END
