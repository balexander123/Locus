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

@synthesize datasource;
@synthesize database;

-(id)initWithDatasource:(NSString*)datasource_ database:(NSString*)database_ {
    self = [super init];
    if (self) {
        datasource = datasource_;
        database = database_;
    }
    return self;
}

-(bool)add:(NSObject*)object {
    bool bOk = false;
    CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
    
    NSMutableString *data = [[NSMutableString alloc] init];
    
    [data appendString:@"{\"type\": \"Campus\", \"description\": \""];
    [data appendString:[(Campus *)object description]];
    [data appendString:@"\", \"organization\": \""];
    [data appendString:[(Campus *)object organization]];
    [data appendString:@"\"}"];
    
    bOk = [cbHelper createData:datasource withDatabase:database withData:data andKey:[(Campus *)object name]];
    
    return bOk;
}

-(NSArray*)campusListForOrganization:(NSString*)organization {
    CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
    
    NSDictionary *campusDict = [cbHelper executeView:datasource withDatabase:database withView:@"/_design/campus/_view/by_organization" withParams:nil];
    
    // get the rows from the dictionary
    NSArray *rows = [campusDict objectForKey:@"rows"];
    
    return rows;
}


@end
