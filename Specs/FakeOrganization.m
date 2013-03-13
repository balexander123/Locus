//
//  FakeOrganization.m
//  Locus
//
//  Created by barry alexander on 2/15/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import "FakeOrganization.h"
#import "Campus.h"
#import "Location.h"

@implementation FakeOrganization

-(Campus *) campusNear: (Location *)location {
    Campus *campus = [[Campus alloc] init];
    
    Location *fakelocation = [[Location alloc] init];
    fakelocation.latitude = firstGapLatitude;
    fakelocation.longitude = firstGapLongitude;
    campus.location = fakelocation;
    
    return campus;
}

@end
