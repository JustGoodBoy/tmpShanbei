//
//  NSData+SHAN.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/1/25.
//

#import "NSData+SHAN.h"

@implementation NSData (SHAN)

/// 判断当前时间是否在时间段内
- (BOOL)shan_isWithinTimePeriod:(NSString *)timePeriod {
    NSArray *timeArray = [timePeriod componentsSeparatedByString:@"-"];
    if (timeArray.count < 2) return false;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *minTimeString = [NSString stringWithFormat:@"%@ %@:00",dateStr,timeArray[0]];
    NSString *maxTimeString = [NSString stringWithFormat:@"%@ %@:00",dateStr,timeArray[1]];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *minDate = [timeFormatter dateFromString:minTimeString];
    NSDate *maxDate = [timeFormatter dateFromString:maxTimeString];
    
    NSTimeInterval minTimeStamp = [minDate timeIntervalSince1970];
    NSTimeInterval maxTimeStamp = [maxDate timeIntervalSince1970];
    NSTimeInterval nowTimeStamp = [[NSDate date] timeIntervalSince1970];
    if (nowTimeStamp > minTimeStamp && nowTimeStamp < maxTimeStamp) {
        return true;
    }
    return false;
}

@end
