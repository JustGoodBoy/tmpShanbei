//
//  NSArray+SHAN.m
//  AFNetworking
//
//  Created by GoodBoy on 2021/10/28.
//

#import "NSArray+SHAN.h"

@implementation NSArray (SHAN)

- (id)shan_objectOrNilAtIndex:(NSUInteger)index {
    if (![self isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSArray *array = (NSArray *)self;
    if (index >= array.count) return nil;
    
    id obj = [array objectAtIndex:index];
    if ([obj isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return obj;
}

@end
