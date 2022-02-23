//
//  SHANSignInCollectionViewCell.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/10/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ShanSignInTaskBosModel;

@interface SHANSignInCollectionViewCell : UICollectionViewCell

- (void)setSignInModel:(ShanSignInTaskBosModel *)model todaySignId:(NSString *)todaySignId;

- (void)setCoinLabelText:(NSString *)text;

+ (CGSize)shan_cellSize;
@end

NS_ASSUME_NONNULL_END
