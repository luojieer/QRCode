//
//  RegorLeftUserInfoView.m
//  布丁动画复习
//
//  Created by Roger on 15/10/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "RegorLeftUserInfoView.h"
#import "Masonry.h"
@interface RegorLeftUserInfoView()
{
    UIButton *_avatarButton;
    UILabel *_nickNameLabel;
    UIButton *_followerButton;
    UIButton *_fansButton;
}
@end

@implementation RegorLeftUserInfoView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createAvatarButton];
        [self createNickNameLabel];
        [self createFollowerButton];
        [self createFansButton];
    }
    return self;
}
#pragma mark 创建控件 method 具体实现类A
- (void)createAvatarButton
{
    _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_avatarButton setBackgroundImage:[UIImage imageNamed:@"default_avatar"] forState:UIControlStateNormal];
    //设置圆⾓角
    //裁剪掉边界以外的
    _avatarButton.layer.cornerRadius = 80/2;
//    //添加到当前这个⾃自定义视图内
    _avatarButton.layer.masksToBounds = YES;
    //添加外光圈
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 80, 80);
    layer.cornerRadius = 80/2;
    layer.masksToBounds = YES;
    layer.borderWidth = 4;
    layer.borderColor = [UIColor orangeColor].CGColor;
    [_avatarButton.layer addSublayer:layer];


    [self addSubview:_avatarButton];
    [_avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@60);
        make.left.equalTo(@96);
        make.size.equalTo(MASBoxValue(CGSizeMake(80, 80)));
    }];
}
- (void)createNickNameLabel
{
    //Sorry,此⽅方法⽆无注释
    _nickNameLabel = [[UILabel alloc]init];
    _nickNameLabel.text = @"登录以获取追番纪录";
    _nickNameLabel.textAlignment = NSTextAlignmentCenter;
    _nickNameLabel.textColor = [UIColor whiteColor];
    _nickNameLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:_nickNameLabel];
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarButton.mas_bottom).offset(10);
        make.centerX.equalTo(_avatarButton.mas_centerX);
        make.size.equalTo(MASBoxValue(CGSizeMake(200, 40)));
    }];
}
- (void)createFollowerButton
{
    _followerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_followerButton setTitle:[NSString stringWithFormat:@"关注 %lu", _followerCount] forState:UIControlStateNormal];
    [self addSubview:_followerButton];
    [_followerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nickNameLabel.mas_bottom).offset(10);
        make.right.equalTo(_nickNameLabel.mas_centerX);
        make.size.equalTo(MASBoxValue(CGSizeMake(120, 40)));
    }];
//    _followerButton.hidden = YES;
    
}
- (void)createFansButton
    {
        _fansButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fansButton setTitle:[NSString stringWithFormat:@"粉丝%ld",_fansCount] forState:UIControlStateNormal];
    [self addSubview:_fansButton];
    [_fansButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nickNameLabel.mas_bottom).offset(10);
        make.left.equalTo(_nickNameLabel.mas_centerX);
        make.size.equalTo(MASBoxValue(CGSizeMake(120, 40)));
        }];
//    _fansButton.hidden = YES;
}

#pragma mark set/get method 具体实现类B
- (void)setAvatarImage:(UIImage *)avatarImage{
    [_avatarButton setBackgroundImage:avatarImage forState:UIControlStateNormal];
    
}
- (UIImage *)avatarImage{
    return [_avatarButton backgroundImageForState:UIControlStateNormal];
}

//- (void)setIsLogin:(BOOL)isLogin{
//    //设置粉丝和关注的隐藏
//    _followerButton.hidden = !_isLogin;
//    _fansButton.hidden = !_isLogin;
//}
- (void)setFansCount:(NSUInteger)fansCount{
    _fansCount = fansCount;
    [_fansButton setTitle:[NSString stringWithFormat:@"粉丝%ld",_fansCount] forState:UIControlStateNormal];
}
- (void)setFollowerCount:(NSUInteger)followerCount{
    _followerCount = followerCount;
    [_followerButton setTitle:[NSString stringWithFormat:@"关注%ld",_followerCount] forState:UIControlStateNormal];
}

#pragma mark target/actions method 具体实现类C
- (void)addAvatarTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [_avatarButton addTarget:target action:action forControlEvents:controlEvents];
}
- (void)addFollerTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [_followerButton addTarget:target action:action forControlEvents:controlEvents];
}
- (void)addFansTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [_fansButton addTarget:target action:action forControlEvents:controlEvents];
}
@end




























