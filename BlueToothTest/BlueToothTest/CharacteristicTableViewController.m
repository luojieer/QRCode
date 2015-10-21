//
//  CharacteristicTableViewController.m
//  BluetoothTest
//
//  Created by Cheetah on 15/10/21.
//  Copyright © 2015年 diveinedu. All rights reserved.
//

#import "CharacteristicTableViewController.h"

@interface CharacteristicTableViewController ()<CBPeripheralDelegate>

@end

@implementation CharacteristicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _peripheral.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _service.characteristics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"ccell" forIndexPath:indexPath];
    CBCharacteristic *characteristic = [_service.characteristics objectAtIndex:indexPath.row];
    cell.textLabel.text = characteristic.UUID.UUIDString;
    cell.detailTextLabel.text = [self nameWithProperty:characteristic.properties];
    return cell;
}


- (NSString *)nameWithProperty:(CBCharacteristicProperties)property {
    switch (property) {
        case CBCharacteristicPropertyBroadcast:
            return @"Broadcast: 广播";
        case CBCharacteristicPropertyRead:
            return @"Read: 读";
        case CBCharacteristicPropertyWriteWithoutResponse:
            return @"Write: 无响应写";
        case CBCharacteristicPropertyWrite:
            return @"Write: 写";
        case CBCharacteristicPropertyNotify:
            return @"Notify: 通知";
        case CBCharacteristicPropertyIndicate:
            return @"Indicate: 指示";
        case CBCharacteristicPropertyAuthenticatedSignedWrites:
            return @"Write: 认证签名后写";
        case CBCharacteristicPropertyExtendedProperties:
            return @"Extended: 扩展属性";
        case CBCharacteristicPropertyNotifyEncryptionRequired:
            return @"Notify: 需要加密的通知";
        case CBCharacteristicPropertyIndicateEncryptionRequired:
            return @"Indicate: 需要加密的指示";
        default:
            return nil;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CBCharacteristic *c = _service.characteristics[indexPath.row];
#if 0
    //读一个数据
    [_peripheral readValueForCharacteristic:c];
#else
    //设置通知
    //    [_peripheral setNotifyValue:YES forCharacteristic:c];
#endif
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    //读取到的值
    NSLog(@"%@", characteristic.value);
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    //获取通知设置状态
    NSLog(@"%@", characteristic.value);
}

- (void)writeDataToPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *) c  data:(NSData *)data
{
    //    CBCharacteristic *c = _service.characteristics[indexPath.row];
    //给设备写数据
    [_peripheral writeValue:data forCharacteristic:c
                       type:CBCharacteristicWriteWithResponse];
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"写");
}

#pragma mark segue

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    CBCharacteristic *c = [_service.characteristics objectAtIndex:indexPath.row];
    
    if ([[c.UUID.UUIDString lowercaseString] isEqualToString:@"fff1"]) {
        //接收  通知值
        [_peripheral setNotifyValue:YES forCharacteristic:c];
        
    }else if ([[c.UUID.UUIDString lowercaseString] isEqualToString:@"fff2"]){
        //发送 数据值
        
        unsigned char  _data[] = {0xfd,0xfd,0xfa,0x05,0x0d,0x0a};
        
        NSData *data = [NSData dataWithBytes:_data length:sizeof(_data)];
        
        [self writeDataToPeripheral:_peripheral characteristic:c data:data];
        
    }
    
    
    return NO;
}



@end
