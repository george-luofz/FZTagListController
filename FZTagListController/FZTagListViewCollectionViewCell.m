//
//  FZTagListViewCollectionViewCell.m
//  FZTagListController
//
//  Created by 罗富中 on 2018/3/2.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "FZTagListViewCollectionViewCell.h"

@implementation FZTagListViewCollectionViewCell

- (instancetype)init
{
    if (self = [super init]) {
        [self addTabTitleLabel];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self addTabTitleLabel];
    }
    return self;
}
- (void)addTabTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor darkTextColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.frame = self.contentView.bounds;
}


@end
