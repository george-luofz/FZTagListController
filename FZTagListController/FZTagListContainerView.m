//
//  FZTagListContainerView.m
//  FZTagListController
//
//  Created by 罗富中 on 2018/3/2.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "FZTagListContainerView.h"

@interface FZTagListContainerView()<UIScrollViewDelegate>{
    CGPoint _beforeOffset;
}
@end
@implementation FZTagListContainerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self _initProperty];
    }
    return self;
}

- (void)addSubView:(UIView *)view atIndex:(NSInteger)index{
    CGRect frame = CGRectMake(index*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    view.frame = frame;
    [self addSubview:view];
}

- (void)scrollContainerViewFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated{
    
}

- (void)setUpInitOffset:(CGPoint)offSet{
    _beforeOffset = offSet;
}
#pragma mark - private method
- (void)_initProperty{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    self.pagingEnabled = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // caculate progress
    if(self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(FZTagListContainerViewScrollCurrentOffSet:beforeOffSet:)]){
        [self.scrollDelegate FZTagListContainerViewScrollCurrentOffSet:scrollView.contentOffset beforeOffSet:_beforeOffset];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // record
    _beforeOffset = scrollView.contentOffset;
}

@end
