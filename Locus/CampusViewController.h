//
//  CampusViewController.h
//  Locus
//
//  Created by barry alexander on 1/8/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Campus;
@class CouchConstants;
@class ApplicationConstants;
@class Datasource;

@interface CampusViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate>

@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) IBOutlet UITableView *campusTableView;
@property (strong, readonly) ApplicationConstants *appConstants;
@property (strong, readonly) CouchConstants *couchConstants;
@property (strong, readwrite) Campus *campus;
@property (strong, readwrite) NSArray *campusRows;


-(Campus *)campusAtIndex:(NSUInteger) index datasource:(Datasource*)datasource;

@end
