//
//  MockCampus.m
//  Locus
//
//  Created by barry alexander on 6/24/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import "MockCampus.h"

@implementation MockCampus

-(NSArray*)campusListForOrganization:(NSString*)organization {

    NSArray *fakeRows = [[NSArray alloc] initWithObjects:@"SF", @"NY", @"LA", nil];
    
    return fakeRows;
}

@end
