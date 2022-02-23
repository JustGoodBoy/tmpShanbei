//
//  SHANProfitTableView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/22.
//

#import "SHANProfitTableView.h"
#import "SHANProfitTableViewCell.h"
#import "SHANProfitEmptyView.h"
#import "SHANHeader.h"
#import "UIView+SHANGetController.h"
#import "NSArray+SHAN.h"
static NSString *const SHANProfitCellID = @"SHANProfitCellID";

@interface SHANProfitTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SHANProfitEmptyView *emptyView;
@end

@implementation SHANProfitTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setupInfo];
    }
    return self;
}

- (void)setupInfo {
    self.dataSource = self;
    self.delegate = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
    [self registerClass:[SHANProfitTableViewCell class] forCellReuseIdentifier:SHANProfitCellID];
}

#pragma mark - lazyLoad
- (SHANProfitEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[SHANProfitEmptyView alloc] initWithFrame:CGRectMake(0, 71*kSHANScreenW_Radius, kSHANScreenWidth, 240)];
        _emptyView.backgroundColor = [UIColor whiteColor];
        __weak typeof(self) weakself = self;
        _emptyView.clickGoTaskCenter = ^{
            [weakself.viewController.navigationController popViewControllerAnimated:YES];
        };
        [self addSubview:_emptyView];
    }
    return _emptyView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHANProfitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SHANProfitCellID forIndexPath:indexPath];
    SHANProfitRecordModel *model = [self.dataArray shan_objectOrNilAtIndex:indexPath.row];
    cell.profitRecordModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 73;
}

#pragma mark - Setter
- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self reloadData];
    if (_dataArray.count == 0) {
        self.emptyView.hidden = NO;
    } else {
        self.emptyView.hidden = YES;
    }
}

@end
