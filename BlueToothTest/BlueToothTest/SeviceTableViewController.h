//
//  SeviceTableViewController.h
//  BlueToothTest
//
//  Created by Roger on 15/10/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface SeviceTableViewController : UITableViewController

@property (nonatomic, strong) CBPeripheral *peripheral;

@end
