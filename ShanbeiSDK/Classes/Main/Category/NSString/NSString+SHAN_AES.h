//
//  NSString+SHAN_AES.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SHAN_AES)

/// AES进行加密
+ (NSString *)shan_AES_encryptText:(NSString *)encryptText key:(NSString *)key;

/// AES解密
+ (NSString *)shan_AES_decryptText:(NSString *)decryptText key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
