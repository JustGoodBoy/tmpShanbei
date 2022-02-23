//
//  SHANSecurityUtility.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/17.
//

#import "SHANSecurityUtility.h"
#import <CommonCrypto/CommonDigest.h>
@implementation SHANSecurityUtility

//SHA256加密
+ (NSString *)sha256HashFor:(NSString *)input {
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    ret = (NSMutableString *)[ret uppercaseString];
    return ret;
}

//字典元素拼接,按照字母表顺序排序
+ (NSString *)dictSortWithAllkey:(NSDictionary *)dict {
    NSArray *allKeyArr = dict.allKeys;
    if (allKeyArr.count == 0) {
        return @"";
    }
    
    NSArray *resultkArrSort = [allKeyArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    __block NSString *resultStr = @"";
    [resultkArrSort enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *dictValue = [dict objectForKey:obj];
        if (resultStr.length == 0) {
            resultStr = [NSString stringWithFormat:@"%@=%@",obj,dictValue];
        } else {
            resultStr = [NSString stringWithFormat:@"%@&%@=%@",resultStr,obj,dictValue];
        }
    }];
    return resultStr;
}

@end
