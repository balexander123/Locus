//
//  CouchBaseHelperSync.h
//  Locus
//
//  Created by barry alexander on 9/8/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouchDBHelperAsync : NSObject

-(bool)databaseOperation:(NSString*)dbURL withDatabase:(NSString*)database withMethod:(NSString*)method withDelegate:(id) respDelegate;
-(NSString*)uuid;
-(bool)createView:(NSString*)dbURL withDatabase:(NSString*)database withUrlSuffix:(NSString*)view withData:(NSString*)viewData withDelegate:(id) respDelegate;
-(bool)createData:(NSString*)dbURL withDatabase:(NSString*)database withData:(NSString*)data andKey:(NSString*)key withDelegate:(id) respDelegate;
-(bool)execute:(NSString*)dbURL withDatabase:(NSString*)database withUrlSuffix:(NSString*)view withParams:(NSString*)viewParams withDelegate:(id) respDelegate;

@end
