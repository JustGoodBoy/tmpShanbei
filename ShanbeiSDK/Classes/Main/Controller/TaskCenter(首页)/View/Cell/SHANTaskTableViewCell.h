//
//  SHANTaskTableViewCell.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/16.
//

#import <UIKit/UIKit.h>
@class SHANTaskModel;

NS_ASSUME_NONNULL_BEGIN

@interface SHANTaskTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^clickTaskBlock)(SHANTaskModel *,NSString *);

@property (nonatomic, strong) SHANTaskModel *taskModel;

@property (nonatomic, assign) BOOL isHiddenLine;

/// 按钮的文字和图片
- (void)setBtnStyle:(NSString *)title isRewardVideoTask:(BOOL)isRewardVideoTask;

@end

NS_ASSUME_NONNULL_END
