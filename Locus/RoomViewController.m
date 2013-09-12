//
//  RoomViewController.m
//  Locus
//
//  Created by barry alexander on 7/27/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import "RoomViewController.h"
#import "CouchConstants.h"
#import "CouchDBHelperAsync.h"
#import "ApplicationConstants.h"
#import "Building.h"
#import "MBProgressHUD.h"


@interface RoomViewController ()

@end

@implementation RoomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.roomTableView.delegate = self;
    self.title = @"Rooms";
    CouchConstants *couchDBnames = [[CouchConstants alloc] init];
    Building *building = [[Building alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:[couchDBnames databaseName]];
    [building roomListForBuilding:[self buildingId] withDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_roomRows == nil)
        return 0;
    else
        return [_roomRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    cell = [_roomTableView dequeueReusableCellWithIdentifier:@"RoomCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RoomCell"];
    }
    
    NSDictionary *element = [_roomRows objectAtIndex:[indexPath row]];
    
    NSDictionary *room = [element valueForKey:@"value"];
    
    cell.textLabel.text = [room valueForKey:@"description"];
    
    return cell;
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
    NSDictionary *roomDict = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&jsonParsingError];
    _roomRows = [roomDict objectForKey:@"rows"];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [[self roomTableView] reloadData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"error connecting...");
}


@end
