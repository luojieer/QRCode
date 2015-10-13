//
//  RegorLeftViewControllerCell.m
//  布丁动画复习
//
//  Created by Roger on 15/10/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "RegorLeftViewControllerCell.h"
#import "Masonry.h"
@interface RegorLeftViewControllerCell()
{
//    UIImageView *_iconImage;

//    UIImageView *_rightImage;
}
@end

@implementation RegorLeftViewControllerCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        
    
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 30, 30)];
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 150, 30)];

        _titleLabel.textColor = [UIColor whiteColor];
        _rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(230, 5, 40, 30)];
        _rightImage.image = [UIImage imageNamed:@"home_anime_indicator"];
        [self.contentView addSubview:_iconImage];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_rightImage];
            }
    self.backgroundColor = [UIColor clearColor];
    return self;
}
@end









































