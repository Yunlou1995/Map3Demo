//
//  TableViewController.m
//  Demo_RoutePlanning
//
//  Created by 莱月再生 on 2018/12/7.
//  Copyright © 2018 top.yunloucity. All rights reserved.
//

#import "TableViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "AMAPViewController.h"

static NSString * SDKName = @"SDKName";
static NSString * SDKKey = @"SDKKey";

@interface TableViewController ()
{
    NSMutableArray * _mapSDKArray;
}
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择SDK";

    NSString* amapKey = @"a170037c91485f1ab49941b87e2189e3";
    NSString* bmapKey = @"";

//    高德地图配置
    [AMapServices sharedServices].apiKey = amapKey;
    [[AMapServices sharedServices] setEnableHTTPS:YES];

//    百度地图配置

    _mapSDKArray = [NSMutableArray array];

    NSDictionary* amap = @{SDKName:@"高德地图",SDKKey:amapKey};
    NSDictionary* bmap = @{SDKName:@"百度地图",SDKKey:bmapKey};

    [_mapSDKArray addObjectsFromArray:@[amap,bmap]];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mapSDKArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    }
    cell.textLabel.text = [[_mapSDKArray objectAtIndex:indexPath.row] objectForKey:SDKName];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AMAPViewController * amapVC = [[AMAPViewController alloc] init];
        [self.navigationController pushViewController:amapVC animated:true];
    }else {

    }

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
