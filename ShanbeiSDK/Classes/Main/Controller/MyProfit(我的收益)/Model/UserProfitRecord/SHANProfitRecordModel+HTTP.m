//
//  SHANProfitRecordModel+HTTP.m
//  Pods
//
//  Created by GoodBoy on 2021/9/18.
//

#import "SHANProfitRecordModel+HTTP.h"
#import "SHANNetWorkRequest.h"
#import "SHANURL.h"
#import "SHANHeader.h"
#import "YYModel.h"

@implementation SHANProfitRecordModel (HTTP)

/// 获取coin/cash记录
/// @param type coin/cash
+ (void)shanGetCoinRecordWithType:(SHANRecordType)type
                          success:(successCompletion)success
                          failure:(failureCompletion)failure {
    NSString *path = kSHAN_apiCoinRecord;
    if (type == SHANRecordTypeCash) {
        path = kSHAN_apiCashRecord;
    }
    [SHANNetWorkRequest getWithPath:path params:nil success:^(NSDictionary * _Nonnull argDict) {
        NSArray *dataArray = [argDict objectForKey:@"data"];
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        SHANProfitRecordModel *model = [[SHANProfitRecordModel alloc] init];
        if (!kSHANArrayIsEmpty(dataArray)) {
            for (NSDictionary *dict in dataArray) {
                model = [SHANProfitRecordModel yy_modelWithDictionary:dict];
                [tempArray addObject:model];
            }
        }
        success(tempArray);
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}

@end
