//
//  SHANSleepView.h
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/11/24.
//

#import <UIKit/UIKit.h>
@class SHANSleepModel;
NS_ASSUME_NONNULL_BEGIN

@interface SHANSleepView : UIView

@property (nonatomic, copy) dispatch_block_t clickBackBlock;
@property (nonatomic, copy) dispatch_block_t clickShareBlock;
@property (nonatomic, copy) dispatch_block_t clickSleepBlock;
@property (nonatomic, copy) dispatch_block_t clickRewardBlock;
@property (nonatomic, strong) SHANSleepModel *sleepModel;

- (void)shan_reloadSleepBtn:(NSInteger)duration;
- (void)shan_renewSleepBtn;
@end

NS_ASSUME_NONNULL_END
