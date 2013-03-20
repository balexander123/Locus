//
//  Location.h
//  Locus
//
//  Created by barry alexander on 1/12/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "LocusConstants.h"

@interface Location : NSObject <CLLocationManagerDelegate> {

}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;

-(id) init;
-(void) startTracking;
-(void) currentPosition;

@end
