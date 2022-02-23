//
//  ShanRepairSignInView.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ShanSignedModel;
/// 补签
@interface ShanRepairSignInView : UIView
@property (nonatomic, copy) dispatch_block_t clickRepairBlock;

- (void)shan_showAlert:(ShanSignedModel *)model;

@end

NS_ASSUME_NONNULL_END
