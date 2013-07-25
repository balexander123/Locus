//
//  Campus.m
//  Locus
//
//  Created by barry alexander on 1/20/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import "Campus.h"
#import "CouchDBHelper.h"

@implementation Campus

@synthesize name;
@synthesize description;
@synthesize organization;
@synthesize buildings;

-(bool)create {
    bool bOk = false;
    CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
    
    NSMutableString *data = [[NSMutableString alloc] init];
    
    [data appendString:@"{\"type\": \"Campus\", \"description\": \""];
    [data appendString:[self description]];
    [data appendString:@"\", \"organization\": \""];
    [data appendString:[self organization]];
    [data appendString:@"\""];
    
    // add the buildings
    if ([self buildings].count > 0) {
        [data appendString:@", \"buildings\": ["];
        for (NSString* building in [self buildings]) {
            [data appendFormat:@"\"%@\", ",building];
        };
        [data appendString:@"]"];
        NSRange range; range.location = 0; range.length = data.length;
        [data replaceOccurrencesOfString:@", ]" withString:@"]" options:NSLiteralSearch range:range];
    }
    [data appendString:@"}"];

    
    bOk = [cbHelper createData:self.datasource withDatabase:self.database withData:data andKey:[self name]];
    
    return bOk;
}

-(bool)retrieve:(NSString *)_id {
    CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
    
    NSDictionary *campusDict = [[NSDictionary alloc] init];
    NSMutableString *campusLookup = [[NSMutableString alloc] initWithString:@"/"];
    [campusLookup appendString:_id];

    campusDict = [cbHelper execute:self.datasource withDatabase:self.database withUrlSuffix:campusLookup withParams:nil];
    
    if ([[campusDict objectForKey:@"error"] isEqual: @"not_found"])
        return false;
    
    // get the campus attributes from the dictionary
    [self setName:[campusDict objectForKey:@"_id"]];
    [self setDescription:[campusDict objectForKey:@"description"]];
    [self setOrganization:[campusDict objectForKey:@"organization"]];
    [self setBuildings:[campusDict objectForKey:@"buildings"]];
    
    return true;
}

-(NSArray*)campusListForOrganization:(NSString*)organization {
    CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
    
    NSDictionary *campusDict = [cbHelper execute:self.datasource withDatabase:self.database withUrlSuffix:@"/_design/campus/_view/by_organization" withParams:nil];
    
    // get the rows from the dictionary
    NSArray *rows = [campusDict objectForKey:@"rows"];
    
    return rows;
}


@end
