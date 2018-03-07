//
//  ViewController.m
//  FZTagListControllerDemo
//
//  Created by 罗富中 on 2018/3/2.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "ViewController.h"
#import "FZTagListController.h"
#import "CollectionViewController.h"
#import "ListViewController.h"
#import "CustomViewController.h"

@interface ViewController ()<FZTagListControllerDataSource,FZTagListControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self test1];
}

- (void)test1{
    FZTagListController *controller = [[FZTagListController alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44)];
    controller.dataSource = self;
    controller.delegate = self;
    controller.normalColor = [UIColor blackColor];
    controller.selectedColor = [UIColor redColor];
    controller.normalFont = [UIFont systemFontOfSize:15];
    controller.selectedFont = [UIFont systemFontOfSize:18];
    controller.selectedScale = 1.2;
    controller.underLineBgColor = [UIColor blueColor];
    controller.tagTopMagin = 10;
    controller.tagHorizontalMargin = 15;
    controller.tagListHeight = 44;
    controller.currentSelectIndex = 2;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    leftView.backgroundColor = [UIColor redColor];
    controller.tagListLeftEdgeCustomView = leftView;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    rightView.backgroundColor = [UIColor redColor];
    controller.tagListRightEdgeCustomView = rightView;
    
    [controller setUpView];
    [self.view addSubview:controller];
}
- (NSArray<NSString *> *)titles{
    return @[@"音乐",@"视频",@"经典",@"小品大全",@"美术最佳",@"电影爱好者",@"音乐",@"视频",@"经典",@"小品",@"美术",@"电影"];
}

- (UIView *)viewForTagListControllerAtIndex:(NSInteger)index{
    if (index%3 == 0) {
        CustomViewController *VC = [[CustomViewController alloc]init];
        VC.text = [@(index) stringValue];
        return VC.view;
    }else if (index%3 == 1) {
        ListViewController *VC = [[ListViewController alloc]init];
        VC.text = [@(index) stringValue];
        return VC.view;
    }else {
        CollectionViewController *VC = [[CollectionViewController alloc]init];
        VC.text = [@(index) stringValue];
        return VC.view;
    }
}

@end
