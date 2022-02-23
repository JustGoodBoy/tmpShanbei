//
//  SHANProfitListView.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHANProfitListView : UIView
@property (nonatomic, strong) NSMutableArray *coinArray;
@property (nonatomic, strong) NSMutableArray *cashArray;

@property (nonatomic, copy) void (^clickProfitRecordBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
