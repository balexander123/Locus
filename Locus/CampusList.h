//
//  CampusList.h
//  Locus
//
//  Created by barry alexander on 1/20/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Campus.h"

@interface CampusList : NSObject

-(id)initWithDatasource:(NSString*)datasource_ database:(NSString*)database_;
-(bool)addCampus:(Campus*)campus;
-(NSArray*)campusListForOrganization:(NSString*)organization;

@property (nonatomic, strong) NSString *datasource;
@property (nonatomic, strong) NSString *database;

@end
