//
//  SHANProfitRecordModel.h
//  Pods
//
//  Created by GoodBoy on 2021/9/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHANProfitRecordModel : NSObject

@property (nonatomic, copy) NSString *createDate;     // 日期
@property (nonatomic, copy) NSString *Description;    // 描述

@property (nonatomic, copy) NSString *cash;  // 金额，分
@property (nonatomic, copy) NSString *coin;  // 积分数
@end

NS_ASSUME_NONNULL_END
