//
//  CircleView.m
//  gydmall
//
//  Created by mac on 15/11/14.
//  Copyright © 2015年 fec. All rights reserved.
//

#import "CircleView.h"

@interface CircleView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (nonatomic, strong) NSMutableArray *circleInfoArrM;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation CircleView

static NSString *identity = @"CircleCell";

+ (instancetype) circleView{
    return [[[NSBundle mainBundle] loadNibNamed:@"CircleView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib{

    _bgView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    _flowLayout.itemSize = CGSizeMake(width, height);
    _flowLayout.minimumInteritemSpacing = 0.01f;
    _flowLayout.minimumLineSpacing = 0.01f;
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);

    UINib *nib = [UINib nibWithNibName:@"CircleCell" bundle:nil];
    [_mainCollectionView registerNib:nib forCellWithReuseIdentifier:identity];
    
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _circleInfoArrM.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CircleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identity forIndexPath:indexPath];
    //这里消失和显示cell，所以需要取出当前显示的cell的item值，item的值有(0,1,2)，item-1=1表示资源编号+1,item-1=-1表示资源编号-1，再加上currentIndex表示要显示资源的编号
    NSInteger index = (indexPath.item - 1 + self.currentIndex + self.circleInfoArrM.count)%self.circleInfoArrM.count;
    CircleInfo *circleInfo = _circleInfoArrM[index];
    cell.circleInfo = circleInfo;
    _titleLb.text = circleInfo.title;
    _pageControl.currentPage = index%_circleInfoArr.count;

    return cell;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(circleView:didSelectItemAtIndexPath:)]) {
        [self.delegate circleView:self didSelectItemAtIndexPath:indexPath];
    }
}

- (void)setCircleInfoArr:(NSArray *)circleInfoArr{
    _circleInfoArr = circleInfoArr;
    _pageControl.numberOfPages = circleInfoArr.count==1?0:circleInfoArr.count;
    _circleInfoArrM = [NSMutableArray arrayWithArray:circleInfoArr];
    if (_circleInfoArr.count == 2) {
        [_circleInfoArrM addObject:_circleInfoArrM[0]];
        [_circleInfoArrM addObject:_circleInfoArrM[1]];
    }
    
    //重用cell，总共有两个cell，假设有三页(0,1,2)，默认显示中间页1
    self.currentIndex = 1;
    
    if (self.circleInfoArrM.count>1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        [self.mainCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    
    [_mainCollectionView reloadData];
    
    if (_circleInfoArrM.count>1) {//只有大于1也才进行切换
        [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(scrollCircleCellDidByTimer:) userInfo:nil repeats:YES];
    }
}

//拖拽结束,在这个方法中需要每次滚动完后，在滚回中间页，这样才能达到只有两个单元格在反复重用，并取出图片资源编号
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    NSIndexPath *fromIndexPath=[[self.mainCollectionView indexPathsForVisibleItems]lastObject];

    //获取到要显示资源的编号后，我们重新滚动到中间页1
    NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];

    [self visibleCircleCellFromIndexPath:fromIndexPath ToIndexPath:toIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animate:NO];
}

- (void) scrollCircleCellDidByTimer:(NSTimer *) timer{
    
    //获取当前正在展示的位置
    NSIndexPath *fromIndexPath=[[self.mainCollectionView indexPathsForVisibleItems]lastObject];
    
    //马上显示回最中间那组的数据
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    
    [self.mainCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    //2计算出下一个需要展示的位置
    NSIndexPath *toIndexPath=[NSIndexPath indexPathForItem:2 inSection:0];
    
    [self visibleCircleCellFromIndexPath:fromIndexPath ToIndexPath:toIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animate:YES];
    
}

- (void) visibleCircleCellFromIndexPath:(NSIndexPath *) fromIndexPath ToIndexPath:(NSIndexPath *) toIndexPath atScrollPosition:(UICollectionViewScrollPosition) scrollPosition animate:(BOOL) animate{
    
    //通过动画滚动到下一个位置
    [self.mainCollectionView scrollToItemAtIndexPath:toIndexPath atScrollPosition:scrollPosition animated:animate];
    
    
    //计算下个位置的索引
    self.currentIndex = (fromIndexPath.item - 1 + self.currentIndex + self.circleInfoArrM.count)%self.circleInfoArrM.count;
    
    //为了避免滚动过快导致图片混乱，在滚动结束，就立即更新cell
    [UIView setAnimationsEnabled:NO];
    [self.mainCollectionView reloadItemsAtIndexPaths:@[toIndexPath]];
    [UIView setAnimationsEnabled:YES];
}

@end
