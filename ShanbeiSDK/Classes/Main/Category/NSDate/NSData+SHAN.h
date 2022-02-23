//
//  NSData+SHAN.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/1/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (SHAN)

+ (BOOL)shan_isWithinTimePeriod:(NSString *)timePeriod;

@end

NS_ASSUME_NONNULL_END
