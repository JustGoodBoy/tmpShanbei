//
//  SHANWXUserInfoModel.h
//  Pods
//
//  Created by GoodBoy on 2021/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHANWXUserInfoModel : NSObject

@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *headimgurl;   // 微信返回的
@property (nonatomic, copy) NSString *headImgUrl;   // 后台定义的headImgUrl（驼峰式）
@property (nonatomic, copy) NSString *unionid;

@end

NS_ASSUME_NONNULL_END
