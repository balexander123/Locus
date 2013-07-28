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
@class Campus;
@class Building;

@interface BuildingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) IBOutlet UITableView *buildingTableView;
@property (strong, readonly) ApplicationConstants *appConstants;
@property (strong, readonly) CouchConstants *couchConstants;
@property (strong, readwrite) Campus *campus;
@property (strong, readonly) NSArray *buildingRows;

-(id)initWithCampus:(Campus *)campus_;
-(Building *)buildingAtIndex:(NSUInteger) index;

@end
