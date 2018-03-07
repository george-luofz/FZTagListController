//
//  FZTagListView.m
//  FZTagListController
//
//  Created by 罗富中 on 2018/3/2.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "FZTagListView.h"
#import "FZTagListViewCollectionViewCell.h"
#import "FZTagListController.h"

static CGFloat KDefaultTagHorizontalMargin = 10;
static CGFloat KDefaultUnderlineHeight = 2;
static CGFloat KDefaultUnderLineAnimationDuration = 0.25f;

@interface FZTagListView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSArray *_strings;
    
    UICollectionView    *_collectionView;
    UIView              *_underLine;
    
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
    
    // 2.更新underline frame
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
    // TODO:selectIndex
    // 1.underLine
    [self _clickUnderLineFromIndex:fromIndex toIndex:toIndex animated:animated];
    // 2.item
    [self _clickCellItemFromIndex:fromIndex toIndex:toIndex animated:animated];
}

- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress animated:(BOOL)animated{
    if(fromIndex == toIndex) return;
    // 1.underLine
    [self _transitionUnderLineFromIndex:fromIndex toIndex:toIndex progress:progress animated:animated];
    // 2.item
    [self _transitionCellItemFromIndex:fromIndex toIndex:toIndex progress:progress animated:animated];
}

//- (void)layoutSubviews{
//    [super layoutSubviews];
//    // 4.cell item color
//    FZTagListViewCollectionViewCell *currentSelectCell = (FZTagListViewCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_listController.currentSelectIndex inSection:0]];
//    currentSelectCell.titleLabel.textColor = _selectedColor;
//}
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
    CGRect cellFrame = [self _cellFrameAtIndex:_listController.currentSelectIndex];
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
    CGFloat currentOriginX = fromIndexCellFrame.origin.x + (toIndexCellFrame.origin.x - fromIndexCellFrame.origin.x) * progress;
    CGFloat currentWidth = fromIndexCellFrame.size.width + (toIndexCellFrame.size.width - fromIndexCellFrame.size.width) * progress;
    CGRect currentUnderLineFrame = CGRectMake(currentOriginX, _underLine.frame.origin.y, currentWidth, _underLine.frame.size.height);
    _underLine.frame = currentUnderLineFrame;
}

- (void)_transitionCellItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress animated:(BOOL)animated{
    // 1.scoll cellItem
    [self _scrollCellItemToIndex:toIndex];
    // 2.color transition
    [self _transitionCellItemColorFromIndex:fromIndex toIndex:toIndex progress:progress];
    // 3.scale transition
    [self _transitionCellItemScaleFromIndex:fromIndex toIndex:toIndex progress:progress];
}
- (void)_scrollCellItemToIndex:(NSInteger)toIndex{
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:toIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)_transitionCellItemColorFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress{
    if(_selectedColor == nil) return;
    
    FZTagListViewCollectionViewCell *currentSelectCell = (FZTagListViewCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:fromIndex inSection:0]];
    FZTagListViewCollectionViewCell *currentNormalCell = (FZTagListViewCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:toIndex inSection:0]];
    
    CGFloat fromR,fromG,fromB,fromA;
    CGFloat toR,toG,toB,toA;
    [_selectedColor getRed:&fromR green:&fromG blue:&fromB alpha:&fromA];
    [_normalColor getRed:&toR green:&toG blue:&toB alpha:&toA];
    
    CGFloat currentNormalR,currentNomalG,currentNomalB,currentNomalA;
    currentNormalR = fromR + (toR - fromR) * progress;
    currentNomalG = fromG + (toG - fromG) * progress;
    currentNomalB = fromB + (toB - fromB) * progress;
    currentNomalA = fromA + (toA - fromA) * progress;
    
    CGFloat currentSelectR,currentSelectG,currentSelectB,currentSelectA;
    currentSelectR = toR - (toR - fromR) * progress;
    currentSelectG = toG - (toG - fromG) * progress;
    currentSelectB = toB - (toB - fromB) * progress;
    currentSelectA = toA - (toA - fromA) * progress;
    
    UIColor *currentNormalColor = [UIColor colorWithRed:currentNormalR green:currentNomalG blue:currentNomalB alpha:currentNomalA];
    UIColor *currentSelectColor = [UIColor colorWithRed:currentSelectR green:currentSelectG blue:currentSelectB alpha:currentSelectA];
    
    currentNormalCell.titleLabel.textColor = currentSelectColor;
    currentSelectCell.titleLabel.textColor = currentNormalColor;
}

- (void)_transitionCellItemScaleFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress{
    if(_listController.selectedScale == 0) return;
    
    CGFloat scale = _listController.selectedScale;
    CGFloat currentSelectScale = scale - (scale - 1) * progress;
    CGFloat currentNormalScale = 1 + (scale - 1) * progress;
    
    [self _scaleCellItem:fromIndex scale:currentSelectScale];
    [self _scaleCellItem:toIndex scale:currentNormalScale];
}

- (void)_scaleCellItem:(NSInteger)index scale:(CGFloat)scale{
    FZTagListViewCollectionViewCell *currentSelectCell = (FZTagListViewCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    if(currentSelectCell == nil) return;
    currentSelectCell.transform = CGAffineTransformMakeScale(scale, scale);
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
    // 1.scroll item
    [self _scrollCellItemToIndex:toIndex];
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

    [_collectionView addSubview:underLine];
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
    
    if(indexPath.row == _listController.currentSelectIndex){
        cell.titleLabel.textColor = _selectedColor;
        [self _scaleCellItem:indexPath.item scale:_listController.selectedScale];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // 1.选择某个item
    [self clickFromIndex:_listController.currentSelectIndex toIndex:indexPath.item animated:YES];
    // 2.回调代理
    if(self.delegate && [self.delegate respondsToSelector:@selector(FZTagListView:clickAtIndex:)]){
        [self.delegate FZTagListView:self clickAtIndex:indexPath.item];
    }
}

#pragma mark -- 数值处理

- (CGRect)_cellFrameAtIndex:(NSInteger)index{
    UICollectionViewLayoutAttributes *att = [_collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return att.frame;
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


