#import "SpecHelper.h"
#import "AppDelegate.h"
#import "Location.h"
#import "FakeOrganization.h"
#import "Campus.h"
#import "User.h"
#import "OrganizationMock.h"
#import "CouchbaseHelper.h"
#import "LocusConstants.h"
#import "SpatialHelper.h"

static const double SIX_MILES = 6.0;

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(LocationSpec)

describe(@"User locations", ^{

    beforeEach(^{
    });
        
    Location *location = [[Location alloc] init];
    
    [location startTracking];
    [location currentPosition];
    
    // Create a user
    User *user = [[User alloc] init];
    user.location = location;
    
    // Get the app delegate
    AppDelegate *appDelegate = [[AppDelegate alloc] init];
    [appDelegate setupPreferences];
    
    // need a couchbase helper
    CouchbaseHelper *cbHelper = [[CouchbaseHelper alloc] init];
    
    // create the locations db
    it(@"should create a locations database", ^{
        bool bOK = [cbHelper databaseOperation:[appDelegate datasourceURL] withDatabase:@"locations" withMethod:@"PUT"];
        expect(bOK).to(equal(true));
    });
    
    // add some locations
    it(@"should create a location view function", ^{
        [cbHelper createData:[appDelegate datasourceURL] withDatabase:@"locations" withData:@"{\"loc\": [37.791269,-122.390978]}" andKey:@"SF2F"];
        [cbHelper createData:[appDelegate datasourceURL] withDatabase:@"locations" withData:@"{\"loc\": [37.789353,-122.388747]}" andKey:@"SF1H"];
        [cbHelper createData:[appDelegate datasourceURL] withDatabase:@"locations" withData:@"{\"loc\": [37.769494,-122.38688]}" andKey:@"SFMB"];
    
        // create the spatial M/R emit function block as a JSON string
        NSString *viewData = [[NSString alloc]initWithString:@"{\"spatial\":{\"points\" : \"function(doc) {\\n if (doc.loc) {\\n emit({\\n type: \\\"Point\\\", \\n coordinates: [doc.loc[0], doc.loc[1]]\\n}, [doc._id, doc.loc]);\\n}};\"}}"];
        bool bOK = [cbHelper createView:[appDelegate datasourceURL] withDatabase:@"locations" withData:viewData];
        expect(bOK).to(equal(true));
    });
    
    
    it(@"should know the location of the user", ^{
        [user.location latitude] should_not equal(NULL);
        [user.location longitude] should_not equal(NULL);
    });
    
    it(@"should know the nearest Gap campus of user", ^{        
        NSString *spatialPoints = [[NSString alloc] initWithFormat:spatialPointsFormat,user.location.latitude, user.location.longitude];
        
        // query the spatial view
        NSDictionary *spatialResponse = [cbHelper computeView:[appDelegate datasourceURL] withDatabase:@"locations" withParams:spatialPoints];
        
        // get the rows dictionary
        NSDictionary *rows = [spatialResponse objectForKey:@"rows"];
        expect(rows.count).to(equal(3));
    });
       
                                                               
    it(@"should be able to find the closest SF HQ locations based on the original Gap store", ^{
        CLLocationCoordinate2D firstGapLocation;
        
        // this is the starting location
        firstGapLocation.latitude = firstGapLatitude;
        firstGapLocation.longitude = firstGapLongitude;
        
        NSString *spatialPoints = [[NSString alloc] initWithFormat:spatialPointsFormat,
                                   firstGapLocation.latitude,
                                   firstGapLocation.longitude];
        
        // query the spatial view
        NSDictionary *spatialResponse = [cbHelper computeView:[appDelegate datasourceURL] withDatabase:@"locations" withParams:spatialPoints];
        
        // get the rows dictionary
        NSArray *rows = [spatialResponse objectForKey:@"rows"];
        expect(rows.count).to(equal(3));
        
        // get the campus at row[0]
        NSDictionary *closetCampus = [rows objectAtIndex:0];
        // get the 'geometry' element
        NSDictionary *campusGeometry = [closetCampus objectForKey:@"geometry"];
        NSArray *campusCoordinates = [campusGeometry objectForKey:@"coordinates"];
        double dCampusLat = [[(NSString *)[campusCoordinates objectAtIndex:0] description] doubleValue];
        double dCampusLon = [[(NSString *)[campusCoordinates objectAtIndex:1] description] doubleValue];
        NSLog(@"Campus coordinates, lat: %f long: %f\n",
              dCampusLat,
              dCampusLon);
        expect(dCampusLat).to(Equal<double>(37.769494));
        expect(dCampusLon).to(Equal<double>(-122.38688));
        // make sure the distance is correct
        SpatialHelper *spatialHelper = [[SpatialHelper alloc] init];

        DistanceUnits distanceUnits = MILES;
        
        CLLocationCoordinate2D closestLocation;
        closestLocation.latitude = dCampusLat;
        closestLocation.longitude = dCampusLon;
        
        double distance = [spatialHelper distanceBetween:firstGapLocation endingLocation:closestLocation usingUnits:distanceUnits];
        
        expect(distance).to(BeGreaterThan<double>(0.0));
        
        expect(abs(round(distance)-SIX_MILES)).to(BeLTE<double>(0.0000001));
        
        // clean up
        BOOL bOK = [cbHelper databaseOperation:[appDelegate datasourceURL] withDatabase:@"locations" withMethod:@"DELETE"];
        
        expect(bOK).to(equal(true));
    });
    
    it(@"should have a spatial view", ^{
        // Get the app delegate
        AppDelegate *appDelegate = [[AppDelegate alloc] init];
        [appDelegate setupPreferences];
        
        // use the couchdb helper to create a locations database and spatial view
        CouchbaseHelper *cbHelper = [[CouchbaseHelper alloc] init];
        
        // create the locations db
        bool bOK = [cbHelper databaseOperation:[appDelegate datasourceURL] withDatabase:@"locations" withMethod:@"PUT"];
        expect(bOK).to(equal(true));
        
        // create the spatial M/R emit function block as a JSON string
        NSString *viewData = [[NSString alloc]initWithString:@"{\"spatial\":{\"points\" : \"function(doc) {\\n if (doc.loc) {\\n emit({\\n type: \\\"Point\\\", \\n coordinates: [doc.loc[0], doc.loc[1]]\\n}, [doc._id, doc.loc]);\\n}};\"}}"];
        bOK = [cbHelper createView:[appDelegate datasourceURL] withDatabase:@"locations" withData:viewData];
        expect(bOK).to(equal(true));
        
        // clean up
        bOK = [cbHelper databaseOperation:[appDelegate datasourceURL] withDatabase:@"locations" withMethod:@"DELETE"];
        
        expect(bOK).to(equal(true));
    });
});

SPEC_END
