//
//  Building.h
//  Locus
//
//  Created by barry alexander on 6/25/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "Datasource.h"
#import "CouchCRUD.h"

@class Location;

@interface Building : Datasource <CouchCRUD>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *campus;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSArray *rooms;

-(NSArray*)roomListForBuilding:(NSString*)building;

@end
