//
//  SHANUserTaskModel.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHANUserTaskModel : NSObject

@property (nonatomic, copy) NSString *id_;
/// 任务标题
@property (nonatomic, copy) NSString *title;
/// 任务描述
@property (nonatomic, copy) NSString *subheading;
/// 按钮名称
@property (nonatomic, copy) NSString *buttonName;
/// 可领取状态
@property (nonatomic, assign) BOOL gain;
@property (nonatomic, copy) NSString *iconUrl;
/// 奖励积分数
@property (nonatomic, copy) NSString *awardIntegral;
/// 任务类型
@property (nonatomic, copy) NSString *advertisingType;

@end

NS_ASSUME_NONNULL_END
