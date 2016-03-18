//
//  SpringBoardServicesTableViewController.m
//  PrivateTest
//
//  Created by 刘向宏 on 16/3/18.
//  Copyright © 2016年 刘向宏. All rights reserved.
//

#import "LSApplicationWorkspaceTableViewController.h"

#import "NSObject+methods.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import "LSApplicationProxy.h"


@interface LSApplicationWorkspaceTableViewController ()

@end

@implementation LSApplicationWorkspaceTableViewController{
    NSArray *apps;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    apps = [workspace performSelector:@selector(allApplications)];
    NSLog(@"apps: %@", apps);
    [apps.firstObject logMethods];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return apps.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [apps[indexPath.row] itemName];
    cell.detailTextLabel.text = [apps[indexPath.row] applicationIdentifier];
//    LSApplicationProxy *p = apps[indexPath.row];
//    NSLog(@"%@",p.vendorName);
//    NSLog(@"%@",p.itemName);
//    NSLog(@"%@",p.applicationType);
//    NSLog(@"%@",p.applicationDSID);
//    NSLog(@"%@",p.applicationVariant);
//    NSLog(@"%@",p.sourceAppIdentifier);
//    cell.imageView.image = [UIImage imageWithData:[p iconDataForVariant:0]];
//    NSLog(@"UIImage %@",[UIImage imageWithData:[p iconDataForVariant:0]]);
//    NSLog(@"UIImage %@",[p privateDocumentIconNames]);
//    NSLog(@"UIImage %@",[p privateIconsDictionary]);
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
