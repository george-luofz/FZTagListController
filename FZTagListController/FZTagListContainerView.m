//
//  FZTagListContainerView.m
//  FZTagListController
//
//  Created by 罗富中 on 2018/3/2.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "FZTagListContainerView.h"

@interface FZTagListContainerView()<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
}
@end
@implementation FZTagListContainerView

- (instancetype)init{
    if (self = [super init]){
        
    }
    return self;
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _scrollView.frame = self.bounds;
}
- (void)scrollContainerViewFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated{
    
}

#pragma mark - private method
- (void)_addSubViews{
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    // 1.frame
    // 2.contantSize
    // 3.addSubView
    [self addSubview:scrollView];
    _scrollView = scrollView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}


@end
