//
//  NSDictionary+SHAN.m
//  Pods
//
//  Created by GoodBoy on 2021/9/26.
//

#import "NSDictionary+SHAN.h"
#import "SHANHeader.h"
@implementation NSDictionary (SHAN)

- (id)shanObjectOrNilForKey:(NSString *)aKey {
    NSDictionary *dict = (NSDictionary *)self;
    if (!aKey) return nil;
    
    id value = dict[aKey];
    if (!value || value == [NSNull null]) return nil;
    
    return value;
}

- (NSString *)shanStringForKey:(NSString *)key {
    NSString *str = [self shanObjectOrNilForKey:key];
    if (kSHANStringIsEmpty(str)) str = @"";
    return str;
}

@end

@implementation NSMutableDictionary (SHAN)

- (void)shanSetObjectSafely:(id)anObject aKey:(id <NSCopying>)aKey {
    if (anObject && aKey) {
        [self setObject:anObject forKey:aKey];
    }
}

@end
