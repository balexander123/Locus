//
//  SpatialHelper.m
//  Locus
//
//  Created by barry alexander on 3/17/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#include <math.h>

#import "SpatialHelper.h"

@implementation SpatialHelper

-(double)degreesToRadians:(double)degrees {
    return degrees * (M_PI/180.00);
}

-(double)distanceBetween:(CLLocationCoordinate2D)startLocation endingLocation:(CLLocationCoordinate2D)endLocation usingUnits:(DistanceUnits)distanceUnits {
    
    double radius;
    if (distanceUnits == MILES)
        radius = 3961.3; // statute miles
    else
        radius = 6378.1; // kilometers
    
    double dLat = [self degreesToRadians:endLocation.latitude-startLocation.latitude];
    double dLon = [self degreesToRadians:endLocation.longitude-startLocation.longitude];
    double a = sin(dLat/2) * sin(dLat/2) + cos([self degreesToRadians:startLocation.latitude]) * cos(endLocation.latitude) * sin(dLon/2) * sin(dLon/2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    double distance = radius * c;
    
    return distance;
}

@end
