//
//  Datasource.m
//  Locus
//
//  Created by barry alexander on 6/26/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import "Datasource.h"

@implementation Datasource

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

@end
