//
//  CouchConstants.h
//  Locus
//
//  Created by barry alexander on 4/23/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouchConstants : NSObject

- (id) init;
+ (CouchConstants*)sharedInstance;
+ (id)allocWithZone:(NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;
- (void)setupPreferences;

@property (atomic, strong) NSString *baseDatasourceURL;
@property (atomic, strong) NSString *databaseName;

@end
