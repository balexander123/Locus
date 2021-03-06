#import "SpecHelper.h"
#import "ApplicationConstants.h"
#import "CouchConstants.h"
#import "CouchDBHelper.h"
#import "Campus.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(CampusSpec)

describe(@"Campus", ^{
    __block Campus *campus;
    __block CouchConstants *couchDBnames;
    __block ApplicationConstants *appCounstants;
    __block NSString *testDatabaseName=@"campusspec";
    __block NSArray *campusRows;
    __block NSString *sf_desc = @"San Francisco";
    __block NSString *sfmb = @"SFMB";
    __block NSString *sf1h = @"SF1H";
    __block NSString *sf2f = @"SF2F";
    
    beforeEach(^{
        // Get couchdb constants
        couchDBnames = [[CouchConstants alloc] init];
        // Get app constants
        appCounstants = [[ApplicationConstants alloc] init];
        
        campus = [[Campus alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:testDatabaseName];
        
        // create locations db
        CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
        bool bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:testDatabaseName withMethod:@"PUT"];
        expect(bOK).to(equal(true));
        
        // add some campus'
        Campus *sf_campus = [[Campus alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:testDatabaseName];
        [sf_campus setName:@"SF"];
        [sf_campus setDescription:sf_desc];
        [sf_campus setOrganization:[appCounstants organization]];
        NSArray* sfBuildings = [[NSArray alloc] initWithObjects:sfmb, sf1h, sf2f, nil];
        [sf_campus setBuildings:sfBuildings];
        expect([sf_campus create]).to(equal(true));
        
        Campus *oh_campus = [[Campus alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:testDatabaseName];
        [oh_campus setName:@"OH"];
        [oh_campus setDescription:@"Ohio"];
        [oh_campus setOrganization:[appCounstants organization]];
        NSArray* ohBuildings = [[NSArray alloc] initWithObjects:@"OFC", @"OCC", nil];
        [oh_campus setBuildings:ohBuildings];
        expect([oh_campus create]).to(equal(true));
        
        Campus *petaluma = [[Campus alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:testDatabaseName];
        [petaluma setName:@"Petaluma"];
        [petaluma setDescription:@"Petaluma Campus"];
        [petaluma setOrganization:[appCounstants organization]];
        NSArray* petBuildings = [[NSArray alloc] initWithObjects:@"Athleta", nil];
        [petaluma setBuildings:petBuildings];
        expect([petaluma create]).to(equal(true));
        
        // let's add a campus from another organization
        Campus *poa = [[Campus alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:testDatabaseName];
        [poa setName:@"POA"];
        [poa setDescription:@"Porto Alegre"];
        [poa setOrganization:@"Thoughtworks"];
        expect([poa create]).to(equal(true));
        
        // create the view to query by organization
        NSString *data = [[NSString alloc] initWithString:@"{\"language\": \"javascript\", \"views\": { \"by_organization\" : {\"map\": \"function(doc) { if (doc.type == \\\"Campus\\\" && doc.organization == \\\"Gap\\\") { emit(doc.description, doc); } }\" } } }"];
        NSLog(@"by_organization view: %@", data);
        bOK = [cbHelper createView:[couchDBnames baseDatasourceURL] withDatabase:testDatabaseName withUrlSuffix:@"/_design/campus" withData:data];
        NSLog(@"createView status: %d", bOK);
    });
    
    afterEach(^{
        CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
        bool bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:testDatabaseName withMethod:@"DELETE"];
        expect(bOK).to(equal(true));
    });
    
    // given an organization
    it(@"should have a list of campus for the organization",^{
        [appCounstants organization] should equal(@"Gap");
        NSArray *rows = [campus campusListForOrganization:[appCounstants organization]];
        expect(rows.count).to(equal(3));
        NSMutableArray *campusArray = [[NSMutableArray alloc] init];
        for (NSDictionary *element in rows) {
            [campusArray addObject:[element objectForKey:@"id"]];
            NSLog(@"campus: %@", [element objectForKey:@"id"]);
        }
        expect([campusArray objectAtIndex:0]).to(equal(@"OH"));
        expect([campusArray objectAtIndex:1]).to(equal(@"Petaluma"));
        expect([campusArray objectAtIndex:2]).to(equal(@"SF"));
    });
    
    // given a campus
    it(@"should return its list of buildings",^{
        [appCounstants organization] should equal(@"Gap");
        campusRows = [campus campusListForOrganization:[appCounstants organization]];
        expect(campusRows.count).to(equal(3));
        
        // OH is at position zero
        NSDictionary *element = [campusRows objectAtIndex:0];
        NSDictionary *campusDict = [element valueForKey:@"value"];
        expect([campusDict valueForKey:@"_id"]).to(equal(@"OH"));
        NSDictionary *buildingDict = [campusDict valueForKey:@"buildings"];
        expect(buildingDict.count).to(equal(2));
        
        // Petaluma is next
        element = [campusRows objectAtIndex:1];
        campusDict = [element valueForKey:@"value"];
        expect([campusDict valueForKey:@"_id"]).to(equal(@"Petaluma"));
        buildingDict = [campusDict valueForKey:@"buildings"];
        expect(buildingDict.count).to(equal(1));
        
        // SF is last
        element = [campusRows objectAtIndex:2];
        campusDict = [element valueForKey:@"value"];
        expect([campusDict valueForKey:@"_id"]).to(equal(@"SF"));
        buildingDict = [campusDict valueForKey:@"buildings"];
        expect(buildingDict.count).to(equal(3));
    });
    
    it(@"should retrieve a campus from the datastore", ^{
        Campus *sf = [[Campus alloc] initWithDatasource:couchDBnames.baseDatasourceURL database:testDatabaseName];
        expect([sf retrieve:@"SF"]).to(equal(true));
        expect([sf description]).to(equal(sf_desc));
        expect([sf buildings].count).to(equal(3));
        NSArray *buildings = [sf buildings];
        expect([buildings objectAtIndex:0]).to(equal(sfmb));
        expect([buildings objectAtIndex:1]).to(equal(sf1h));
        expect([buildings objectAtIndex:2]).to(equal(sf2f));
    });
    
    it(@"should not find a campus that does not exist", ^{
        Campus *foo = [[Campus alloc] initWithDatasource:couchDBnames.baseDatasourceURL database:testDatabaseName];
        expect([foo retrieve:@"FOO"]).to(equal(false));
    });
});

SPEC_END
