//
//  FZTagListController.h
//  FZTagListController
//
//  Created by 罗富中 on 2018/3/2.
//  Copyright © 2018年 George_luofz. All rights reserved.
//  标签列表视图

#import <UIKit/UIKit.h>
/**
 构建一个满足常用滑动功能的小轮子
 1. 滚动效果：下划线滚动、颜色渐变、标签放大效果
 2. 视图缓存：已加载视图缓存到内存、内存警告时释放内存
 3. 代码量级：尽量保持轻量级，代码少、可读性好、可扩展性良好
 **/
@protocol FZTagListControllerDataSource <NSObject>
// viewController / view
- (UIView *)viewForTagListControllerAtIndex:(NSInteger)index;
// tag数组
- (NSArray<NSString *> *)titles;
@end

@protocol FZTagListControllerDelegate <NSObject>
// 样式
// 事件
@end

//TODO:style

@interface FZTagListController : UIView                     //不用controller，外部可能会作为rootController
@property (nonatomic, assign) id<FZTagListControllerDataSource>  dataSource;
@property (nonatomic, assign) id<FZTagListControllerDelegate>    delegate;

// 1.tagList 配置
// 标签高度
@property (nonatomic, assign) CGFloat   tagListHeight;
@property (nonatomic) id style;

@property (nonatomic, strong) UIColor   *tagListBgColor;
@property (nonatomic, strong) UIColor   *normalColor;
@property (nonatomic, strong) UIColor   *selectedColor;
@property (nonatomic, strong) UIFont    *normalFont;
@property (nonatomic, strong) UIFont    *selectedFont;
@property (nonatomic, assign) CGFloat   selectedScale;      // 伸缩比例

@property (nonatomic, strong) UIColor   *underLineBgColor;  // 下划线长度是否使用字体长度，默认使用

@property (nonatomic, assign) CGFloat   tagHorizontalMargin;              // 标签之间间距
@property (nonatomic, assign) CGFloat   tagTopMagin;

@property (nonatomic, strong) UIView    *tagListLeftEdgeCustomView;     //左侧自定义视图
@property (nonatomic, strong) UIView    *tagListRightEdgeCustomView;    //右侧自定义视图

@property (nonatomic, assign) NSInteger currentSelectIndex;             //当前索引，默认为0，即第一项
// 2.数据部分
- (void)setUpStringArray:(NSArray<NSString *> *)strings;
- (void)updateTitle:(NSString *)title atIndex:(NSInteger)index;
- (void)updateTittles:(NSArray<NSString *> *)titles atIndexArray:(NSArray<NSNumber *> *)indexArray;

// 默认初始化方法
- (instancetype)initWithFrame:(CGRect)frame  NS_DESIGNATED_INITIALIZER;

// 当属性都设置完成，调用此方法配置内部视图
- (void)setUpView;

@end
