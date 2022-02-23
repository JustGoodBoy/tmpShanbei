//
//  ShanClickReportModel.m
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2022/2/9.
//

#import "ShanClickReportModel.h"
#import "SHANCommonHTTPHeader.h"
#import "NSDictionary+SHAN.h"

static NSString *const kShanClickReportPath = @"pub/click/data/report";

@implementation ShanClickReportModel

@end

@implementation ShanClickReportModel (HTTP)
+ (void)shanClickReport:(ShanClickType)type {
    if (type == ShanClickTypeOfDefault) return;
    
    NSString *clickType = @"";
    switch (type) {
        case ShanClickTypeOfUserSign:
            clickType = @"user_sign_task";
            break;
        case ShanClickTypeOfSeeAd:
            clickType = @"see_ad_video_task";
            break;
        case ShanClickTypeOfMealSubsidy:
            clickType = @"meal_subsidy_task";
            break;
        case ShanClickTypeOfInviteUsers:
            clickType = @"invite_users_task";
            break;
        case ShanClickTypeOfFillInviteCode:
            clickType = @"fill_invite_code_task";
            break;
        case ShanClickTypeOfToWithdraw:
            clickType = @"to_withdraw_task";
            break;
        case ShanClickTypeOfTreasureChest:
            clickType = @"treasure_chest_task";
            break;
        case ShanClickTypeOfSleepSubsidy:
            clickType = @"sleep_subsidy_task";
            break;
        default:
            break;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params shanSetObjectSafely:clickType aKey:@"clickType"];
    [SHANNetWorkRequest getWithPath:kShanClickReportPath params:params success:^(NSDictionary * _Nonnull argDict) {
        NSLog(@"点击行为：%@", clickType);
    } failure:^(NSString * _Nonnull errorMessage) {
        NSLog(@"ShanClickReportModel Error:%@",errorMessage);
    }];
}
@end
