//
//  Datasource.h
//  Locus
//
//  Created by barry alexander on 2/11/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Datasource : NSObject

-(id)initWithDatasource:(NSString*)datasource_ database:(NSString*)database_;

@property (nonatomic, readonly) NSString *datasource;
@property (nonatomic, readonly) NSString *database;


@end

