//
//  ShanEatTimeTableViewCell.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/1/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ShanMealSubsideBosModel;

@interface ShanEatTimeTableViewCell : UITableViewCell

@property (nonatomic, strong) ShanMealSubsideBosModel *model;

+ (CGSize)shan_cellSize;

@end

NS_ASSUME_NONNULL_END
