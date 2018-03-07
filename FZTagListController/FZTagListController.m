//
//  FZTagListController.m
//  FZTagListController
//
//  Created by 罗富中 on 2018/3/2.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "FZTagListController.h"
#import "FZTagListView.h"
#import "FZTagListContainerView.h"

static CGFloat KDefaultTagListViewHeight = 44;

@interface FZTagListController()<FZTagListViewDelegate,FZTagListContainerViewDelegate>
{
    FZTagListView           *_listView;
    FZTagListContainerView  *_listContainerView;
    
    NSArray *_originalTitles;
    
    NSCache *_cache;
}
@end

@implementation FZTagListController

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self _addTagListView];
        [self _addContainerView];
    }
    return self;
}

- (void)setUpView{
    // 1.listView
    [self _setUpListView];
    
    // 2.update data
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(titles)]){
        _originalTitles =  [self.dataSource titles];
        [_listView setUpStringArray:_originalTitles];
    }

    // 3.containerView setup
    [self _setupContainerView];
    // 4.load view
    for(int i = 0 ; i < _originalTitles.count ; i++){
        CGRect frame = CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
        [_listContainerView addSubview:view];
    }
//    if(self.dataSource && [self.dataSource respondsToSelector:@selector(viewForTagListControllerAtIndex:)]){
//        UIView *currentLoadView = [self.dataSource viewForTagListControllerAtIndex:_currentSelectIndex];
//        [_listContainerView addSubView:currentLoadView atIndex:_currentSelectIndex];
//    }
    
}

- (void)_addTagListView{
    FZTagListView *listView = [[FZTagListView alloc] init];
    listView.delegate = self;
    listView.listController = self;
    [self addSubview:listView];
    _listView = listView;
}

- (void)_addContainerView{
    FZTagListContainerView *listContainerView = [[FZTagListContainerView alloc] init];
    listContainerView.scrollDelegate = self;
    [self addSubview:listContainerView];
    
    _listContainerView = listContainerView;
}
#pragma mark -- setup View
- (void)_setUpListView{
    // 1.height
    _listView.frame = CGRectMake(0, 0, self.frame.size.width, _tagListHeight?:KDefaultTagListViewHeight);
    // 2.setup view
    _listView.leftEdgeCustomView = _tagListLeftEdgeCustomView;
    _listView.rightEdgeCustomView = _tagListRightEdgeCustomView;
    
    _listView.normalColor = _normalColor;
    _listView.selectedColor = _selectedColor;
    _listView.normalFont = _normalFont;
    _listView.selectedFont = _selectedFont;
    _listView.underLineBgColor = _underLineBgColor;
    
    _listView.tagTopMagin = _tagTopMagin;
    _listView.tagHorizontalMargin = _tagHorizontalMargin;
    _listView.tagListHeight = _tagListHeight;
    _listView.underlineLength = 0;
    
    [_listView setupRenderPreference];
}

- (void)_setupContainerView{
    // 1. frame
    _listContainerView.frame = CGRectMake(0, CGRectGetMaxY(_listView.frame), self.frame.size.width, self.frame.size.height - CGRectGetMaxY(_listView.frame));
    // 2. contentSize
    _listContainerView.contentSize = CGSizeMake(self.frame.size.width * _originalTitles.count, _listContainerView.frame.size.height);
    // 3. currentOffset
    [_listContainerView setUpInitOffset:CGPointMake(self.frame.size.width * _currentSelectIndex, 0)];
}
#pragma mark --  FZTagListContainerView delegate
- (void)FZTagListContainerViewScrollCurrentOffSet:(CGPoint)curOffSet beforeOffSet:(CGPoint)beforeOffSet{
    // 1.计算下方滑动进度
    CGFloat curOffSetX = curOffSet.x;
    CGFloat pageWidth = _listContainerView.frame.size.width;
    CGFloat currentFloorIndex = floor(curOffSetX / pageWidth); //计算得到index
    CGFloat progress = (curOffSetX - currentFloorIndex * pageWidth) / pageWidth;
    
    // 2.计算方向，告知listView索引
    BOOL isScrollViewToRight = curOffSetX > beforeOffSet.x;
    // 3.计算listView索引
    NSInteger fromIndex = 0;
    NSInteger toIndex = 0;
    if(isScrollViewToRight){ // ok
        fromIndex = currentFloorIndex;
        toIndex   = fromIndex + 1;
    }else{
        fromIndex = currentFloorIndex + 1;
        toIndex = currentFloorIndex < 0 ? 0 : currentFloorIndex;
        progress = 1 - progress;
    }
    if(currentFloorIndex >= _originalTitles.count - 1){ //在最右边标签滚动时
        fromIndex = _originalTitles.count - 1;
        toIndex = fromIndex;
    }
    // 4.执行 listView transition动画
    [_listView transitionFromIndex:fromIndex toIndex:toIndex progress:progress animated:YES];
}

#pragma mark -- FZTagListView delegate
- (void)FZTagListView:(FZTagListView *)tagListView clickAtIndex:(NSInteger)index{
    _currentSelectIndex = index;
    
    // 1.scroll containerView
    [_listContainerView scrollContainerViewToIndex:index animated:NO];
}

#pragma mark - cache
@end

