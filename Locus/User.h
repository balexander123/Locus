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

@interface User : NSObject {

}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Campus *campus;
@property (nonatomic, strong) Location *location;

@end
