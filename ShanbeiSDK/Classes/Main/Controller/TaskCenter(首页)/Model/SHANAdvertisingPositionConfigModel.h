//
//  SHANAdvertisingPositionConfigModel.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHANAdvertisingPositionConfigModel : NSObject

@property (nonatomic, copy) NSString *advertisingPositionId;    // id
@property (nonatomic, copy) NSString *advertisingType;          // 类型
@property (nonatomic, copy) NSString *advertisingPlatform;      // 平台

@end

NS_ASSUME_NONNULL_END
