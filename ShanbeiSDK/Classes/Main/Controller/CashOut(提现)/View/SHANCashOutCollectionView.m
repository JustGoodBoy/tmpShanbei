//
//  SHANCashOutCollectionView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/23.
//

#import "SHANCashOutCollectionView.h"
#import "SHANHeader.h"
#import "SHANCashOutCollectionViewCell.h"
#import "SHANCashDrawalModel.h"
#import "NSArray+SHAN.h"
@interface SHANCashOutCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation SHANCashOutCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.showsVerticalScrollIndicator = NO;   //是否显示滚动条
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[SHANCashOutCollectionViewCell class] forCellWithReuseIdentifier:@"SHANCashOutCollectionViewCell"];
    self.selectIndex = 0;
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self reloadData];
}

#pragma mark -collectionview 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SHANCashOutCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SHANCashOutCollectionViewCell" forIndexPath:indexPath];
    cell.model = [_dataArray shan_objectOrNilAtIndex:indexPath.row];
    cell.isSelect = self.selectIndex == indexPath.row;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectIndex = indexPath.row;
    [self reloadData];
    !self.clickItemBlock ? : self.clickItemBlock(self.selectIndex);
}
@end
