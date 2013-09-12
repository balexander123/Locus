//
//  Building.m
//  Locus
//
//  Created by barry alexander on 6/25/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import "Building.h"
#import "CouchDBHelper.h"
#import "CouchDBHelperAsync.h"

@implementation Building

-(bool)create {
    bool bOk = false;
    CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
    
    NSMutableString *data = [[NSMutableString alloc] init];
    
    [data appendString:@"{\"type\": \"Building\", \"description\": \""];
    [data appendString:[self description]];
    [data appendString:@"\", \"campus\": \""];
    [data appendString:[self campus]];
    [data appendString:@"\""];
    
    // add the rooms
    if ([self rooms].count > 0) {
        [data appendString:@", \"rooms\": ["];
        for (NSString* building in [self rooms]) {
            [data appendFormat:@"\"%@\", ",building];
        };
        [data appendString:@"]"];
        NSRange range; range.location = 0; range.length = data.length;
        [data replaceOccurrencesOfString:@", ]" withString:@"]" options:NSLiteralSearch range:range];
    }
    [data appendString:@", \"loc\": ["];
    [data appendFormat:@"%f, %f]}",
        self.location.coordinate.latitude,
        self.location.coordinate.longitude];
    
    bOk = [cbHelper createData:self.datasource withDatabase:self.database withData:data andKey:[self name]];
    
    return bOk;
}

-(bool)retrieve:(NSString*)_id {
    CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
    
    NSDictionary *buildingDict = [[NSDictionary alloc] init];
    NSMutableString *buildingLookup = [[NSMutableString alloc] initWithString:@"/"];
    [buildingLookup appendString:_id];
    
    buildingDict = [cbHelper execute:self.datasource withDatabase:self.database withUrlSuffix:buildingLookup withParams:nil];
    
    if ([[buildingDict objectForKey:@"error"] isEqual: @"not_found"])
        return false;
    
    // get the campus attributes from the dictionary
    [self setName:[buildingDict objectForKey:@"_id"]];
    [self setDescription:[buildingDict objectForKey:@"description"]];
    [self setCampus:[buildingDict objectForKey:@"campus"]];
    [self setLocation:[buildingDict objectForKey:@"location"]];
    [self setRooms:[buildingDict objectForKey:@"rooms"]];
    
    return true;
}

-(NSArray*)roomListForBuilding:(NSString*)building {
    CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
    
    NSDictionary *response = [cbHelper execute:self.datasource withDatabase:self.database withUrlSuffix:building withParams:nil];
    
    // get the rows from the dictionary
    NSArray *rows = [response objectForKey:@"rooms"];
    
    return rows;
}


-(bool)roomListForBuilding:(NSString*)building withDelegate:(id) respDelegate {
    CouchDBHelperAsync *cbHelper = [[CouchDBHelperAsync alloc] init];
    
    NSMutableString *buildingParam = [[NSMutableString alloc] initWithString:@"?key=\""];
    [buildingParam appendString:building];
    [buildingParam appendString:@"\""];
    
    return [cbHelper execute:self.datasource withDatabase:self.database withUrlSuffix:@"/_design/rooms/_view/by_building" withParams:buildingParam withDelegate:respDelegate];
}

@end
