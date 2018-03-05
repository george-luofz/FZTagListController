//
//  FZTagListContainerView.h
//  FZTagListController
//
//  Created by 罗富中 on 2018/3/2.
//  Copyright © 2018年 George_luofz. All rights reserved.
//  下部滚动视图部分

#import <UIKit/UIKit.h>

// 1.滚动
// 1.1.滚动时进度告诉tag视图
// 1.2 滚动到指定位置
@protocol FZTagListContainerViewDelegate <NSObject>
- (void)FZTagListContainerViewScrollCurrentOffSet:(CGPoint)curOffSet beforeOffSet:(CGPoint)beforeOffSet;
@end

@interface FZTagListContainerView : UIView
@property (nonatomic, assign) id<FZTagListContainerViewDelegate> delegate;
@property (nonatomic, assign) CGSize    contentSize;

- (void)scrollContainerViewToOffset:(CGPoint)offSet animated:(BOOL)animated;
//- (void)addSubView:(UIView *)view atIndex:(NSInteger)index;


@end
