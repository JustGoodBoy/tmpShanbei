//
//  NSString+SHAN_encryption.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/12/9.
//

#import "NSString+SHAN_encryption.h"
#import "SHANHeader.h"
#import <CommonCrypto/CommonDigest.h> 
@implementation NSString (SHAN_encryption)

/// 根据ASCII码从小到大排序，并按照“参数=参数值”的模式用“&”字符拼接成字符串（注：要是key没有值不要参与拼接）
+ (NSString *)shan_sortedDict:(NSDictionary *)originParam {
    NSMutableString *contentString = [NSMutableString string];

    NSArray *keys = [originParam allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        
        NSString *categoryIdV = [originParam objectForKey:categoryId];
        
        if ([contentString length] <= 0) {
            //第一个参数
        }else{
            [contentString appendString:@"&"];
        }
        
        // 没有值,不参与拼接
        if (kSHANStringIsEmpty(categoryIdV)) continue;
        
        [contentString appendFormat:@"%@=%@", categoryId,categoryIdV ];
    }
    NSLog(@"contentString:%@",contentString);
    return contentString;
}

/// MD5
+ (NSString *)shan_stringMD5:(NSString *)string {
    NSParameterAssert(string != nil && [string length] > 0);
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x", outputBuffer[count]];
    }
    
    return outputString;
}

/// 字符串反转
+ (NSString *)shan_reversalString:(NSString *)originString {
    
    NSString *resultStr = @"";
    for (NSInteger i = originString.length -1; i >= 0; i--) {
      NSString *indexStr = [originString substringWithRange:NSMakeRange(i, 1)];
      resultStr = [resultStr stringByAppendingString:indexStr];
    }
    NSLog(@"reversalString:%@",resultStr);
    return resultStr;
}


+ (NSString *)shan_getRandomString:(NSInteger)num {
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    NSMutableString *resultStr = [[NSMutableString alloc] init];

    srand((unsigned)time(0));

    for (int i = 0; i < num; i++) {
        unsigned index = rand() % [sourceStr length];

        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];

        [resultStr appendString:oneStr];
    }
    return resultStr;

}

@end
