//
//  SeviceTableViewController.m
//  BlueToothTest
//
//  Created by Roger on 15/10/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SeviceTableViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

#import "SVProgressHUD.h"
#import "CharacteristicTableViewController.h"

@interface SeviceTableViewController ()<CBPeripheralDelegate>


@end

@implementation SeviceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //＊＊＊＊＊＊5、发现设备上的所有服务，比较慢＊＊＊＊＊
    //    也可以制定只发现制定的UUID的服务
    [_peripheral discoverServices:nil];
    _peripheral.delegate = self;
    [SVProgressHUD showWithStatus:@"conect"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _peripheral.services.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"SCELL" forIndexPath:indexPath];
    
    CBService *service = [_peripheral.services objectAtIndex:indexPath.row];
    NSLog(@"service:%@", service);
    cell.textLabel.text =  service.UUID.UUIDString;

    return cell;
}

// ＊＊＊＊＊＊＊＊＊6、已经发现服务＊＊＊＊＊＊＊＊
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    [SVProgressHUD showSuccessWithStatus:@"已经发现服务"];
    [self.tableView reloadData];
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error
{
    NSLog(@"%@ 已经发现特征",service.UUID.UUIDString);
    
    [SVProgressHUD showSuccessWithStatus:@"发现特征"];
    
    NSInteger row = [_peripheral.services indexOfObject:service];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    //获取Cell
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    //执行跳转
    [self performSegueWithIdentifier:@"s2c" sender:cell];
    
}

#pragma mark segue

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    CBService *service = _peripheral.services[indexPath.row];
    if (service.characteristics.count) {
        return YES;
    }
    else {
        [SVProgressHUD showWithStatus:@"开始发现特征"];
        //6. 发现一个服务上的所有特征对象
        [_peripheral discoverCharacteristics:nil forService:service];
        return NO;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //获取点击的Cell位置
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    CharacteristicTableViewController *serviceCtrl = segue.destinationViewController;
    serviceCtrl.peripheral = _peripheral;
    serviceCtrl.service = [_peripheral.services objectAtIndex:indexPath.row];
}


@end



















