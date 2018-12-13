//
//  MapSearchTableViewController.m
//  Demo_RoutePlanning
//
//  Created by 莱月再生 on 2018/12/12.
//  Copyright © 2018 top.yunloucity. All rights reserved.
//

#import "MapSearchTableViewController.h"
#import "PoiDetailViewController.h"

@interface MapSearchTableViewController ()
<UISearchControllerDelegate,
UISearchResultsUpdating,
AMapSearchDelegate,
UISearchBarDelegate>

@property(strong, nonatomic)AMapSearchAPI* searchAPI;
@property(strong, nonatomic)UISearchController* searchController;
@property(strong, nonatomic)NSMutableArray* POIArray;

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

    self.navigationItem.title = @"搜索";

    self.searchAPI = [[AMapSearchAPI alloc] init];
    self.searchAPI.delegate = self;

    [self initSearchController];
    [self configureTableView];

    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.searchController.active = NO;
}

-(void)configureTableView {
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = UIColor.whiteColor;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellIdentifier"];
}

-(void)initSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.backgroundColor = UIColor.whiteColor;
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.placeholder = @"请输入要搜索的地点";
    self.searchController.dimsBackgroundDuringPresentation = false;
    self.searchController.searchBar.delegate = self;
    self.searchController.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.POIArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    MapPOIAnnotation * annotation = [self.POIArray objectAtIndex:indexPath.row];
    cell.textLabel.text = annotation.title;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MapPOIAnnotation * annotation = [self.POIArray objectAtIndex:indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(tableViewController:didSelectPOI:)]) {
        [_delegate tableViewController:self didSelectPOI:annotation];
    }
    [self.navigationController popViewControllerAnimated:true];
}


- (void)gotoDetailForPoi:(AMapPOI *)poi
{
    if (poi != nil) {
        PoiDetailViewController* detail = [[PoiDetailViewController alloc] init];
        detail.poi = poi;
        [self.navigationController pushViewController:detail animated:YES];
    }
}


#pragma mark - searchBar delegate
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"/n输入完毕了");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"/n点击了搜索按钮");
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"/n点击了取消按钮");
}

#pragma mark - map search delegate

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    [self.POIArray removeAllObjects];
    if (response.pois.count == 0) {
        return;
    }
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];

    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        [poiAnnotations addObject:[[MapPOIAnnotation alloc] initWithPOI:obj]];
    }];

    [self.POIArray addObjectsFromArray:poiAnnotations];

    [self.tableView reloadData];
}

#pragma mark - search delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString * inputStr = searchController.searchBar.text;
    if (inputStr.length == 0) {
        return;
    }
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];

    request.keywords            = inputStr;
    request.city                = @"北京";

    [self.searchAPI AMapPOIKeywordsSearch:request];
}

@end
