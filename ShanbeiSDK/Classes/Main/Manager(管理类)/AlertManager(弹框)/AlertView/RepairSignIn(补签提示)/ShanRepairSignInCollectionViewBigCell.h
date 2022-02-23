//
//  ShanRepairSignInCollectionViewBigCell.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ShanSignInTaskBosModel;

@interface ShanRepairSignInCollectionViewBigCell : UICollectionViewCell

@property (nonatomic, strong) ShanSignInTaskBosModel *model;

+ (CGSize)shan_cellSize;

@end

NS_ASSUME_NONNULL_END
