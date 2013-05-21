//
//  ViewController.m
//  Locus
//
//  Created by barry alexander on 1/8/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import "ViewController.h"
#import "ApplicationConstants.h"
#import "CouchConstants.h"
#import "CampusList.h"


@interface ViewController ()

@end

@implementation ViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray *rows = [_campusList campusListForOrganization:[_appConstants organization]];
    
    NSLog(@"campus count: %d\n", rows.count);
    
    return [rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    cell = [_campusTableView dequeueReusableCellWithIdentifier:@"CampusCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CampusCell"];
    }
    
    NSArray *rows = [_campusList campusListForOrganization:[_appConstants organization]];
    
    NSDictionary *element = [rows objectAtIndex:[indexPath row]];
    
    NSDictionary *campus = [element valueForKey:@"key"];
    
    cell.textLabel.text = [campus valueForKey:@"description"];

    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    // Get couchdb constants
    _couchConstants = [[CouchConstants alloc] init];
    // Get app constants
    _appConstants = [[ApplicationConstants alloc] init];
    
    _campusList = [[CampusList alloc] initWithDatasource:[_couchConstants baseDatasourceURL] database:[_couchConstants databaseName]];

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

@end
