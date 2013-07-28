//
//  RoomViewController.m
//  Locus
//
//  Created by barry alexander on 7/27/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import "RoomViewController.h"
#import "CouchConstants.h"
#import "ApplicationConstants.h"
#import "Building.h"


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
    // Get couchdb constants
    _couchConstants = [[CouchConstants alloc] init];
    // Get app constants
    _appConstants = [[ApplicationConstants alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _roomRows = [_building rooms];
    
    return [_roomRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    cell = [_roomTableView dequeueReusableCellWithIdentifier:@"RoomCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RoomCell"];
    }
    
    cell.textLabel.text = [_roomRows objectAtIndex:[indexPath row]];
    
    return cell;
}

@end
