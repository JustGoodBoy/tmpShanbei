//
//  SHANCommentManager.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/15.
//

#import <Foundation/Foundation.h>
#import "ShanbeiManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface SHANCommentManager : NSObject

+ (instancetype)sharedCommentMark;

@property (nonatomic, assign) BOOL isShowNavBack;

@property (nonatomic, assign) SHANShowViewControllerType showType;

@property (nonatomic, copy) NSString *appId;

@end

NS_ASSUME_NONNULL_END
