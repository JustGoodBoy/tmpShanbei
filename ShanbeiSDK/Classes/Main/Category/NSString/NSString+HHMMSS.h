//
//  NSString+HHMMSS.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/11/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HHMMSS)
/// SS --> HH:MM:SS
+ (NSString *)shan_getHHMMSSFromSS:(NSInteger)seconds;

/// SS --> MM分SS秒
+ (NSString *)shan_getMMSSFromSS:(NSInteger)seconds;

/// SS --> MM:SS
+ (NSString *)shan_getNoUnitMMSSFromSS:(NSInteger)seconds;
@end

NS_ASSUME_NONNULL_END
