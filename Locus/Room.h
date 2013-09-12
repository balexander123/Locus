//
//  Room.h
//  Locus
//
//  Created by barry alexander on 9/10/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Datasource.h"
#import "CouchCRUD.h"

@interface Room : Datasource <CouchCRUD>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *building;
@property (nonatomic, strong) NSArray *people;

@end
