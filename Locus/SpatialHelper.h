//
//  SpatialHelper.h
//  Locus
//
//  Created by barry alexander on 3/17/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

static const double milesLatitudePerDegree=57.3;
static const double milesLongitudePerDegree=69.1;

typedef enum distanceUnitsType
{
    MILES,
    KILOMETERS
} DistanceUnits;

@interface SpatialHelper : NSObject

-(double)degreesToRadians:(double)degrees;
-(double)distanceBetween:(CLLocationCoordinate2D)startLocation endingLocation:(CLLocationCoordinate2D)endLocation usingUnits:(DistanceUnits)distanceUnits;

@end
