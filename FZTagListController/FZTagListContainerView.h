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
// 1.2
@protocol FZTagListContainerViewDelegate <NSObject>
- (void)scrollContainerViewFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress animated:(BOOL)animated;
@end

@interface FZTagListContainerView : UIView
@property (nonatomic, assign) id<FZTagListContainerViewDelegate> delegate;


- (void)scrollContainerViewFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated;

@end
