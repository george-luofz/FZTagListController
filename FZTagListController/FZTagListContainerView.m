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
    
    CGPoint _beforeOffset;
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

- (void)setContentSize:(CGSize)contentSize{
    _scrollView.contentSize = contentSize;
}

- (void)addSubView:(UIView *)view atIndex:(NSInteger)index{
    
}

- (void)scrollContainerViewFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated{
    
}

#pragma mark - private method
- (void)_addSubViews{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    
    // 1.frame
    // 2.contantSize
    // 3.addSubView
    [self addSubview:scrollView];
    _scrollView = scrollView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // caculate progress
//    if(curOffset.x > _beforeOffset.x){ //right scroll
//        progress = (curOffset.x - _beforeOffset.x) / pageWidth;
//    }else{
//        progress = (curOffset.x - _beforeOffset.x) / pageWidth;
//    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(FZTagListContainerViewScrollCurrentOffSet:beforeOffSet:)]){
        [self.delegate FZTagListContainerViewScrollCurrentOffSet:scrollView.contentOffset beforeOffSet:_beforeOffset];
    }
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    // record
    _beforeOffset = scrollView.contentOffset;
}

@end
