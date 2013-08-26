#import "SpecHelper.h"
#import "ApplicationConstants.h"
#import "CouchConstants.h"
#import "CouchDBHelper.h"
#import "RoomViewController.h"
#import "Building.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(RoomViewControllerSpec)

describe(@"RoomViewController", ^{
    __block CouchConstants *couchDBnames;
    __block ApplicationConstants *appCounstants;
    __block CouchDBHelper *cbHelper;
    __block Building *building;
    __block RoomViewController *roomViewController;
    __block NSString *sfName = @"SF2F";
    __block NSString *sfDescription = @"2 Folsom Gap Inc. HQ";
    __block NSString *sfCampus = @"SF";
    __block double sfLatitude = 37.791269;
    __block double sfLongitude = -122.390978;
    __block NSString *sfRoom1 = @"SF2F 2 North";
    __block NSString *sfRoom2 = @"SF2F Taco Truck";
    __block NSString *sfRoom3 = @"SF2F Foster Freeze";


    beforeEach(^{
        appCounstants = [[ApplicationConstants alloc] init];
        couchDBnames = [[CouchConstants alloc] init];
        building = [[Building alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:[couchDBnames databaseName]];
        roomViewController = [[RoomViewController alloc] init];
        [roomViewController setBuilding:building];
        
        // create locations db
        CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
        bool bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:[couchDBnames databaseName] withMethod:@"PUT"];
        expect(bOK).to(equal(true));
    });
    
    afterEach(^{
        CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
        bool bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:[couchDBnames databaseName] withMethod:@"DELETE"];
        expect(bOK).to(equal(true));
    });
    
    it(@"should know its building", ^{
        expect([roomViewController building]).to_not(be_nil);
    });
    
    it(@"should have a list of rooms for the building", ^{
        Building *sf2f = [[Building alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:[couchDBnames databaseName]];
        [sf2f setName:sfName];
        [sf2f setDescription:sfDescription];
        [sf2f setCampus:sfCampus];
        CLLocation *sf2fLocation = [[CLLocation alloc] initWithLatitude:sfLatitude longitude:sfLongitude];
        [sf2f setLocation:sf2fLocation];
        NSArray *sf2fRooms = [[NSArray alloc] initWithObjects:sfRoom1, sfRoom2, sfRoom3, nil];
        [sf2f setRooms:sf2fRooms];
        expect([sf2f create]).to(equal(true));
        [roomViewController setBuilding:sf2f];
        expect([[[roomViewController building] rooms] count]).to(equal(3));
    });
});

SPEC_END
