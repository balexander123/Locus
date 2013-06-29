//
//  BuildingViewController.h
//  Locus
//
//  Created by barry alexander on 6/7/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CouchConstants;
@class ApplicationConstants;

@interface BuildingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIViewController *buildingTableView;
@property (strong, readonly) ApplicationConstants *appConstants;
@property (strong, readonly) CouchConstants *couchConstants;

@end
