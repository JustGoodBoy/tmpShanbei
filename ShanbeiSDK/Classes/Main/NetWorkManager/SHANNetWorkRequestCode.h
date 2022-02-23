//
//  SHANNetWorkRequestCode.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHANNetWorkRequestCode : NSObject

@property (nonatomic) BOOL success;
@property (nonatomic, copy) NSString *errMessage;
@property (nonatomic, strong) NSDictionary *retDataDict;

- (instancetype)initWithData:(id)data code:(NSInteger)checkCode;

@end

NS_ASSUME_NONNULL_END
