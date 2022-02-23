//
//  SHANCashTaskAlertView.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 现金奖励
@interface SHANCashTaskAlertView : UIView

@property (nonatomic, copy) void (^didSureAction)(void);
@property (nonatomic, copy) void (^didCloseAction)(void);
@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *sureBtnTxt;

- (void)shan_showAlert:(NSString *)awardCash;

@end

NS_ASSUME_NONNULL_END
