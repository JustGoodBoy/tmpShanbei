//
//  SHANCashOutCollectionView.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHANCashOutCollectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) void (^clickItemBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
