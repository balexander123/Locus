//
//  CampusViewController.m
//  Locus
//
//  Created by barry alexander on 1/8/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import "CampusViewController.h"
#import "ApplicationConstants.h"
#import "CouchConstants.h"
#import "Campus.h"
#import "BuildingViewController.h"
#import "MBProgressHUD.h"


@interface CampusViewController ()

@end

@implementation CampusViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_campusRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    cell = [_campusTableView dequeueReusableCellWithIdentifier:@"CampusCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CampusCell"];
    }
    
    NSDictionary *element = [_campusRows objectAtIndex:[indexPath row]];
    
    NSDictionary *campus = [element valueForKey:@"key"];
    
    cell.textLabel.text = [campus valueForKey:@"description"];

    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    self.campusTableView.delegate = self;
    self.title = @"Campus";
    // Get couchdb constants
    _couchConstants = [[CouchConstants alloc] init];
    // Get app constants
    _appConstants = [[ApplicationConstants alloc] init];
    
    _campus = [[Campus alloc] initWithDatasource:[_couchConstants baseDatasourceURL] database:[_couchConstants databaseName]];
    
    [_campus campusListForOrganization:[_appConstants organization] withDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index: %d\n", indexPath.row);
    BuildingViewController *buildingViewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        buildingViewController = [[BuildingViewController alloc] initWithNibName:@"BuildingViewController_iPhone" bundle:nil];
    } else {
        buildingViewController = [[BuildingViewController alloc] initWithNibName:@"BuildingViewController_iPad" bundle:nil];
    }
    [buildingViewController setCampus:[self campusAtIndex:indexPath.row]];
    [self.navigationController pushViewController:buildingViewController animated:false];
}

-(Campus *)campusAtIndex:(NSUInteger) index {
    CouchConstants *couchDBnames = [[CouchConstants alloc] init];
    Campus *campus = [[Campus alloc] initWithDatasource:couchDBnames.baseDatasourceURL database:couchDBnames.databaseName];
    NSDictionary *campusDict = [_campusRows objectAtIndex:(index)];
    [campus retrieve:[campusDict objectForKey:@"id"]];
    
    return campus;
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it

    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSError *jsonParsingError = nil;
    NSDictionary *campusDict = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&jsonParsingError];
    _campusRows = [campusDict objectForKey:@"rows"];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [[self campusTableView] reloadData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

@end
