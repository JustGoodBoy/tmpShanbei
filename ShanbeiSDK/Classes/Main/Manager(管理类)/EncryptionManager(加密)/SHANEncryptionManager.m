//
//  SHANEncryptionManager.m
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/12/9.
//

#import "SHANEncryptionManager.h"
#import "NSString+SHAN_encryption.h"
#import "NSString+SHAN_AES.h"
#import "NSString+SHAN_RSA.h"

static NSString *const AES_KEY = @"06EE2D7C2F4FA5DA";


@implementation SHANEncryptionManager
/**
 * 加密逻辑：
 * 1、根据ASCII码从小到大排序，并按照“参数=参数值”的模式用“&”字符拼接成字符串（注：要是key没有值不要参与拼接）
 * 2、对排序后的结果进行反转
 * 3、使用AES进行加密
 * 4、对AES加密结果进行MD5加密
 * 5、对MD5加密后的结果进行反转
 */

/// 获取加密参数
+ (NSString *)shan_AESEncryption:(NSDictionary *)originParam {
    // 1、根据ASCII码从小到大排序，并按照“参数=参数值”的模式用“&”字符拼接成字符串（注：要是key没有值不要参与拼接）
    NSString *contentString = [NSString shan_sortedDict:originParam];
    
    // 2、对排序后的结果进行反转
    NSString *reversalStr = [NSString shan_reversalString:contentString];
    
    // 3、使用AES进行加密
    NSString *AES_string = [NSString shan_AES_encryptText:reversalStr key:AES_KEY];
    
    // 4、对AES加密结果进行MD5加密
    NSString *md5_string = [NSString shan_stringMD5:AES_string];
    
    // 5、对MD5加密后的结果进行反转
    NSString *md5_reversalString = [NSString shan_reversalString:md5_string];
    
    return md5_reversalString;
}

@end
