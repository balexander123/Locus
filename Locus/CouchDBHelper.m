//
//  CouchDBHelper.m
//  Locus
//
//  Created by barry alexander on 3/4/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import "CouchDBHelper.h"

@implementation CouchDBHelper

-(bool)databaseOperation:(NSString*)dbURL withDatabase:(NSString*)database withMethod:(NSString*)method {
    
    NSMutableString *dbOperation;
    dbOperation = [[NSMutableString alloc] initWithString:dbURL];
    [dbOperation appendString:@"/"];
    [dbOperation appendString:database];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dbOperation]];
    [request setHTTPMethod:method];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *jsonParsingError = nil;
    NSDictionary *DBResponse = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
    
    bool bOK = [DBResponse objectForKey:@"ok"];
    
    return bOK;
}

-(NSString*)uuid {
    NSString *UUID = [[NSUUID UUID] UUIDString];
    return UUID;
}

-(bool)createView:(NSString*)dbURL withDatabase:(NSString*)database withUrlSuffix:(NSString*)view withData:(NSString*)viewData {
    
    NSData *postData = [viewData dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableString *dbOperation;
    dbOperation = [[NSMutableString alloc] initWithString:dbURL];
    [dbOperation appendString:database];
    [dbOperation appendString:view];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dbOperation]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:[NSString stringWithFormat:@"%d", postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *jsonParsingError = nil;
    NSDictionary *DBResponse = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
    
    bool bOK = [DBResponse objectForKey:@"ok"];
    
    return bOK;
}

-(bool)createData:(NSString*)dbURL withDatabase:(NSString*)database withData:(NSString*)data andKey:(NSString*)key
{
    NSData *postData = [data dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableString *dbOperation;
    dbOperation = [[NSMutableString alloc] initWithString:dbURL];
    [dbOperation appendString:database];
    [dbOperation appendString:@"/"];
    [dbOperation appendString:key];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dbOperation]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:[NSString stringWithFormat:@"%d", postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *jsonParsingError = nil;
    NSDictionary *DBResponse = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
    
    bool bOK = [DBResponse objectForKey:@"ok"];
    
    return bOK;
}

-(NSDictionary *)execute:(NSString*)dbURL withDatabase:(NSString*)database withUrlSuffix:(NSString*)view withParams:(NSString*)viewParams {
    NSMutableString *dbOperation;
    dbOperation = [[NSMutableString alloc] initWithString:dbURL];
    [dbOperation appendString:database];
    [dbOperation appendString:view];
    if (viewParams != nil) {
        [dbOperation appendString:viewParams];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dbOperation]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *jsonParsingError = nil;
    NSDictionary *DBResponse = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
    
    return DBResponse;
}

@end
