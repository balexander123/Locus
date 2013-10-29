#import "SpecHelper.h"
#import "ApplicationConstants.h"
#import "CouchConstants.h"
#import "CouchDBHelper.h"
#import "Campus.h"
#import "Building.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(BuildingSpec)

describe(@"Building", ^{
    __block Building *building;
    __block CouchConstants *couchDBnames;
    __block ApplicationConstants *appCounstants;
    __block NSString *testDatabaseName=@"buildingspec";
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
        
        building = [[Building alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:testDatabaseName];
        
        // create locations db
        CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
        bool bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:testDatabaseName withMethod:@"PUT"];
        expect(bOK).to(equal(true));
    });
    
    afterEach(^{
        CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
        bool bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:testDatabaseName withMethod:@"DELETE"];
        expect(bOK).to(equal(true));
    });
    
    it(@"should know how to create a building", ^{        
        Building *sf2f = [[Building alloc] init];
        [sf2f setName:sfName];
        [sf2f setDescription:sfDescription];
        [sf2f setCampus:sfCampus];
        CLLocation *sf2fLocation = [[CLLocation alloc] initWithLatitude:sfLatitude longitude:sfLongitude];
        [sf2f setLocation:sf2fLocation];
        NSArray *sf2fRooms = [[NSArray alloc] initWithObjects:sfRoom1, sfRoom2, nil];
        [sf2f setRooms:sf2fRooms];
        
        expect(sf2f.name).to(equal(sfName));
        expect(sf2f.description).to(equal(sfDescription));
        expect(sf2f.campus).to(equal(sfCampus));
        expect(sf2f.location.coordinate.latitude).to(equal(sfLatitude));
        expect(sf2f.location.coordinate.longitude).to(equal(sfLongitude));
        NSArray *rooms = [sf2f rooms];
        expect([rooms objectAtIndex:0]).to(equal(sfRoom1));
        expect([rooms objectAtIndex:1]).to(equal(sfRoom2));
    });
    
    it(@"should know how to retrieve a building", ^{
        Building *sf2f = [[Building alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:testDatabaseName];
        [sf2f setName:sfName];
        [sf2f setDescription:sfDescription];
        [sf2f setCampus:sfCampus];
        CLLocation *sf2fLocation = [[CLLocation alloc] initWithLatitude:sfLatitude longitude:sfLongitude];
        [sf2f setLocation:sf2fLocation];
        NSArray *sf2fRooms = [[NSArray alloc] initWithObjects:sfRoom1, sfRoom2, nil];
        [sf2f setRooms:sf2fRooms];
        expect([sf2f create]).to(equal(true));
        
        CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
        
        NSDictionary *buildingDict = [cbHelper execute:[couchDBnames baseDatasourceURL] withDatabase:testDatabaseName withUrlSuffix:@"/SF2F" withParams:nil];
        
        // get the rows from the dictionary
        NSString *building_desc = [buildingDict objectForKey:@"description"];
        
        expect(building_desc).to(equal(sfDescription));
        
    });
    
    it(@"should know how to find all buildings given a campus", ^{
        // add some campus'
        Campus *sf_campus = [[Campus alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:testDatabaseName];
        [sf_campus setName:@"SF"];
        [sf_campus setDescription:@"San Francisco"];
        [sf_campus setOrganization:[appCounstants organization]];
        NSArray *sfBuildings = [[NSArray alloc] initWithObjects:@"SFMB", @"SF1H", @"SF2F", nil];
        [sf_campus setBuildings:sfBuildings];
        expect([sf_campus create]).to(equal(true));
        
        Campus *oh_campus = [[Campus alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:testDatabaseName];
        [oh_campus setName:@"OH"];
        [oh_campus setDescription:@"Ohio"];
        [oh_campus setOrganization:[appCounstants organization]];
        NSArray *ohBuildings = [[NSArray alloc] initWithObjects:@"OFC", @"OCC", nil];
        [oh_campus setBuildings:ohBuildings];
        expect([oh_campus create]).to(equal(true));
        
        Campus *petaluma = [[Campus alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:testDatabaseName];
        [petaluma setName:@"Petaluma"];
        [petaluma setDescription:@"Petaluma Campus"];
        [petaluma setOrganization:[appCounstants organization]];
        NSArray *petBuildings = [[NSArray alloc] initWithObjects:@"Athleta", nil];
        [petaluma setBuildings:petBuildings];
        expect([petaluma create]).to(equal(true));
        
        // create some buildings
        Building *sfmb = [[Building alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:testDatabaseName];
        [sfmb setName:@"SFMB"];
        [sfmb setDescription:@"Mission Bay Building 1"];
        [sfmb setCampus:@"SF"];
        CLLocation *sfmbLocation = [[CLLocation alloc] initWithLatitude:37.769494 longitude:-122.38688];
        [sfmb setLocation:sfmbLocation];
        NSArray *sfmbRooms = [[NSArray alloc] initWithObjects:@"SFMB Conf room1", @"SFMBConf room 2", nil];
        [sfmb setRooms:sfmbRooms];
        expect([sfmb create]).to(equal(true));
        
        Building *sf2f = [[Building alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:testDatabaseName];
        [sf2f setName:@"SF2F"];
        [sf2f setDescription:@"2 Folsom Gap Inc. HQ"];
        [sf2f setCampus:@"SF"];
        CLLocation *sf2fLocation = [[CLLocation alloc] initWithLatitude:37.791269 longitude:-122.390978];
        [sf2f setLocation:sf2fLocation];
        NSArray *sf2fRooms = [[NSArray alloc] initWithObjects:@"SF2F 2 North", @"SF2F Taco Truck", nil];
        [sf2f setRooms:sf2fRooms];
        expect([sf2f create]).to(equal(true));
        
        Building *sf1h = [[Building alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:testDatabaseName];
        [sf1h setName:@"SF1H"];
        [sf1h setDescription:@"1 Harrison"];
        [sf1h setCampus:@"SF"];
        CLLocation *sf1hLocation = [[CLLocation alloc] initWithLatitude:37.789353 longitude:-122.388747];
        [sf1h setLocation:sf1hLocation];
        NSArray *sf1hRooms = [[NSArray alloc] initWithObjects:@"SF1H Room1", @"SF1H Room2", @"SF1H Room3", nil];
        [sf1h setRooms:sf1hRooms];
        expect([sf1h create]).to(equal(true));
        
        Building *ohOcc = [[Building alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:testDatabaseName];
        [ohOcc setName:@"OCC"];
        [ohOcc setDescription:@"Ohio Call Center"];
        [ohOcc setCampus:@"OH"];
        CLLocation *ohOccLocation = [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];
        [ohOcc setLocation:ohOccLocation];
        NSArray *ohOccRooms = [[NSArray alloc] initWithObjects:@"OCC Room1", @"OCC Room2", @"OCC Room3", nil];
        [ohOcc setRooms:ohOccRooms];
        expect([ohOcc create]).to(equal(true));
        
        Building *ohOfc = [[Building alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:testDatabaseName];
        [ohOfc setName:@"OFC"];
        [ohOfc setDescription:@"Ohio Fulfilment Center"];
        [ohOfc setCampus:@"OH"];
        CLLocation *ohOfcLocation = [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];
        [ohOfc setLocation:ohOfcLocation];
        NSArray *ohOfcRooms = [[NSArray alloc] initWithObjects:@"OFC Room1", @"OFC Room2", @"OFC Room3", nil];
        [ohOfc setRooms:ohOfcRooms];
        expect([ohOfc create]).to(equal(true));
        
        // create the buildings by campus view
        NSString *data = [[NSString alloc] initWithString:@"{\"language\": \"javascript\", \"views\": { \"by_campus\" : {\"map\": \"function(doc) { if (doc.type == \\\"Building\\\") { emit(doc.campus, doc); } }\" } } }"];
        NSLog(@"by_campus view: %@", data);
        CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
        bool bOK = [cbHelper createView:[couchDBnames baseDatasourceURL] withDatabase:testDatabaseName withUrlSuffix:@"/_design/building" withData:data];
        
        expect(bOK).to(equal(true));
        
        // find all sf campus builings
        NSDictionary *buildingDict = [cbHelper execute:[couchDBnames baseDatasourceURL] withDatabase:testDatabaseName withUrlSuffix:@"/_design/building/_view/by_campus" withParams:@"?key=%22SF%22"];
        
        // get the rows from the dictionary
        NSArray *rows = [buildingDict objectForKey:@"rows"];
        expect(rows.count).to(equal(3));
        
        // find all oh campus
        buildingDict = [cbHelper execute:[couchDBnames baseDatasourceURL] withDatabase:testDatabaseName withUrlSuffix:@"/_design/building/_view/by_campus" withParams:@"?key=%22OH%22"];
        
        // get the rows from the dictionary
        rows = [buildingDict objectForKey:@"rows"];
        expect(rows.count).to(equal(2));
        
    });
    
    it(@"should have a room list", ^{
        // add some campus'
        Campus *sf_campus = [[Campus alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:testDatabaseName];
        [sf_campus setName:@"SF"];
        [sf_campus setDescription:@"San Francisco"];
        [sf_campus setOrganization:[appCounstants organization]];
        NSArray *sfBuildings = [[NSArray alloc] initWithObjects:@"SFMB", @"SF1H", @"SF2F", nil];
        [sf_campus setBuildings:sfBuildings];
        expect([sf_campus create]).to(equal(true));
        
        Building *sf2f = [[Building alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:testDatabaseName];
        [sf2f setName:@"SF2F"];
        [sf2f setDescription:@"2 Folsom Gap Inc. HQ"];
        [sf2f setCampus:@"SF"];
        CLLocation *sf2fLocation = [[CLLocation alloc] initWithLatitude:37.791269 longitude:-122.390978];
        [sf2f setLocation:sf2fLocation];
        NSArray *sf2fRooms = [[NSArray alloc] initWithObjects:@"SF2F 2 North", @"SF2F Taco Truck", nil];
        [sf2f setRooms:sf2fRooms];
        expect([sf2f create]).to(equal(true));
        
        Building *sf1h = [[Building alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:testDatabaseName];
        [sf1h setName:@"SF1H"];
        [sf1h setDescription:@"1 Harrison"];
        [sf1h setCampus:@"SF"];
        CLLocation *sf1hLocation = [[CLLocation alloc] initWithLatitude:37.789353 longitude:-122.388747];
        [sf1h setLocation:sf1hLocation];
        NSArray *sf1hRooms = [[NSArray alloc] initWithObjects:@"SF1H Room1", @"SF1H Room2", @"SF1H Room3", nil];
        [sf1h setRooms:sf1hRooms];
        expect([sf1h create]).to(equal(true));
        
        // query for the sf 2 folsom building
        NSArray *roomList = [building roomListForBuilding:@"/SF2F"];
        expect(roomList.count).to(equal(2));
        
        expect([roomList objectAtIndex:0]).to(equal(@"SF2F 2 North"));
        expect([roomList objectAtIndex:1]).to(equal(@"SF2F Taco Truck"));
    });
});

SPEC_END
