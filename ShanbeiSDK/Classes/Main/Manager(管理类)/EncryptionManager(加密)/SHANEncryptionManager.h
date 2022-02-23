//
//  SHANEncryptionManager.h
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface SHANEncryptionManager : NSObject


/// 获取加密参数
+ (NSString *)shan_AESEncryption:(NSDictionary *)originParam;


@end

NS_ASSUME_NONNULL_END
