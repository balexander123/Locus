//
//  User.h
//  Locus
//
//  Created by barry alexander on 2/11/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Campus;
@class Location;

#import "Datasource.h"
#import "CouchCRUD.h"

@interface User : Datasource <CouchCRUD> {

}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *campus;
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) NSString *project;

@end
