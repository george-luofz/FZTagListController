//
//  FZTagListView.m
//  FZTagListController
//
//  Created by 罗富中 on 2018/3/2.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "FZTagListView.h"
#import "FZTagListViewCollectionViewCell.h"

static CGFloat KDefaultTagHorizontalMargin = 10;
static CGFloat KDefaultUnderlineHeight = 2;
static CGFloat KDefaultUnderLineAnimationDuration = 0.25f;

@interface FZTagListView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSArray *_strings;
    
    UICollectionView    *_collectionView;
    UIView              *_underLine;
    
    NSInteger           _currentSelectIndex;  //当前选择的索引
}
@end
@implementation FZTagListView

- (instancetype)init{
    if(self = [super init]){
        [self _addSubView];
    }
    return self;
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    // 布局
    _collectionView.frame = self.bounds;
}
- (void)setUpStringArray:(NSArray<NSString *> *)strings{
    _strings = strings;
    
    // 1.reload
    [_collectionView reloadData];
    
    // 2.更新select
    _currentSelectIndex = 3;
    // 3.更新underline frame
    [self _setupUnderlineFrame];
}

- (void)setupRenderPreference{
    // 1.自定义视图
    if(_leftEdgeCustomView){
        [self addSubview:_leftEdgeCustomView];
        _leftEdgeCustomView.layer.zPosition = 10;
    }
    if(_rightEdgeCustomView){
        [self addSubview:_rightEdgeCustomView];
        _rightEdgeCustomView.layer.zPosition = 10;
    }
    
    // 2.颜色设置
    _underLine.backgroundColor = _underLineBgColor;
    
    // 3.frame调整
    [self _setupSubViewFrame];
    
    // 4.underline zPosition 为了防止遮挡左右视图
    _underLine.layer.zPosition = 5;
    
}

- (void)clickFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated{
    if(fromIndex == toIndex) return;
    if(toIndex == _currentSelectIndex) return;
    _currentSelectIndex = toIndex;
    // 1.underLine
    [self _clickUnderLineFromIndex:fromIndex toIndex:toIndex animated:animated];
    // 2.item
    [self _clickCellItemFromIndex:fromIndex toIndex:toIndex animated:animated];
}

- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress animated:(BOOL)animated{
    if(fromIndex == toIndex) return;
    if(toIndex == _currentSelectIndex) return;
    _currentSelectIndex = toIndex;
    // 1.underLine
    [self _transitionUnderLineFromIndex:fromIndex toIndex:toIndex progress:progress animated:animated];
    // 2.item
    [self _transitionCellItemFromIndex:fromIndex toIndex:toIndex animated:animated];
}

#pragma mark - private method
#pragma mark -- setup frames
- (void)_setupSubViewFrame{
    CGRect collectionViewFrame = _collectionView.frame;
    // 修改左侧custom frame
    if(_leftEdgeCustomView){
        CGRect leftCustomOriginframe = _leftEdgeCustomView.frame;
        _leftEdgeCustomView.frame = CGRectMake(0, _leftEdgeCustomView.frame.origin.y, leftCustomOriginframe.size.width, leftCustomOriginframe.size.height);
    }
    // 修改右侧custom frame
    if(_rightEdgeCustomView){
        CGRect rightCustomOriginframe = _rightEdgeCustomView.frame;
        _rightEdgeCustomView.frame = CGRectMake(self.frame.size.width - rightCustomOriginframe.size.width, rightCustomOriginframe.origin.y, rightCustomOriginframe.size.width, rightCustomOriginframe.size.height);
    }
    // 修改collectionView frame
    CGFloat collectViewOriginX = _leftEdgeCustomView ? CGRectGetMaxX(_leftEdgeCustomView.frame) : collectionViewFrame.origin.x;
    CGFloat collectViewWidth = _rightEdgeCustomView ? CGRectGetMinX(_rightEdgeCustomView.frame) - collectViewOriginX : self.frame.size.width - collectViewOriginX;
    _collectionView.frame = CGRectMake(collectViewOriginX, collectionViewFrame.origin.y, collectViewWidth, collectionViewFrame.size.height);
}

