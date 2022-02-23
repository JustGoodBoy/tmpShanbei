//
//  NSString+SHAN_encryption.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SHAN_encryption)

/// 根据ASCII码从小到大排序，并按照“参数=参数值”的模式用“&”字符拼接成字符串（注：要是key没有值不要参与拼接）
+ (NSString *)shan_sortedDict:(NSDictionary *)originParam;

/// MD5
+ (NSString *)shan_stringMD5:(NSString *)string;

/// 字符串反转
+ (NSString *)shan_reversalString:(NSString *)originString;


/// 获取随机数
/// @param num 位数
+ (NSString *)shan_getRandomString:(NSInteger)num;
@end

NS_ASSUME_NONNULL_END
