//
//  ViewController.h
//  Locus
//
//  Created by barry alexander on 1/8/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CampusList;
@class CouchConstants;
@class ApplicationConstants;

@interface ViewController : UIViewController <UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *campusTableView;
@property (strong, readonly) ApplicationConstants *appConstants;
@property (strong, readonly) CouchConstants *couchConstants;
@property (strong, readonly) CampusList *campusList;

@end
