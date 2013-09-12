//
//  CouchBaseHelperSync.m
//  Locus
//
//  Created by barry alexander on 9/8/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import "CouchDBHelperAsync.h"

@implementation CouchDBHelperAsync

-(bool)databaseOperation:(NSString*)dbURL withDatabase:(NSString*)database withMethod:(NSString*)method withDelegate:(id) respDelegate {
    
    NSMutableString *dbOperation;
    dbOperation = [[NSMutableString alloc] initWithString:dbURL];
    [dbOperation appendString:@"/"];
    [dbOperation appendString:database];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dbOperation]];
    [request setHTTPMethod:method];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:respDelegate];
    
    return (conn != nil);
}

-(NSString*)uuid {
    NSString *UUID = [[NSUUID UUID] UUIDString];
    return UUID;
}

-(bool)createView:(NSString*)dbURL withDatabase:(NSString*)database withUrlSuffix:(NSString*)view withData:(NSString*)viewData withDelegate:(id) respDelegate {
    
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
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:respDelegate];
    
    return (conn != nil);
}

-(bool)createData:(NSString*)dbURL withDatabase:(NSString*)database withData:(NSString*)data andKey:(NSString*)key withDelegate:(id) respDelegate {
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
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:respDelegate];
    
    return (conn != nil);
}



-(bool)execute:(NSString*)dbURL withDatabase:(NSString*)database withUrlSuffix:(NSString*)view withParams:(NSString*)viewParams withDelegate:(id) respDelegate {
    NSMutableString *dbOperation;
    dbOperation = [[NSMutableString alloc] initWithString:dbURL];
    [dbOperation appendString:database];
    [dbOperation appendString:view];
    
    if (viewParams != nil) {
        [dbOperation appendString:viewParams];
    }
    
    NSLog(@"%@",dbOperation);
    
    NSString *properlyEscapedURL = [dbOperation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",properlyEscapedURL);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:properlyEscapedURL]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:respDelegate];
    
    return (conn != nil);
}

@end
