//
//  NSDictionary+SHAN.h
//  Pods
//
//  Created by GoodBoy on 2021/9/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary<__covariant KeyType, __covariant ObjectType> (SHAN)

- (nullable ObjectType)shanObjectOrNilForKey:(KeyType)aKey;

- (NSString *)shanStringForKey:(NSString *)key;

@end

@interface NSMutableDictionary (SHAN)

- (void)shanSetObjectSafely:(id)anObject aKey:(id <NSCopying>)aKey;

@end

NS_ASSUME_NONNULL_END
