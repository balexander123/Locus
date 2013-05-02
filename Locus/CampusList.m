//
//  CampusList.m
//  Locus
//
//  Created by barry alexander on 1/20/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import "CampusList.h"
#import "CouchDBHelper.h"

@implementation CampusList

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

-(bool)addCampus:(Campus*)campus {
    bool bOk = false;
    CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
    
    NSMutableString *data = [[NSMutableString alloc] init];
    
    [data appendString:@"{\"type\": \"Campus\", \"description\": \""];
    [data appendString:[campus description]];
    [data appendString:@"\", \"organization\": \""];
    [data appendString:[campus organization]];
    [data appendString:@"\"}"];
    
    bOk = [cbHelper createData:datasource withDatabase:database withData:data andKey:[campus name]];
    
    return bOk;
}

-(NSDictionary*)campusListForOrganization:(NSString*)organization {
    CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
    
    NSDictionary *campusList = [cbHelper executeView:datasource withDatabase:database withView:@"/_design/campus/_view/by_organization" withParams:nil];
    
    return campusList;
}

@end
