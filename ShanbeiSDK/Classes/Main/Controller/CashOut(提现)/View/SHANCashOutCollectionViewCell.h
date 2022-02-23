//
//  SHANCashOutCollectionViewCell.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/23.
//

#import <UIKit/UIKit.h>
@class SHANCashDrawalModel;
NS_ASSUME_NONNULL_BEGIN

@interface SHANCashOutCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) SHANCashDrawalModel *model;
@property (nonatomic, assign) BOOL isSelect;
@end

NS_ASSUME_NONNULL_END
