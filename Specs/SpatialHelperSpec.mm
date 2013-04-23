#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "SpecHelper.h"
#import "LocusConstants.h"
#import "SpatialHelper.h"

static const double SIX_MILES = 6.0;
static const double TEN_KILOMETERS = 10.0;

CLLocationCoordinate2D firstGapLocation;
CLLocationCoordinate2D gapIncHeadquarters;

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(SpatialHelperSpec)

describe(@"SpatialHelper", ^{
    __block SpatialHelper *spatialHelper;

    beforeEach(^{
        spatialHelper = [[SpatialHelper alloc] init];
        
        // create a starting location
        firstGapLocation.latitude = firstGapLatitude;
        firstGapLocation.longitude = firstGapLongitude;
        
        // create an ending location
        gapIncHeadquarters.latitude = gapHQLatitude;
        gapIncHeadquarters.longitude = gapHQLongitude;
    });
    
    it(@"should compute the distance between locations in miles",^{
        DistanceUnits distanceUnits = MILES;
        
        double distance = [spatialHelper distanceBetween:firstGapLocation endingLocation:gapIncHeadquarters usingUnits:distanceUnits];
        
        expect(distance).to(BeGreaterThan<double>(0.0));
        
        expect(abs(round(distance)-SIX_MILES)).to(BeLTE<double>(0.0000001));
    });
    
    it(@"should compute the distance between locations in kilometers",^{
        DistanceUnits distanceUnits = KILOMETERS;
        
        double distance = [spatialHelper distanceBetween:firstGapLocation endingLocation:gapIncHeadquarters usingUnits:distanceUnits];
        
        expect(distance).to(BeGreaterThan<double>(0.0));
        
        expect(abs(round(distance)-TEN_KILOMETERS)).to(BeLTE<double>(0.0000001));
    });
    
    
});

SPEC_END
