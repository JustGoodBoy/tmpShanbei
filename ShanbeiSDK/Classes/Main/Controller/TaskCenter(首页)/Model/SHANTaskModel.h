//
//  SHANTaskModel.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/16.
//

#import <Foundation/Foundation.h>
@class SHANUserTaskModel;
@class SHANAdvertisingPositionConfigModel;

NS_ASSUME_NONNULL_BEGIN

@interface SHANTaskModel : NSObject

@property (nonatomic, strong) SHANUserTaskModel *userTask;
@property (nonatomic, strong) NSArray<SHANAdvertisingPositionConfigModel *> *advertisingPositionConfig;

@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
