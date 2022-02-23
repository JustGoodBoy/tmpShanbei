//
//  SHANCashDrawalModel.h
//  Pods
//
//  Created by GoodBoy on 2021/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHANCashDrawalModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *money;   // 提现金额，分
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSString *withdrawalCount; // 提款次数需满足才可提现
@end

NS_ASSUME_NONNULL_END
