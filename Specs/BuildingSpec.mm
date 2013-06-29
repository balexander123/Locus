#import "SpecHelper.h"
#import "ApplicationConstants.h"
#import "CouchConstants.h"
#import "CouchDBHelper.h"
#import "Building.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(BuildingSpec)

describe(@"Building", ^{
    __block Building *building;
    __block CouchConstants *couchDBnames;
    __block ApplicationConstants *appCounstants;
    __block NSArray *buildingRows;

    beforeEach(^{
        // Get couchdb constants
        couchDBnames = [[CouchConstants alloc] init];
        // Get app constants
        appCounstants = [[ApplicationConstants alloc] init];
        
        building = [[Building alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:[couchDBnames databaseName]];
        
        // create locations db
        CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
        bool bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:[couchDBnames databaseName] withMethod:@"PUT"];
        expect(bOK).to(equal(true));
        
        // create some buildings
        
    });
    
    it(@"should know how to create a building", PENDING);
    
    it(@"should know how to retrieve a building", PENDING);
    
    it(@"should know how to find all buildings given a campus", PENDING);
    
    it(@"should know it's location", PENDING);
    
    it(@"should know it's campus", PENDING);
    
    it(@"should have a name", PENDING);
    
    it(@"should have a description", PENDING);
    
    it(@"should have a room list", PENDING);
});

SPEC_END
