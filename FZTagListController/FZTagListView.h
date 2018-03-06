//
//  FZTagListView.h
//  FZTagListController
//
//  Created by 罗富中 on 2018/3/2.
//  Copyright © 2018年 George_luofz. All rights reserved.
//  上部标签栏部分

#import <UIKit/UIKit.h>

@class FZTagListView;
@protocol FZTagListViewDelegate <NSObject>
// 点击某个标签触发
- (void)FZTagListView:(FZTagListView *)tagListView clickAtIndex:(NSInteger)index;

@end

@class FZTagListController;
@interface FZTagListView : UIView
@property (nonatomic, assign)   id<FZTagListViewDelegate>   delegate;
@property (nonatomic) id style;

@property (nonatomic, assign) CGFloat   tagListHeight;
@property (nonatomic, assign) CGFloat   tagHorizontalMargin;              // 标签之间水平间距
@property (nonatomic, assign) CGFloat   tagTopMagin;
@property (nonatomic, assign) CGFloat   underlineLength;                  //下划线长度，如果不设置，使用字符串长度
@property (nonatomic, assign) BOOL      useConstantUnderLineLength;       //是否使用固定下划线长度，默认为NO

@property (nonatomic, strong) UIColor   *normalColor;
@property (nonatomic, strong) UIColor   *selectedColor;
@property (nonatomic, strong) UIFont    *normalFont;
@property (nonatomic, strong) UIFont    *selectedFont;

@property (nonatomic, strong) UIColor   *underLineBgColor;          // 下划线长度是否使用字体长度，默认使用

@property (nonatomic, strong) UIView    *leftEdgeCustomView;        //左侧自定义视图
@property (nonatomic, strong) UIView    *rightEdgeCustomView;       //右侧自定义视图
@property (nonatomic, assign) CGFloat   underLineAnimationDuration; //下划线滚动动画时长，默认0.25f

@property (nonatomic, weak)   FZTagListController   *listController; //引用父视图，可以拿它的属性
// 更新配置
- (void)setupRenderPreference;

// 2.数据部分
- (void)setUpStringArray:(NSArray<NSString *> *)strings;
//- (void)updateTitle:(NSString *)title atIndex:(NSInteger)index;
//- (void)updateTittles:(NSArray<NSString *> *)titles atIndexArray:(NSArray<NSNumber *> *)indexArray;

//- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated;
- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress animated:(BOOL)animated;
@end
