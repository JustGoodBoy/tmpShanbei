//
//  SHANSecurityUtility.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHANSecurityUtility : NSObject

// SHA256加密
+ (NSString *)sha256HashFor:(NSString *)input;

// 字典元素拼接,按照字母表顺序排序
+ (NSString *)dictSortWithAllkey:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
