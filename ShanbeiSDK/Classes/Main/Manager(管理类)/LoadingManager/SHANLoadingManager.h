//
//  SHANLoadingManager.h
//  Pods
//
//  Created by GoodBoy on 2021/9/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHANLoadingManager : NSObject
@property (nonatomic, copy) NSString *titleString;

+ (instancetype)sharedManager;

- (void)startAnimating;

- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
