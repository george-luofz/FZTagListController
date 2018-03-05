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

@interface FZTagListController()<FZTagListViewDelegate>
{
    FZTagListView           *_listView;
    FZTagListContainerView  *_listContainerView;
    
    NSArray *_originalTitles;
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
}

- (void)_addTagListView{
    FZTagListView *listView = [[FZTagListView alloc] init];
    listView.delegate = self;
    [self addSubview:listView];
    _listView = listView;
}

- (void)_addContainerView{
    
}

#pragma mark --  view height

@end
