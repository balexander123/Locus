//
//  Location.m
//  Locus
//
//  Created by barry alexander on 1/12/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import "Location.h"

@implementation Location

@synthesize locationManager;
@synthesize latitude;
@synthesize longitude;

-(id)init {
    self = [super init];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        if (locationManager) {
            locationManager.delegate = self;
            locationManager.distanceFilter = kCLDistanceFilterNone;
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        }
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
    
    self.latitude = location.coordinate.latitude;
    self.longitude = location.coordinate.longitude;
}

- (void)startTracking {
    if (locationManager) {
        [locationManager startMonitoringSignificantLocationChanges];
    }
}

- (void)currentPosition {
    if (locationManager) {
        CLLocation *currentLocation = [locationManager location];
    
        latitude = currentLocation.coordinate.latitude;
        longitude = currentLocation.coordinate.longitude;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Unable to determine location: %@", error.localizedDescription);
}

@end
