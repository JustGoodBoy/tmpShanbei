//
//  SHANNetWorkRequestSerivce.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *const GET;
FOUNDATION_EXTERN NSString *const POST;

typedef void(^completionHandler)(id data,NSError *error);

typedef void(^successHandler)(id data);

typedef void(^errHandler)(NSError *error);

@interface SHANNetWorkRequestSerivce : NSObject

+ (SHANNetWorkRequestSerivce *)httpService;

- (void)sendRequestWithHttpMethod:(NSString *)method
                          URLPath:(NSString *)pathString
                       parameters:(id)parameters
                completionHandler:(completionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
