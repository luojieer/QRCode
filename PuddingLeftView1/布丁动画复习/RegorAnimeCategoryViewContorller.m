//
//  RegorAnimeCategoryViewContorller.m
//  布丁动画复习
//
//  Created by Roger on 15/10/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "RegorAnimeCategoryViewContorller.h"
#import "RegorCollectionViewCell.h"

@interface RegorAnimeCategoryViewContorller()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@end

@implementation RegorAnimeCategoryViewContorller
- (void)viewDidLoad
{
    [super viewDidLoad];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 20;
    flowLayout.minimumLineSpacing = 20;
    flowLayout.itemSize = CGSizeMake(50, 50);
    //设置分组边距
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collection = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collection.dataSource = self;
    collection.delegate = self;
    collection.backgroundColor = [UIColor redColor];
    
    [collection registerClass:[RegorCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    
    [self.view addSubview:collection];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RegorCollectionViewCell *cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}
@end









































































































































