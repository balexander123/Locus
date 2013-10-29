#import "SpecHelper.h"
#import "AppDelegate.h"
#import "Location.h"
#import "Campus.h"
#import "User.h"
#import "ApplicationConstants.h"
#import "CouchConstants.h"
#import "CouchDBHelper.h"
#import "LocusConstants.h"
#import "SpatialHelper.h"

static const double SIX_MILES = 6.0;

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(LocationSpec)

describe(@"User locations", ^{
    
    __block CouchConstants *couchDBnames;
    __block ApplicationConstants *appCounstants;
    __block CouchDBHelper *cbHelper;
    __block NSString *testDatabaseName=@"locationspec";

    beforeEach(^{
        // Get couchdb constants
        couchDBnames = [[CouchConstants alloc] init];
        // Get app constants
        appCounstants = [[ApplicationConstants alloc] init];
        
        // create locations db
        cbHelper = [[CouchDBHelper alloc] init];
        bool bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:testDatabaseName withMethod:@"PUT"];
        expect(bOK).to(equal(true));
        
        // add some locations
        [cbHelper createData:[couchDBnames baseDatasourceURL] withDatabase:testDatabaseName withData:@"{\"loc\": [37.791269,-122.390978]}" andKey:@"SF2F"];
        [cbHelper createData:[couchDBnames baseDatasourceURL] withDatabase:testDatabaseName withData:@"{\"loc\": [37.789353,-122.388747]}" andKey:@"SF1H"];
        [cbHelper createData:[couchDBnames baseDatasourceURL] withDatabase:testDatabaseName withData:@"{\"loc\": [37.769494,-122.38688]}" andKey:@"SFMB"];
        
        // create the spatial M/R emit function block as a JSON string
        NSString *viewData = [[NSString alloc]initWithString:@"{\"spatial\":{\"points\" : \"function(doc) {\\n if (doc.loc) {\\n emit({\\n type: \\\"Point\\\", \\n coordinates: [doc.loc[0], doc.loc[1]]\\n}, [doc._id, doc.loc]);\\n}};\"}}"];
        bOK = [cbHelper createView:[couchDBnames baseDatasourceURL] withDatabase:testDatabaseName withUrlSuffix:@"/_design/main" withData:viewData];
        expect(bOK).to(equal(true));
    });
    
    afterEach(^{
        // clean up
        BOOL bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:testDatabaseName withMethod:@"DELETE"];
        
        expect(bOK).to(equal(true));
    });
    
    it(@"should know the location of the user", ^{
        Location *location = [[Location alloc] init];
        
        [location startTracking];
        [location currentPosition];
        
        // Create a user
        User *user = [[User alloc] init];
        user.location = location;
        
        [user.location latitude] should_not equal(NULL);
        [user.location longitude] should_not equal(NULL);
    });
    
    it(@"should know the nearest Gap campus of user", ^{
        Location *location = [[Location alloc] init];
        
        [location startTracking];
        [location currentPosition];
        
        // Create a user
        User *user = [[User alloc] init];
        user.location = location;
        
        NSString *spatialPoints = [[NSString alloc] initWithFormat:spatialPointsFormat,user.location.latitude, user.location.longitude];
        
        // query the spatial view
        NSDictionary *spatialResponse = [cbHelper execute:[couchDBnames baseDatasourceURL] withDatabase:testDatabaseName withUrlSuffix:@"/_design/main/" withParams:spatialPoints];
        
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
        NSDictionary *spatialResponse = [cbHelper execute:[couchDBnames baseDatasourceURL] withDatabase:testDatabaseName withUrlSuffix:@"/_design/main/" withParams:spatialPoints];
        
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
    });
    
    it(@"should have a spatial view", ^{        
        // create the locations db
        bool bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:testDatabaseName withMethod:@"PUT"];
        expect(bOK).to(equal(true));
        
        // create the spatial M/R emit function block as a JSON string
        NSString *viewData = [[NSString alloc]initWithString:@"{\"spatial\":{\"points\" : \"function(doc) {\\n if (doc.loc) {\\n emit({\\n type: \\\"Point\\\", \\n coordinates: [doc.loc[0], doc.loc[1]]\\n}, [doc._id, doc.loc]);\\n}};\"}}"];
        bOK = [cbHelper createView:[couchDBnames baseDatasourceURL] withDatabase:testDatabaseName withUrlSuffix:@"/_design/main" withData:viewData];
        expect(bOK).to(equal(true));
    });
});

SPEC_END
