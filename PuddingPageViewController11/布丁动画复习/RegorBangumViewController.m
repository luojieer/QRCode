//
//  RegorBangumViewController.m
//  布丁动画复习
//
//  Created by Roger on 15/10/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "RegorBangumViewController.h"
#import "RegorLeftViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "WEITitleView.h"
#import "RegorCenterViewController.h"
#import "RegorFirstPageViewContrller.h"


@interface RegorBangumViewController()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
{
    NSArray *_pageArray;
    NSInteger _currentIndex;
    WEITitleView *_titleView;

}
@end

@implementation RegorBangumViewController
- (void)viewDidLoad{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor blueColor];
    [self createHeaderController];

    [self addCenterTitle];
    
    [self createPageControllerInit];
    
}
#pragma mark controlLeftView
- (void)createHeaderController{
//    在导航中添加图片，并对图片切圆角
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 45)];
    UIImage *image = [[UIImage imageNamed:@"header.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(controlLeft:) forControlEvents: UIControlEventTouchUpInside];
    
    leftButton.layer.cornerRadius = 45/2;
    leftButton.layer.masksToBounds = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];

}

- (void)controlLeft:(RegorLeftViewController *)left{
    //使用button控制左边视图
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark centerController
- (void)addCenterTitle{
    _titleView = [[WEITitleView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    _titleView.titleArray = @[@"番组",@"推荐"];
    [_titleView addTarget:self action:@selector(titleViewValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = _titleView;

}
- (void)titleViewValueChanged:(WEITitleView *)sender
{
    if (sender.selectedIndex == 0) {
        [self setViewControllers:@[[_pageArray objectAtIndex:sender.selectedIndex]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }else{
        [self setViewControllers:@[[_pageArray objectAtIndex:sender.selectedIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
}
#pragma mark pageViewController


- (void)createPageControllerInit{
    
    
    RegorCenterViewController *centerCtrl = [RegorCenterViewController new];

    RegorFirstPageViewContrller *firstCtrl = [RegorFirstPageViewContrller new];
    _pageArray = @[centerCtrl,firstCtrl];
    
    [self setViewControllers:@[[_pageArray firstObject]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.dataSource = self;
    self.delegate = self;
    [self gestureDeal];

}

- (void)gestureDeal{
    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)v;
            v.superview.backgroundColor = [UIColor whiteColor];
            [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
        }
    }

}

#pragma mark pageView delegate 分页判断
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    if ([_pageArray indexOfObject:viewController] == 0) {
        return nil;
    }else{
        return _pageArray[0];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    if ([_pageArray indexOfObject:viewController] == 1) {
        return nil;
    }else{
        return _pageArray[1];
    }
}
#pragma mark UIPageViewController Delegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    UIViewController *currentViewController = [pageViewController.viewControllers firstObject];
    _currentIndex =  [_pageArray indexOfObject:currentViewController];
    _titleView.selectedIndex = _currentIndex;
}
//
////翻页位置（左、中、右）
- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    return UIPageViewControllerSpineLocationMin;
}
//
////如果为滚动翻页，实现下面两个方法后，会显示UIPageControl指示页面
////总页数
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 2;
}
////当前页号
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return [_pageArray indexOfObject:pageViewController.viewControllers.firstObject];
}
//
//
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    UIScrollView *scrollView = (UIScrollView *)object;
    
    NSValue *value = change[NSKeyValueChangeNewKey];
    CGPoint v = value.CGPointValue;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    //UIPageViewController机制使用了三个页面，当前页处于中间
    //当显示第0页，并且继续右拖时，中断scrollView上手势的识别
    if (_currentIndex == 0 && v.x <= width) {
        scrollView.panGestureRecognizer.enabled = NO;
        scrollView.panGestureRecognizer.enabled = YES;
    }
    else {
        self.mm_drawerController.panGestureRecognizer.enabled = NO;
        self.mm_drawerController.tapGestureRecognizer.enabled = NO;
        self.mm_drawerController.panGestureRecognizer.enabled = YES;
        self.mm_drawerController.tapGestureRecognizer.enabled = YES;
        //        panGestureRecognizer与tapGestureRecognizer的修改,在MMDrawerController中的MMDrawerController头文件的99行添加上¥¥¥¥¥@property (nonatomic ,strong,readonly) UIPanGestureRecognizer *panGestureRecognizer;@property (nonatomic ,strong,readonly) UITapGestureRecognizer *tapGestureRecognizer;¥¥¥¥¥¥¥
//        在MMDrawerController的实现文件中1272-1282更改为
//        &&&&&-(void)setupGestureRecognizers{
//            _panGestureRecognizer  = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureCallback:)];
//            [_panGestureRecognizer setDelegate:self];
//            [self.view addGestureRecognizer:_panGestureRecognizer];
//            
//            _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureCallback:)];
//            [_tapGestureRecognizer setDelegate:self];
//            [_tapGestureRecognizer requireGestureRecognizerToFail:_panGestureRecognizer];
//            [self.view addGestureRecognizer:_tapGestureRecognizer];
//        }
//&&&&
//        在#pragma mark - UIGestureRecognizerDelegate后面添加手势同步方法- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//            return YES;
//        }



    }
}


@end






































