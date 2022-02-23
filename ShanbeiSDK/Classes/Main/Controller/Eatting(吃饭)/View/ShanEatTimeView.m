//
//  ShanEatTimeView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/1/22.
//

#import "ShanEatTimeView.h"
#import "SHANCommonUIHeader.h"
#import "ShanEatTimeTableViewCell.h"
#import "ShanEatModel.h"
#import "NSArray+SHAN.h"
#import "UIView+SHAN.h"
static NSString * const ShanEatTimeTableViewCellID = @"ShanEatTimeTableViewCellID";
static NSInteger const bodyHeadHeight = 77;
static NSInteger const bodyHeight = 339;
@interface ShanEatTimeView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation ShanEatTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.backgroundColor = [UIColor shan_colorWithHexString:@"000000" alphaComponent:0.8 ];
    [self addSubview:bgView];
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction)];
    [bgView addGestureRecognizer:tapG];
    
    _bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, kSHANScreenHeight, kSHANScreenWidth, bodyHeight)];
    _bodyView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:_bodyView];
    UITapGestureRecognizer *tapG2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [_bodyView addGestureRecognizer:tapG2];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bodyView.width, bodyHeadHeight)];
    headView.backgroundColor = [UIColor whiteColor];
    [_bodyView addSubview:headView];
    CGFloat radius = 20; // 圆角大小
    UIRectCorner corner = UIRectCornerTopLeft | UIRectCornerTopRight;
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:headView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = headView.bounds;
    maskLayer.path = path.CGPath;
    headView.layer.mask = maskLayer;
    
    UIImage *closeBtnImg = [UIImage SHANImageNamed:@"shan_icon_eat_time_close_btn" className:self.class];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.adjustsImageWhenHighlighted = NO;
    [closeBtn setImage:closeBtnImg forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"今日开饭时间";
    titleLabel.textColor = [UIColor shan_colorWithHexString:@"#353B4E"];
    titleLabel.font = [UIFont shan_PingFangMediumFont:18];
    [headView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.centerY.mas_equalTo(closeBtn);
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_bodyView addSubview:_tableView];
    [_tableView registerClass:[ShanEatTimeTableViewCell class] forCellReuseIdentifier:ShanEatTimeTableViewCellID];
}

- (void)shan_showAlert:(NSArray *)list {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    _dataList = [list mutableCopy];
    CGFloat tableViewHeight = _dataList.count * [ShanEatTimeTableViewCell shan_cellSize].height;
    tableViewHeight = tableViewHeight == 0 ? 252 : tableViewHeight;
    _tableView.frame = CGRectMake(0, bodyHeadHeight, kSHANScreenWidth, tableViewHeight);
    [_tableView reloadData];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bodyView.top = kSHANScreenHeight - bodyHeight;
    }];
}

- (void)closeAction {
    [UIView animateWithDuration:0.3 animations:^{
        self.bodyView.top = kSHANScreenHeight;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication].delegate.window removeFromSuperview];
        [self removeFromSuperview];
        [[UIApplication sharedApplication].delegate.window resignKeyWindow];
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShanEatTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShanEatTimeTableViewCellID forIndexPath:indexPath];
    ShanMealSubsideBosModel *model = [_dataList shan_objectOrNilAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ShanEatTimeTableViewCell shan_cellSize].height;
}
@end
