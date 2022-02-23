//
//  NSString+SHAN_AES.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/12/9.
//

#import "NSString+SHAN_AES.h"
#import <CommonCrypto/CommonCryptor.h>

// 尊重作者:    http://m.mamicode.com/info-detail-2707449.html

@implementation NSString (SHAN_AES)

#pragma mark - AES加密
/// AES进行加密
+ (NSString *)shan_AES_encryptText:(NSString *)encryptText key:(NSString *)key {
    if(!encryptText) return @"";
    
    char keyPtr[kCCKeySizeAES128+1];
        memset(keyPtr, 0, sizeof(keyPtr));
        [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
        
        NSData* data = [encryptText dataUsingEncoding:NSUTF8StringEncoding];
        NSUInteger dataLength = [data length];
        
        size_t bufferSize = dataLength + kCCBlockSizeAES128;
        void *buffer = malloc(bufferSize);
        size_t numBytesEncrypted = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                              kCCAlgorithmAES128,
                                              kCCOptionPKCS7Padding|kCCOptionECBMode,
                                              keyPtr,
                                              kCCBlockSizeAES128,
                                              NULL,
                                              [data bytes],
                                              dataLength,
                                              buffer,
                                              bufferSize,
                                              &numBytesEncrypted);
        if (cryptStatus == kCCSuccess) {
            NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
            NSString *stringBase64 = [resultData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]; // base64格式的字符串
            return stringBase64;
        }
        free(buffer);
        return nil;
}

#pragma mark - AES解密
/// AES解密
+ (NSString *)shan_AES_decryptText:(NSString *)decryptText key:(NSString *)key {
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:decryptText options:NSDataBase64DecodingIgnoreUnknownCharacters];//base64解码
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    return nil;
}

@end
