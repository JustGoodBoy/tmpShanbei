//
//  SHANTaskModel+HTTP.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/18.
//

#import "SHANTaskModel+HTTP.h"
#import "SHANNetWorkRequestSetterManager.h"
#import "SHANNetWorkRequest.h"
#import "SHANHeader.h"
#import "SHANURL.h"
#import "YYModel.h"
#import "NSString+SHAN.h"
#import "UIFont+SHAN.h"
#import "SHANUserTaskModel.h"
#import "SHANCommentManager.h"
#import "NSDictionary+SHAN.h"
@implementation SHANTaskModel (HTTP)

/// 获取任务列表
+ (void)shanGetTaskOfSuccess:(successCompletion)success
                     failure:(failureCompletion)failure {
    [SHANNetWorkRequest getWithPath:kSHAN_apiUserTask params:nil success:^(NSDictionary * _Nonnull argDict) {
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        NSArray *dataArray = [argDict objectForKey:@"data"];
        if (!kSHANArrayIsEmpty(dataArray)) {
            for (NSDictionary *dict in dataArray) {
                SHANTaskModel *model = [SHANTaskModel yy_modelWithDictionary:dict];
                CGFloat cellHeight = [self cellHeight:model];
                model.cellHeight = cellHeight;
                [mutableArray addObject:model];
            }
        }
        NSArray *array = [mutableArray copy];
        success(array);
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}
+ (CGFloat)cellHeight:(SHANTaskModel *)model {
    CGFloat titleHeight =  [model.userTask.title shan_getHeightwithContent:model.userTask.title withFont:[UIFont shan_PingFangSemiboldFont:14] withWidth:(kSHANScreenWidth - 80) - 43 - 78 - 19];
    CGFloat descHeight =  [model.userTask.subheading shan_getHeightwithContent:model.userTask.subheading withFont:[UIFont shan_PingFangRegularFont:11] withWidth:(kSHANScreenWidth - 80) - 43 - 78 - 19];
    
    CGFloat height = 20 + titleHeight + 5 + descHeight + 18;
    // 倒计时label
    if ([model.userTask.advertisingType integerValue] == 9) {
        height = height + 30;
    }
    height = ceilf(height * 100) / 100;
    return height;
}

@end
