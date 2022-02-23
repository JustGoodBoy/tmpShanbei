//
//  ShanEatTimeGuideView.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/2/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 吃饭新手引导
@interface ShanEatTimeGuideView : UIView
/// 显示新手引导
- (void)shan_showAlert;

/// 是否需要显示新手引导
+ (BOOL)shan_isNeedShowGuide;

@end

NS_ASSUME_NONNULL_END
