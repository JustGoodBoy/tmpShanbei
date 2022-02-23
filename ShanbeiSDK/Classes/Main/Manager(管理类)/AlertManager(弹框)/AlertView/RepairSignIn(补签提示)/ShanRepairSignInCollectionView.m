//
//  ShanRepairSignInCollectionView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/1/21.
//

#import "ShanRepairSignInCollectionView.h"
#import "ShanRepairSignInCollectionViewCell.h"
#import "ShanRepairSignInCollectionViewBigCell.h"
#import "ShanSignedModel.h"
#import "NSArray+SHAN.h"
static NSString * const ShanRepairSignInCollectionViewCellID = @"ShanRepairSignInCollectionViewCellID";
static NSString * const ShanRepairSignInCollectionViewBigCellID = @"ShanRepairSignInCollectionViewBigCellID";

@interface ShanRepairSignInCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation ShanRepairSignInCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
    layout.minimumInteritemSpacing = 12;
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.showsHorizontalScrollIndicator = NO;   //是否显示滚动条
    self.scrollEnabled = NO;
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[ShanRepairSignInCollectionViewCell class] forCellWithReuseIdentifier:ShanRepairSignInCollectionViewCellID];
    [self registerClass:[ShanRepairSignInCollectionViewBigCell class] forCellWithReuseIdentifier:ShanRepairSignInCollectionViewBigCellID];
}

- (void)setDataList:(NSMutableArray *)dataList {
    _dataList = dataList;
    [self reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == _dataList.count - 1) {
        return [ShanRepairSignInCollectionViewBigCell shan_cellSize];
    }
    return [ShanRepairSignInCollectionViewCell shan_cellSize];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == _dataList.count - 1) {
        ShanRepairSignInCollectionViewBigCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShanRepairSignInCollectionViewBigCellID forIndexPath:indexPath];
        ShanSignInTaskBosModel *model = [_dataList shan_objectOrNilAtIndex:indexPath.item];
        cell.model = model;
        return cell;
    }
    ShanRepairSignInCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShanRepairSignInCollectionViewCellID forIndexPath:indexPath];
    ShanSignInTaskBosModel *model = [_dataList shan_objectOrNilAtIndex:indexPath.item];
    cell.model = model;
    return cell;
}


@end
