//
//  Organization.h
//  Locus
//
//  Created by barry alexander on 1/20/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Datasource.h"

@class Location;
@class CampusList;
@class Campus;

@protocol Organization<NSObject>

@required
-(id) init;
-(Campus *) campusNear: (Location *)location;

@end

@interface Organization : NSObject <Organization, Datasource> {
    
}

@property (nonatomic, strong) CampusList *campusList;

@end

