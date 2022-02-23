//
//  SHANShareInviteView.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHANShareInviteView : UIView

@property (nonatomic, copy) void (^sharePlatformBlock)(NSInteger index);

- (instancetype)initWithShareInviteView;

//展示
- (void)showAlert;

//隐藏
- (void)dismissAlert;

@end

NS_ASSUME_NONNULL_END
