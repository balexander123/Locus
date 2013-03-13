//
//  Organization.m
//  Locus
//
//  Created by barry alexander on 1/20/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import "Organization.h"
#import "Campus.h"

@implementation Organization

@synthesize baseDatasourceURL;

-(id)init {
    self = [super init];
    if (self) {
        // get data source based on environment
        // dev: http://127.0.0.1:5984
        // baseDatasourceURL = @"http://127.0.0.1:5984";
        // stage: TBD
        // production: TBD
    }
    return self;
}

-(Campus *) campusNear: (Location *)location {
    // using the datasource
    // get the list of nearest campus to location
    
    //Campus *campus = [[Campus alloc] init];
    Campus *campus = nil;
    
    return campus;
}

@end
