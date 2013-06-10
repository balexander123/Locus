//
//  CouchCRUD.h
//  Locus
//
//  Created by barry alexander on 5/23/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CouchCRUD <NSObject>

-(id)initWithDatasource:(NSString*)datasource_ database:(NSString*)database_;
-(bool)add:(NSObject*)object;
-(NSArray*)read:(NSDictionary*)qualifiers;

@property (nonatomic, strong) NSString *datasource;
@property (nonatomic, strong) NSString *database;

@end
