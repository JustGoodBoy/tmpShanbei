//
//  SHANNetWorkRequestCode.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/15.
//

#import "SHANNetWorkRequestCode.h"

@implementation SHANNetWorkRequestCode

- (instancetype)initWithData:(id)data code:(NSInteger)checkCode {
    self = [super init];
    if (self) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [self dictionaryWithJsonString:str];
        self.retDataDict = dic;
        NSInteger code = [[dic objectForKey:@"code"] integerValue];
        if (code == 0) {
            code = [[dic objectForKey:@"status"] integerValue];
        }
        if (code == checkCode) {
            self.success = YES;
        } else {
            self.success = NO;
            self.errMessage = [dic objectForKey:@"message"];
            if (self.errMessage.length == 0) {
                self.errMessage = @"未知错误!";
            } else if (code == 400) {
                self.errMessage = @"请求出错!(400)";
            } else if (code == 404) {
                self.errMessage = @"网络出错!(404)";
            } else if (code == 500) {
                self.errMessage = @"服务器出错!(500)";
            } else if (code == 502) {
                self.errMessage = @"网关出错!(502)";
            }
        }
    }
    return self;
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"SHANNetRequest:json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
