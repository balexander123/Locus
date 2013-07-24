//
//  Building.m
//  Locus
//
//  Created by barry alexander on 6/25/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import "Building.h"
#import "CouchDBHelper.h"

@implementation Building

-(bool)create:(NSObject*)object {
    bool bOk = false;
    CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
    
    NSMutableString *data = [[NSMutableString alloc] init];
    
    [data appendString:@"{\"type\": \"Building\", \"description\": \""];
    [data appendString:[(Building *)object description]];
    [data appendString:@"\", \"campus\": \""];
    [data appendString:[(Building *)object campus]];
    [data appendString:@"\""];
    
    // add the rooms
    if ([(Building *)object rooms].count > 0) {
        [data appendString:@", \"rooms\": ["];
        for (NSString* building in [(Building *)object rooms]) {
            [data appendFormat:@"\"%@\", ",building];
        };
        [data appendString:@"]"];
        NSRange range; range.location = 0; range.length = data.length;
        [data replaceOccurrencesOfString:@", ]" withString:@"]" options:NSLiteralSearch range:range];
    }
    [data appendString:@", \"loc\": ["];
    Building *building = (Building *)object;
    [data appendFormat:@"%f, %f]}",
        building.location.coordinate.latitude,
        building.location.coordinate.longitude];
    
    bOk = [cbHelper createData:self.datasource withDatabase:self.database withData:data andKey:[(Building *)object name]];
    
    return bOk;
}

-(NSArray*)retrieve:(NSDictionary*)qualifiers {
    CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
    
    // iterate over qualifiers to build query string
    // if key = _id, just pass as id parameter
    // otherwise build view parameter
    
    NSDictionary *response = [cbHelper execute:self.datasource withDatabase:self.database withUrlSuffix:nil withParams:nil];
    
    // get the rows from the dictionary
    NSArray *rows = [response objectForKey:@"rows"];
    
    return rows;
}

-(NSArray*)roomListForBuilding:(NSString*)building {
    CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
    
    NSDictionary *response = [cbHelper execute:self.datasource withDatabase:self.database withUrlSuffix:building withParams:nil];
    
    // get the rows from the dictionary
    NSArray *rows = [response objectForKey:@"rooms"];
    
    return rows;
}

@end