- (void)_setupUnderlineFrame{
    // x是啥，当前cell的origin
    CGRect cellFrame = [self _cellFrameAtIndex:_currentSelectIndex];
    CGFloat underLineOriginX = cellFrame.origin.x;
    
    if (_useConstantUnderLineLength && _underlineLength){
        _underLine.frame = CGRectMake(underLineOriginX, self.frame.size.height - KDefaultUnderlineHeight, _underlineLength, KDefaultUnderlineHeight);
    }else{ //使用计算长度，只需要计算选择之后长度
        _underLine.frame = CGRectMake(underLineOriginX, self.frame.size.height - KDefaultUnderlineHeight, cellFrame.size.width, KDefaultUnderlineHeight);
    }
}
#pragma mark - scroll to index
- (void)_transitionUnderLineFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress animated:(BOOL)animated{
    CGRect fromIndexCellFrame = [self _cellFrameAtIndex:fromIndex];
    CGRect toIndexCellFrame = [self _cellFrameAtIndex:toIndex];
    CGFloat currentOriginX = toIndexCellFrame.origin.x - (toIndexCellFrame.origin.x - fromIndexCellFrame.origin.x) * progress;
    CGFloat currentWidth = toIndexCellFrame.size.width - (toIndexCellFrame.size.width - fromIndexCellFrame.size.width) * progress;
    CGRect currentUnderLineFrame = CGRectMake(currentOriginX, fromIndexCellFrame.origin.y, currentWidth, fromIndexCellFrame.size.height);
    _underLine.frame = currentUnderLineFrame;
}

- (void)_transitionCellItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated{
    
}

#pragma mark - click to index
- (void)_clickUnderLineFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated{
    CGRect toIndexCellFrame = [self _cellFrameAtIndex:toIndex];
    CGRect toIndexUnderLineFrame = CGRectMake(toIndexCellFrame.origin.x, _underLine.frame.origin.y, toIndexCellFrame.size.width, _underLine.frame.size.height);
    CGFloat animationDuration = _underLineAnimationDuration ? : KDefaultUnderLineAnimationDuration;
    [UIView animateWithDuration:animationDuration animations:^{
        _underLine.frame = toIndexUnderLineFrame;
    }];
}

- (void)_clickCellItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated{
    
}
#pragma mark - subView

- (void)_addSubView{
    // 1.UICollectionView
    [self _addCollectionView];
    // 2.underLine
    [self _addUnderLine];
}

- (void)_addCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectInfinite collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];  //手动设置背景色
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    
    [collectionView registerClass:[FZTagListViewCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView = collectionView;
    [self addSubview:collectionView];
}

- (void)_addUnderLine{
    UIView *underLine = [[UIView alloc] init];
    _underLine = underLine;

    [self addSubview:underLine];
}

#pragma mark - collection delegate and datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _strings.count?:0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    CGFloat width = [self _stringWidthAtIndex:indexPath.row font:_normalFont constraintedToSize:CGSizeMake(300, 100)];
    return CGSizeMake(width, self.frame.size.height - 2 * _tagTopMagin); //减去topMagin
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return _tagHorizontalMargin ? : KDefaultTagHorizontalMargin;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FZTagListViewCollectionViewCell *cell = (FZTagListViewCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.backgroundColor = [UIColor orangeColor];
    cell.titleLabel.text = [_strings objectAtIndex:indexPath.row];
    cell.titleLabel.textColor = _normalColor;
    cell.titleLabel.font = _normalFont;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // 1.选择某个item
    [self clickFromIndex:_currentSelectIndex toIndex:indexPath.item animated:YES];
    // 2.回调代理
//    if(self.delegate && self.delegate respondsToSelector:@selector(<#selector#>))
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 1. 滚动时拖动下划线跟随滚动
    [self _setupUnderlineFrame];
}

#pragma mark -- 数值处理

- (CGRect)_cellFrameAtIndex:(NSInteger)index{ //这个可以计算cell frame
    UICollectionViewLayoutAttributes *att = [_collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return  [self convertRect:att.frame fromView:_collectionView];
}

- (CGFloat)_underLineWidthAtIndex:(NSInteger)index{
    return [self _cellFrameAtIndex:index].size.width;
}

- (CGFloat)_stringWidthAtIndex:(NSInteger)index font:(UIFont *)font constraintedToSize:(CGSize)size{
    NSString *string = [_strings objectAtIndex:index];
    CGSize textSize = CGSizeZero;
    
    CGRect frame = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName:font } context:nil];
    textSize = CGSizeMake(frame.size.width, frame.size.height + 1);
    return frame.size.width;
}

@end


