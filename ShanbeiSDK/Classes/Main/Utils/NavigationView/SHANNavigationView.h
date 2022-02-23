//
//  SHANNavigationView.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHANNavigationView : UIView

@property (nonatomic, assign) BOOL isWhiteBackground;
@property (nonatomic, copy) dispatch_block_t backClickBlock;
@property (nonatomic, copy) dispatch_block_t explainClickBlock;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

- (void)showRight;

@end

NS_ASSUME_NONNULL_END
