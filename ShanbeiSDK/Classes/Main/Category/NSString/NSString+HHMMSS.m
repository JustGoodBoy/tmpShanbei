//
//  NSString+HHMMSS.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/11/19.
//

#import "NSString+HHMMSS.h"

@implementation NSString (HHMMSS)

/// SS --> HH:MM:SS
+ (NSString *)shan_getHHMMSSFromSS:(NSInteger)seconds {
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}

/// SS --> MM分SS秒
+ (NSString *)shan_getMMSSFromSS:(NSInteger)seconds {
    NSString *str_second = [NSString stringWithFormat:@"%ld",seconds%60];
    
    NSString *format_time = @"";
    if (seconds/3600 > 0){
        
        NSString *str_hour = [NSString stringWithFormat:@"%ld",seconds/3600];
        NSString *str_minute = [NSString stringWithFormat:@"%ld",(seconds%3600)/60];
        
        format_time = [NSString stringWithFormat:@"%@时%@分%@秒",str_hour,str_minute,str_second];
        
    } else if ((seconds%3600)/60 > 0) {
        NSString *str_minute = [NSString stringWithFormat:@"%ld",(seconds%3600)/60];
        
        format_time = [NSString stringWithFormat:@"%@分%@秒",str_minute,str_second];
        
    } else {
        format_time = [NSString stringWithFormat:@"%@秒",str_second];
    }
    
    return format_time;
}

/// SS --> MM:SS
+ (NSString *)shan_getNoUnitMMSSFromSS:(NSInteger)seconds {
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    NSString *format_time = @"";
    if (seconds/3600 > 0){
        NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
        format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    } else {
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
        format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    }
    return format_time;
}

@end
