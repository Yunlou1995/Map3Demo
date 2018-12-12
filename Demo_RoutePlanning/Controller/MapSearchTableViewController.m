//
//  MapSearchTableViewController.m
//  Demo_RoutePlanning
//
//  Created by 莱月再生 on 2018/12/12.
//  Copyright © 2018 top.yunloucity. All rights reserved.
//

#import "MapSearchTableViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface MapSearchTableViewController ()<UISearchControllerDelegate, UISearchResultsUpdating, AMapSearchDelegate>

@property(strong, nonatomic)AMapSearchAPI* searchAPI;
@property(strong, nonatomic)UISearchController* searchController;

@property(strong, nonatomic)NSMutableArray<AMapPOI*>* POIArray;


@end

@implementation MapSearchTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.POIArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.searchAPI = [[AMapSearchAPI alloc] init];
    self.searchAPI.delegate = self;

    self.tableView.backgroundColor = UIColor.whiteColor;

    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;

    self.searchController.dimsBackgroundDuringPresentation = false;
//    if (@available(iOS 9.1, *)) {
//        [self.searchController setObscuresBackgroundDuringPresentation:true];
//    } else {
            // Fallback on earlier versions
//    }
    self.searchController.delegate = self;
    self.navigationItem.titleView = self.searchController.searchBar;

    [self.tableView reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.POIArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }

    AMapPOI * poi = [self.POIArray objectAtIndex:indexPath.row];
    cell.textLabel.text = poi.name;

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

#pragma mark - search delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {

}
@end
