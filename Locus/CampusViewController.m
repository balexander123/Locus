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


@interface CampusViewController ()

@end

@implementation CampusViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    _campusRows = [_campus campusListForOrganization:[_appConstants organization]];
    
    return [_campusRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    cell = [_campusTableView dequeueReusableCellWithIdentifier:@"CampusCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CampusCell"];
    }
    
    //_campusRows = [_campus campusListForOrganization:[_appConstants organization]];
    
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

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index: %d\n", indexPath.row);
}

@end
