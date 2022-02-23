//
//  SHANInviteCollectionViewCell.h
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/10/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SHANInviteItem;

@interface SHANInviteCollectionViewCell : UICollectionViewCell

- (void)setInfoWithModel:(SHANInviteItem *)model isInvited:(BOOL)isInvited;

@end

NS_ASSUME_NONNULL_END
