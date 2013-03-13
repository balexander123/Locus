//
//  OrganizationMock.m
//  Locus
//
//  Created by barry alexander on 2/12/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import "OrganizationMock.h"
#import "Campus.h"

@implementation OrganizationMock

-(Campus *) campusNear: (Location *)location {
    //NSData *data = [NSData dataWithContentsOfBundleFile:@"sampleCampus.json"];
    Campus *campus = [[Campus alloc] init];
    return campus;
}

@end
