//
//  SHANUserAccountModel.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHANUserAccountModel : NSObject

@property (nonatomic, copy) NSString *coin;     // 积分数
@property (nonatomic, copy) NSString *cash;     // 现金，分
@property (nonatomic, copy) NSString *cashRmb;  // 现金

@end

NS_ASSUME_NONNULL_END
