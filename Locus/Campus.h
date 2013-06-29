//
//  Campus.h
//  Locus
//
//  Created by barry alexander on 1/20/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "Datasource.h"
#import "CouchCRUD.h"

@class Location;

@interface Campus : Datasource <CouchCRUD>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *organization;
@property (nonatomic, strong) NSArray *buildings;

-(NSArray*)campusListForOrganization:(NSString*)organization;

@end
