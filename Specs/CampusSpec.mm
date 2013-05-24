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
    
    beforeEach(^{
        // Get couchdb constants
        couchDBnames = [[CouchConstants alloc] init];
        // Get app constants
        appCounstants = [[ApplicationConstants alloc] init];
        
        campus = [[Campus alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:[couchDBnames databaseName]];
        
        // create locations db
        CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
        bool bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:[couchDBnames databaseName] withMethod:@"PUT"];
        expect(bOK).to(equal(true));
        
        // add some campus'
        Campus *sf_campus = [[Campus alloc] init];
        [sf_campus setName:@"SF"];
        [sf_campus setDescription:@"San Francisco"];
        [sf_campus setOrganization:[appCounstants organization]];
        [campus add:sf_campus];
        
        Campus *oh_campus = [[Campus alloc] init];
        [oh_campus setName:@"OH"];
        [oh_campus setDescription:@"Ohio"];
        [oh_campus setOrganization:[appCounstants organization]];
        [campus add:oh_campus];
        
        Campus *petaluma = [[Campus alloc] init];
        [petaluma setName:@"Petaluma"];
        [petaluma setDescription:@"Petaluma Campus"];
        [petaluma setOrganization:[appCounstants organization]];
        [campus add:petaluma];
        
        // let's add a campus from another organization
        Campus *poa = [[Campus alloc] init];
        [poa setName:@"POA"];
        [poa setDescription:@"Porto Alegre"];
        [poa setOrganization:@"Thoughtworks"];
        [campus add:poa];
        
        // create the view to query by organization
        NSString *data = [[NSString alloc] initWithString:@"{\"language\": \"javascript\", \"views\": { \"by_organization\" : {\"map\": \"function(doc) { if (doc.type == \\\"Campus\\\" && doc.organization == \\\"Gap\\\") { emit(doc.description, doc); } }\" } } }"];
        NSLog(@"by_organization view: %@", data);
        bOK = [cbHelper createView:[couchDBnames baseDatasourceURL] withDatabase:[couchDBnames databaseName] withView:@"/_design/campus" withData:data];
        NSLog(@"createView status: %d", bOK);
    });
    
    afterEach(^{
        CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
        bool bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:[couchDBnames databaseName] withMethod:@"DELETE"];
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
});

SPEC_END
