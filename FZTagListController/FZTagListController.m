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
    
    NSInteger _curSelectIndex;
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
    // listView
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
    
    // 3.update data
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(titles)]){
        _originalTitles =  [self.dataSource titles];
        [_listView setUpStringArray:_originalTitles];
    }
    
    // containerView setup
    // 4. frame
    _listContainerView.frame = CGRectMake(0, CGRectGetMaxY(_listView.frame), self.frame.size.width, self.frame.size.height - CGRectGetMaxY(_listView.frame));
    // 5.contentSize
    _listContainerView.contentSize = CGSizeMake(self.frame.size.width * _originalTitles.count? : 1, 0);
    // 6.load view
    
}

- (void)_addTagListView{
    FZTagListView *listView = [[FZTagListView alloc] init];
    listView.delegate = self;
    [self addSubview:listView];
    _listView = listView;
}

- (void)_addContainerView{
    FZTagListContainerView *listContainerView = [[FZTagListContainerView alloc] init];
    listContainerView.delegate = self;
    [self addSubview:listContainerView];
    
    _listContainerView = listContainerView;
}

#pragma mark --  FZTagListContainerView delegate
- (void)FZTagListContainerViewScrollCurrentOffSet:(CGPoint)curOffSet beforeOffSet:(CGPoint)beforeOffSet{
    CGFloat curOffSetX = curOffSet.x;
    CGFloat beforeOffSetX = beforeOffSet.x;
    CGFloat progress = fabs(curOffSetX - beforeOffSetX);
    NSInteger toIndex = _curSelectIndex;
    if(curOffSetX < beforeOffSetX){
        toIndex = _curSelectIndex > 1?_curSelectIndex - 1 : _curSelectIndex;
    }else{
        toIndex = (_curSelectIndex + 1) == (_originalTitles.count - 1) ? _curSelectIndex + 1 : _curSelectIndex;
    }
    // listView transition
    [_listView transitionFromIndex:_curSelectIndex toIndex:toIndex progress:progress animated:YES];
}

#pragma mark -- FZTagListView delegate
- (void)FZTagListView:(FZTagListView *)tagListView clickAtIndex:(NSInteger)index{
    _curSelectIndex = index;
}
@end
