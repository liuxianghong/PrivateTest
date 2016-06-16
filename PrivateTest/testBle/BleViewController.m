//
//  BleViewController.m
//  PrivateTest
//
//  Created by 刘向宏 on 16/3/18.
//  Copyright © 2016年 刘向宏. All rights reserved.
//

#import "BleViewController.h"
#import "BluetoothManager.h"

@interface BleViewController ()

@end

@implementation BleViewController{
    BluetoothManager *manager;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    manager = [BluetoothManager sharedInstance];
    [self performSelector:@selector(bleIformation) withObject:nil afterDelay:1.0f] ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)bleClick:(id)sender
{
    
    BOOL currentState = [manager enabled] ;
    [manager setEnabled:!currentState];
    [manager setPowered:!currentState];
    NSLog(@"%@",[manager pairedDevices]);
    NSLog(@"%@",[manager connectedDevices]);
    NSLog(@"%@",[manager connectingDevices]);
    NSLog(@"%d",[BluetoothManager lastInitError]);
    
}

-(void)bleIformation{
    NSLog(@"%@",[manager localAddress]);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
