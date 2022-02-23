//
//  SHANProfitListView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/22.
//

#import "SHANProfitListView.h"
#import "UIColor+SHANHexString.h"
#import "UIFont+SHAN.h"
#import "UIView+SHAN.h"
#import "SHANHeader.h"
#import "SHANProfitTableView.h"

@interface SHANProfitListView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *coinBtn;
@property (nonatomic, strong) UIButton *cashBtn;
@property (nonatomic, assign) NSInteger indicatorIndex;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SHANProfitTableView *coinTableView;
@property (nonatomic, strong) SHANProfitTableView *cashTableView;

@end

@implementation SHANProfitListView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _coinBtn = [[UIButton alloc] init];
    _coinBtn.frame = CGRectMake(2*(self.width - 200)/7, 24, 100, 30);
    _coinBtn.titleLabel.font = [UIFont shan_PingFangMediumFont:16];
    [_coinBtn setTitle:@"积分收益" forState:UIControlStateNormal];
    [_coinBtn setTitleColor:[UIColor shan_colorWithHexString:@"#FD5558"] forState:UIControlStateNormal];
    [_coinBtn addTarget:self action:@selector(coinBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_coinBtn];
    
    _cashBtn = [[UIButton alloc] init];
    _cashBtn.frame = CGRectMake(5*(self.width - 200)/7 + 100, 24, 80, 30);
    _cashBtn.titleLabel.font = [UIFont shan_PingFangLightFont:16];
    [_cashBtn setTitle:@"现金收益" forState:UIControlStateNormal];
    [_cashBtn setTitleColor:[UIColor shan_colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [_cashBtn addTarget:self action:@selector(cashBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cashBtn];
    
    _indicatorIndex = 0;
    _indicatorView = [[UIView alloc] init];
    _indicatorView.frame = CGRectMake(CGRectGetMidX(_coinBtn.frame) - 7, CGRectGetMaxY(_coinBtn.frame), 14, 3);
    _indicatorView.layer.cornerRadius = 2;
    _indicatorView.layer.masksToBounds = YES;
    _indicatorView.backgroundColor = [UIColor shan_colorWithHexString:@"#FD5558"];
    [self addSubview:_indicatorView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(16, 70, self.width - 32, 1)];
    line.backgroundColor = [UIColor shan_colorWithHexString:@"#F7F7F7"];
    [self addSubview:line];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, CGRectGetMaxY(line.frame), self.width, self.height - CGRectGetMaxY(line.frame));
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator   = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(2*_scrollView.width, _scrollView.height);
    
    _coinTableView = [[SHANProfitTableView alloc] init];
    _coinTableView.frame = CGRectMake(0, 0, _scrollView.width, _scrollView.height);
    _coinTableView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_coinTableView];
    
    _cashTableView = [[SHANProfitTableView alloc] init];
    _cashTableView.frame = CGRectMake(_scrollView.width, 0, _scrollView.width, _scrollView.height);
    _cashTableView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_cashTableView];
}

#pragma mark - setter
- (void)setCoinArray:(NSMutableArray *)coinArray {
    _coinArray = coinArray;
    _coinTableView.dataArray = coinArray;
}

- (void)setCashArray:(NSMutableArray *)cashArray {
    _cashArray = cashArray;
    _cashTableView.dataArray = _cashArray;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    if (x == 0) {
        [self coinBtnAction];
    } else if (x == scrollView.width) {
        [self cashBtnAction];
    }
}

#pragma mark - Action
- (void)coinBtnAction {
    _indicatorIndex = 0;
    _coinBtn.titleLabel.font = [UIFont shan_PingFangMediumFont:16];
    [_coinBtn setTitleColor:[UIColor shan_colorWithHexString:@"#FD5558"] forState:UIControlStateNormal];
    
    _cashBtn.titleLabel.font = [UIFont shan_PingFangLightFont:16];
    [_cashBtn setTitleColor:[UIColor shan_colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakself.indicatorView.frame = CGRectMake(CGRectGetMidX(weakself.coinBtn.frame) - 7, CGRectGetMaxY(weakself.coinBtn.frame), 14, 3);
    }];
    
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    !self.clickProfitRecordBlock ? : self.clickProfitRecordBlock(0);
}

- (void)cashBtnAction {
    _indicatorIndex = 1;
    _coinBtn.titleLabel.font = [UIFont shan_PingFangLightFont:16];
    [_coinBtn setTitleColor:[UIColor shan_colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    
    _cashBtn.titleLabel.font = [UIFont shan_PingFangMediumFont:16];
    [_cashBtn setTitleColor:[UIColor shan_colorWithHexString:@"#FD5558"] forState:UIControlStateNormal];
    
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakself.indicatorView.frame = CGRectMake(CGRectGetMidX(weakself.cashBtn.frame) - 7, CGRectGetMaxY(weakself.cashBtn.frame), 14, 3);
    }];
    
    [_scrollView setContentOffset:CGPointMake(kSHANScreenWidth, 0) animated:YES];
    
    !self.clickProfitRecordBlock ? : self.clickProfitRecordBlock(1);
}


@end
