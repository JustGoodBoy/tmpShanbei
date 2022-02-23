//
//  SHANNetWorkRequestSerivce.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/15.
//

#import "SHANNetWorkRequestSerivce.h"
#import "SHANNetWorkRequestSetterManager.h"
#import "SHANNetWorkServer.h"
@interface SHANNetWorkRequestSerivce ()<NSURLSessionDelegate>

@end

@implementation SHANNetWorkRequestSerivce

+ (SHANNetWorkRequestSerivce *)httpService {
    static SHANNetWorkRequestSerivce *service = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[SHANNetWorkRequestSerivce alloc] init];
    });
    return service;
}

- (void)sendRequestWithHttpMethod:(NSString *)method
                          URLPath:(NSString *)pathString
                       parameters:(id)parameters
                completionHandler:(completionHandler)completionHandler {
    //初始化请求
    NSMutableURLRequest *request = [self requestWithMethod:method URLString:pathString parameters:parameters error:nil];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler) {
                completionHandler(data, error);
            }
        });
    }];
    [dataTask resume];
}

#pragma mark - Private
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                                     error:(NSError *__autoreleasing *)error {
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    NSDictionary *bodyDict = [SHANNetWorkRequestSetterManager mark].shanNetBodyDict;
    
    if ([method isEqualToString:@"GET"]) {
        NSMutableDictionary *muDict = [[NSMutableDictionary alloc] init];
        [muDict addEntriesFromDictionary:parameters];
        NSString *baseStr = [[url absoluteString] stringByAppendingFormat:url.query ? @"&%@" : @"?%@",[self transformWithDictionary:muDict]];
        baseStr = [baseStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        baseStr = [baseStr stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        baseStr = [baseStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [NSCharacterSet URLQueryAllowedCharacterSet];
        
        NSURL *baseUrl = [NSURL URLWithString:[baseStr stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [mutableRequest setURL:baseUrl];
    } else {
        //将参数格式化成json
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:(NSJSONWritingPrettyPrinted) error:nil];
        [mutableRequest setHTTPBody:jsonData];
        [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    NSDictionary *bodyDict = [SHANNetWorkServer shan_HTTPHeaderFields];
    [mutableRequest setHTTPMethod:method];
    [mutableRequest setAllHTTPHeaderFields:bodyDict];
    
    return mutableRequest;
}

#pragma mark - Private
- (NSString *)transformWithDictionary:(NSDictionary *)dic {
    //取出键值对，并将每个键值对放入数组
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSString *key in dic) {
        NSString *value = [NSString stringWithFormat:@"%@=%@",key,dic[key]];
        [resultArray addObject:value];
    }
    //resultArray数组中每一个元素都是一个键值对，我们只需要将数组中每个元素符号拼接即可。
    NSString *resultString = [resultArray componentsJoinedByString:@"&"];
    return resultString;
}

@end
