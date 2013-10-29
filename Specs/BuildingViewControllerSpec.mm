#import "SpecHelper.h"
#import "ApplicationConstants.h"
#import "CouchConstants.h"
#import "CouchDBHelper.h"
#import "BuildingViewController.h"
#import "Campus.h"
#import "Building.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(BuildingViewControllerSpec)

describe(@"BuildingViewController", ^{
    __block BuildingViewController *buildingViewController;
    __block UITableView *buildingTableView;
    __block Campus *campus;
    __block CouchConstants *couchDBnames;
    __block ApplicationConstants *appCounstants;
    __block NSString *testDatabaseName=@"buildingviewcontrollerspec";
    __block NSString *sf_desc = @"San Francisco";
    __block NSString *sfmb = @"SFMB";
    __block NSString *sf1h = @"SF1H";
    __block NSString *sf2f = @"SF2F";
    __block NSString *sfName = @"SF2F";
    __block NSString *sfDescription = @"2 Folsom Gap Inc. HQ";
    __block NSString *sfCampus = @"SF";
    __block double sfLatitude = 37.791269;
    __block double sfLongitude = -122.390978;
    __block NSString *sfRoom1 = @"SF2F 2 North";
    __block NSString *sfRoom2 = @"SF2F Taco Truck";

    beforeEach(^{
        // Get couchdb constants
        couchDBnames = [[CouchConstants alloc] init];
        // Get app constants
        appCounstants = [[ApplicationConstants alloc] init];
        
        // create locations db
        CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
        bool bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:testDatabaseName withMethod:@"PUT"];
        expect(bOK).to(equal(true));
        
        campus = [[Campus alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:testDatabaseName];
        [campus setName:@"SF"];
        [campus setDescription:sf_desc];
        [campus setOrganization:[appCounstants organization]];
        NSArray* sfBuildings = [[NSArray alloc] initWithObjects:sfmb, sf1h, sf2f, nil];
        [campus setBuildings:sfBuildings];
        expect([campus create]).to(equal(true));
        buildingViewController = [[BuildingViewController alloc] initWithCampus:campus];
        [buildingViewController viewWillAppear:false];
        buildingTableView = [[UITableView alloc] init];
    });
    
    afterEach(^{
        CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
        bool bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:testDatabaseName withMethod:@"DELETE"];
        expect(bOK).to(equal(true));
    });
    
    it(@"should know the campus", ^{
        expect([buildingViewController campus]).to_not(be_nil);
    });
    
    it(@"should have a building list", ^{
        NSArray *sfBuildings = [[buildingViewController campus] buildings];
        expect([sfBuildings count]).to(equal(3));
        expect([sfBuildings objectAtIndex:0]).to(equal(sfmb));
        expect([sfBuildings objectAtIndex:1]).to(equal(sf1h));
        expect([sfBuildings objectAtIndex:2]).to(equal(sf2f));
    });
        
    it(@"should know the number of building to display", ^{
        expect([buildingViewController tableView:buildingTableView numberOfRowsInSection:0]).to(equal(3));
    });
    
    it(@"should be able to retrieve a building given a table view index", ^{
        Building *sf2f = [[Building alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:testDatabaseName];
        [sf2f setName:sfName];
        [sf2f setDescription:sfDescription];
        [sf2f setCampus:sfCampus];
        CLLocation *sf2fLocation = [[CLLocation alloc] initWithLatitude:sfLatitude longitude:sfLongitude];
        [sf2f setLocation:sf2fLocation];
        NSArray *sf2fRooms = [[NSArray alloc] initWithObjects:sfRoom1, sfRoom2, nil];
        [sf2f setRooms:sf2fRooms];
        expect([sf2f create]).to(equal(true));
        
        expect([buildingViewController tableView:buildingTableView numberOfRowsInSection:0]).to(equal(3));        
        
        Datasource *testDatasource = [[Datasource alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:testDatabaseName];
        Building *fetchedBuilding = [buildingViewController buildingAtIndex:2 datasource:testDatasource];
        expect([fetchedBuilding name]).to(equal(sfName));
        expect([fetchedBuilding description]).to(equal(sfDescription));
        expect([fetchedBuilding campus]).to(equal(sfCampus));

    });
});

SPEC_END
