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

@interface CampusViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *campusTableView;
@property (strong, readonly) ApplicationConstants *appConstants;
@property (strong, readonly) CouchConstants *couchConstants;
@property (strong, readwrite) Campus *campus;
@property (strong, readonly) NSArray *campusRows;

-(Campus *)campusAtIndex:(NSUInteger) index;

@end
