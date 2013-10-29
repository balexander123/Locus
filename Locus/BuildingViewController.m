//
//  BuildingViewController.m
//  Locus
//
//  Created by barry alexander on 6/7/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import "BuildingViewController.h"
#import "CampusViewController.h"
#import "RoomViewController.h"
#import "CouchConstants.h"
#import "ApplicationConstants.h"
#import "Campus.h"
#import "Building.h"


@interface BuildingViewController ()

@end

@implementation BuildingViewController

@synthesize campus;

-(id)initWithCampus:(Campus *)campus_ {
    self = [super init];
    if (self) {
        campus = campus_;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.buildingTableView.delegate = self;
    self.title = @"Buildings";
    // Get couchdb constants
    _couchConstants = [[CouchConstants alloc] init];
    // Get app constants
    _appConstants = [[ApplicationConstants alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _buildingRows = [[self campus] buildings];
    
    return [_buildingRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    cell = [_buildingTableView dequeueReusableCellWithIdentifier:@"BuildingCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BuildingCell"];
    }
    
    cell.textLabel.text = [_buildingRows objectAtIndex:[indexPath row]];
    
    return cell;

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index: %d\n", indexPath.row);
    RoomViewController *roomViewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        roomViewController = [[RoomViewController alloc] initWithNibName:@"RoomViewController_iPhone" bundle:nil];
    } else {
        roomViewController = [[RoomViewController alloc] initWithNibName:@"RoomViewController_iPad" bundle:nil];
    }
    [roomViewController setBuildingId:[_buildingRows objectAtIndex:(indexPath.row)]];
    [self.navigationController pushViewController:roomViewController animated:YES];
}

-(Building *)buildingAtIndex:(NSUInteger) index datasource:(Datasource*)datasource
{
    Building *building = [[Building alloc] initWithDatasource:datasource.datasource database:datasource.database];
    [building retrieve:[_buildingRows objectAtIndex:(index)]];
    
    return building;
}

@end
