//
//  CouchbaseHelper.h
//  Locus
//
//  Created by barry alexander on 3/4/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouchbaseHelper : NSObject

-(bool)databaseOperation:(NSString*)dbURL withDatabase:(NSString*)database withMethod:(NSString*)method;
-(NSString*)uuid;
-(bool)createView:(NSString*)dbURL withDatabase:(NSString*)database withData:(NSString*)viewData;

@end
