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

-(bool)create:(NSObject*)object {
    bool bOk = false;
    CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
    
    NSMutableString *data = [[NSMutableString alloc] init];
    
    [data appendString:@"{\"type\": \"Campus\", \"description\": \""];
    [data appendString:[(Campus *)object description]];
    [data appendString:@"\", \"organization\": \""];
    [data appendString:[(Campus *)object organization]];
    [data appendString:@"\""];
    
    // add the buildings
    if ([(Campus *)object buildings].count > 0) {
        [data appendString:@", \"buildings\": ["];
        for (NSString* building in [(Campus *)object buildings]) {
            [data appendFormat:@"\"%@\", ",building];
        };
        [data appendString:@"]"];
        NSRange range; range.location = 0; range.length = data.length;
        [data replaceOccurrencesOfString:@", ]" withString:@"]" options:NSLiteralSearch range:range];
    }
    [data appendString:@"}"];

    
    bOk = [cbHelper createData:self.datasource withDatabase:self.database withData:data andKey:[(Campus *)object name]];
    
    return bOk;
}

-(NSArray*)retrieve:(NSDictionary*)qualifiers {
    CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
    
    NSArray *response = [[NSArray alloc] init];
    // iterate over qualifiers to build
    
    //NSDictionary *response = [[NSDictionary alloc] init];
    //response = [cbHelper execute:<#(NSString *)#> withDatabase:<#(NSString *)#> withView:<#(NSString *)#> withParams:nil]
    return response;
}

-(NSArray*)campusListForOrganization:(NSString*)organization {
    CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
    
    NSDictionary *campusDict = [cbHelper execute:self.datasource withDatabase:self.database withView:@"/_design/campus/_view/by_organization" withParams:nil];
    
    // get the rows from the dictionary
    NSArray *rows = [campusDict objectForKey:@"rows"];
    
    return rows;
}


@end
