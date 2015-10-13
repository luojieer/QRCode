//
//  RegorLeftViewController.m
//  布丁动画复习
//
//  Created by Roger on 15/10/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "RegorLeftViewController.h"
#import "RegorLeftViewControllerCell.h"
#import "Masonry.h"
#import "RegorLeftUserInfoView.h"
@interface RegorLeftViewController()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_iconArray;
    NSArray *_titleArray;
    
}
@end


@implementation RegorLeftViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    _iconArray = @[@"side_menu_icon_history",@"side_menu_icon_cache",@"side_menu_icon_statistics",@"side_menu_icon_promotor",@"side_menu_icon_setting",@"side_menu_icon_notification"];
    _titleArray = @[@"追番纪录",@"离线缓存",@"布丁统计",@"布丁娘送周边",@"布丁设置",@"布丁通知"];
    
    
    UITableView *tableView  = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1.jpg"]];
    
    [tableView registerClass:[RegorLeftViewControllerCell class] forCellReuseIdentifier:@"RegorLeftViewControllerCell"];
    
    //头
    RegorLeftUserInfoView *headerView = [[RegorLeftUserInfoView alloc]initWithFrame:CGRectMake(0, 0, 320, 240)];
    headerView.avatarImage = [UIImage imageNamed:@"default_avatar"];
    headerView.followerCount = 11;
    headerView.layer.cornerRadius = 80/2;
    headerView.layer.masksToBounds = YES;
    headerView.fansCount = 22;
    headerView.isLogin = YES;
    [headerView addAvatarTarget:self action:@selector(userInfoAvatarClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addFollerTarget:self action:@selector(userInfoFollowerClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addFansTarget:self action:@selector(userInfoFansClicked:) forControlEvents:UIControlEventTouchUpInside];
    tableView.tableHeaderView = headerView;
   
    
    
    
//    消除尾部实线
    UIView *footerView = [[UIView alloc]init];
    tableView.tableFooterView = footerView;
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_titleArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RegorLeftViewControllerCell *bodyCell = nil;
    
    bodyCell = [tableView dequeueReusableCellWithIdentifier:@"RegorLeftViewControllerCell" forIndexPath:indexPath];
    bodyCell.titleLabel.text = _titleArray[indexPath.row];
    UIImage *image = [UIImage imageNamed:_iconArray[indexPath.row] ];
    bodyCell.iconImage.image = image;
    return bodyCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

- (void)userInfoAvatarClicked:(id)sender{
    NSLog(@"头像被点击");
    
}
- (void)userInfoFollowerClicked:(id)sender{
    NSLog(@"关注被点击");
    
}
- (void)userInfoFansClicked:(id)sender{
    NSLog(@"fens被点击");
    
}



@end





































