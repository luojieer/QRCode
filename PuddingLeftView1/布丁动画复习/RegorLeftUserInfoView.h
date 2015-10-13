//
//  RegorLeftUserInfoView.h
//  布丁动画复习
//
//  Created by Roger on 15/10/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegorLeftUserInfoView : UIView
@property (nonatomic,strong,nullable) UIImage *avatarImage;
@property (nonatomic, readonly, nullable) UILabel *nickNameLable;
@property (nonatomic, assign) NSUInteger fansCount;
@property (nonatomic, assign) NSUInteger followerCount;
@property (nonatomic, assign) BOOL isLogin;


//子控件事件设置
- (void)addAvatarTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)addFansTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)addFollerTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(UIControlEvents)controlEvents;




@end
