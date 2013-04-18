//
//  CampusList.h
//  Locus
//
//  Created by barry alexander on 1/20/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Organization.h"

@interface CampusList : NSObject

-(NSDictionary*)campusListForOrganization:(Organization*)organization;

@end
