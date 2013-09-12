//
//  RoomViewController.h
//  Locus
//
//  Created by barry alexander on 7/27/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Building;
@class ApplicationConstants;
@class CouchConstants;

@interface RoomViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,NSURLConnectionDelegate>

@property (strong, nonatomic) IBOutlet UITableView *roomTableView;

@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, readwrite) Building *building;
@property (strong, readwrite) NSString *buildingId;
@property (strong, readonly) ApplicationConstants *appConstants;
@property (strong, readonly) CouchConstants *couchConstants;
@property (strong, readonly) NSArray *roomRows;


@end
