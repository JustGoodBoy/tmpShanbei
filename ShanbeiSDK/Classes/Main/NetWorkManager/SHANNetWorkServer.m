//
//  SHANNetWorkServer.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/10/25.
//

#import "SHANNetWorkServer.h"
#import "SHANNetWorkRequestSetterManager.h"
#import "NSDictionary+SHAN.h"
#import "SHANURL.h"
#import "SHANCommentManager.h"
#import "UIDevice+SHAN_UUID.h"
#import "SHANEncryptionManager.h"
#import "SHANTimeStamp.h"
#import "NSString+SHAN_encryption.h"
#import "NSString+SHAN_RSA.h"
#import "NSString+SHAN_AES.h"
#import "SHANAccountManager.h"
#import "SHANSDKInfoManager.h"

@implementation SHANNetWorkServer
/*
 {
     appId = 2001;
     machine = "12916B8E-71DF-4CE6-833F-462C028D0BFC";
     packageName = "com.mango.dance";
     platform = 2;
     sdkVersion = "1.0.0";
     version = "1.2.4";
     timestamp = @"";
 
 }
 */
/// 初始化网络配置
+ (void)initNetWorkConfig {
    [SHANNetWorkRequestSetterManager mark].shanNetHost = kSHANServerUrl;
    [SHANNetWorkRequestSetterManager mark].shanNetCode = 200;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic shanSetObjectSafely:[SHANCommentManager sharedCommentMark].appId aKey:@"appId"];
    [dic shanSetObjectSafely:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"] aKey:@"packageName"];
    [dic shanSetObjectSafely:@"2" aKey:@"platform"];
    [dic shanSetObjectSafely:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] aKey:@"version"];
    [dic shanSetObjectSafely:[UIDevice shan_uuid] aKey:@"machine"];
//    [dic shanSetObjectSafely:@"12916B8E-71DF-4CE6-833F-462C028D0BF9" aKey:@"machine"];
    [dic shanSetObjectSafely:[SHANSDKInfoManager shanVersion] aKey:@"sdkVersion"];
    [dic shanSetObjectSafely:@"" aKey:@"timestamp"];
    [SHANNetWorkRequestSetterManager mark].shanNetBodyDict = dic;
    
    [self shan_HTTPHeaderFields];
}

+ (NSDictionary *)shan_HTTPHeaderFields {
    NSMutableDictionary *bodyDict = [[SHANNetWorkRequestSetterManager mark].shanNetBodyDict mutableCopy];
    [bodyDict shanSetObjectSafely:[SHANTimeStamp shan_getTimeStampOfMS] aKey:@"timestamp"];
    
    // 获取加密参数
    NSString *signString = [SHANEncryptionManager shan_AESEncryption:bodyDict];
    [bodyDict shanSetObjectSafely:signString aKey:@"sign"];  // 加密参数
    
    NSString *accountId = [SHANAccountManager sharedManager].shanAccountId;
    // 获取随机16位公钥, RSA 加密
    NSString *randomKey = [NSString shan_getRandomString:16];
    NSString *c1 = [NSString shan_RSA_encryptString:randomKey publicKey:RSA_PublicKey];
    
    // AES加密json
    NSString *c2 = [NSString shan_AES_encryptText:accountId key:randomKey];
    
    [bodyDict shanSetObjectSafely:c1 aKey:@"c1"];
    [bodyDict shanSetObjectSafely:c2 aKey:@"c2"];
    
    return [bodyDict copy];
}

@end
