//
//  ViewController.m
//  BlueToothTest
//
//  Created by Roger on 15/10/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import <coreBluetooth/coreBluetooth.h>
#import "SVProgressHUD.h"
#import "SeviceTableViewController.h"

@interface ViewController ()<CBCentralManagerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    CBCentralManager *_centerManager;
    NSMutableArray *_peripheralArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    1、创建中心设备管理器对象，开始更新iOS设备的蓝牙设备状态
//    调用- (void)centralManagerDidUpdateState:(CBCentralManager *)central
    _peripheralArray = [NSMutableArray array];
    _centerManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CBCeneterManager
//2、必须实现，关注iOS的蓝牙的设备的状态变化
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStateUnknown:
        case CBCentralManagerStateResetting:
        case CBCentralManagerStateUnsupported:
            [SVProgressHUD showErrorWithStatus:@"该设备不支持蓝牙"];
            break;
        case CBCentralManagerStatePoweredOff:
            [SVProgressHUD showErrorWithStatus:@"请打开蓝牙开关"];
            break;
        case CBCentralManagerStatePoweredOn:
            [SVProgressHUD showErrorWithStatus:@"已经打开蓝牙，开始扫描外设"];
            //开始扫描。nil表示扫描所有的蓝牙服务
            [_centerManager scanForPeripheralsWithServices:nil options:nil];
            break;
        default:
            break;
    }
}
//3、发现设备
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"adv:%@",advertisementData);
    NSLog(@"rssi:%@",RSSI);
    [_peripheralArray addObject:peripheral];
    [self.tableView reloadData];
    
}

#pragma mark UITableViewDataSource/delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    return [_peripheralArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"PCELL" forIndexPath:indexPath];
    CBPeripheral *peripheral = [_peripheralArray objectAtIndex:indexPath.row];
    cell.textLabel.text = peripheral.name;
    cell.detailTextLabel.text = peripheral.RSSI.stringValue;
    return cell;
}

//发现周边设备
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    //获取点击的cell的位置
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    CBPeripheral *peripheral = _peripheralArray[indexPath.row];
//    if (peripheral.state == CBPeripheralStateDisconnected) {
//        return YES;
//    }
    [SVProgressHUD showWithStatus:@"正在连接设备"];
    //4、连接外设
    [_centerManager connectPeripheral:peripheral options:nil];
    return NO;
}
//已连接外设
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"已连接:%@",peripheral.name);
    [SVProgressHUD showSuccessWithStatus:@"连接成功"];
    NSInteger row = [_peripheralArray indexOfObject:peripheral];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//    获取cell
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = peripheral.state == CBPeripheralStateConnected?[UIColor greenColor]:[UIColor redColor];
    //执行跳转
    [self performSegueWithIdentifier:@"p2s" sender:cell];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //获取点击cell位置
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    SeviceTableViewController *serviceCtrl = segue.destinationViewController;
    serviceCtrl.peripheral = _peripheralArray[indexPath.row];
}

@end


























