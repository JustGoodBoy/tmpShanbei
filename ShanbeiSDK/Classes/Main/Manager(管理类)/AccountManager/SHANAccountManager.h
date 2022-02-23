//
//  SHANAccountManager.h
//  Pods
//
//  Created by GoodBoy on 2021/9/18.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface SHANAccountManager : NSObject

/// accountId
@property (nonatomic, copy) NSString *shanAccountId;
@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, copy) NSString *coin;     // 积分数
@property (nonatomic, copy) NSString *cash;     // 现金，分
@property (nonatomic, copy) NSString *cashRmb;  // 现金

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *headImgUrl;

+ (instancetype)sharedManager;


@end

NS_ASSUME_NONNULL_END
