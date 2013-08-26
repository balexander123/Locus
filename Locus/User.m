//
//  User.m
//  Locus
//
//  Created by barry alexander on 2/11/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import "User.h"
#import "Location.h"
#import "CouchDBHelper.h"

@implementation User

@synthesize name;
@synthesize campus;
@synthesize location;
@synthesize project;

-(bool)create {
    bool bOk = false;
    CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
    
    NSMutableString *data = [[NSMutableString alloc] init];
    
    [data appendString:@"{\"type\": \"User\", \"name\": \""];
    [data appendString:[self name]];
    [data appendString:@"\", \"campus\": \""];
    [data appendString:[self campus]];
    [data appendString:@"\", \"project\": \""];
    [data appendString:[self project]];
    [data appendString:@"\", \"loc\": ["];
    [data appendFormat:@"%f, %f]}",
     self.location.latitude,
     self.location.longitude];
    
    bOk = [cbHelper createData:self.datasource withDatabase:self.database withData:data andKey:[self name]];
    
    return bOk;
}

-(bool)retrieve:(NSString *)_id {
    return false;
}

@end
