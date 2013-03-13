//
//  OrganizationMock.h
//  Locus
//
//  Created by barry alexander on 2/12/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Campus;
@class Location;

@interface OrganizationMock : NSObject

-(Campus *) campusNear: (Location *)location;

@end
