#import "SpecHelper.h"
#import "ApplicationConstants.h"
#import "CouchConstants.h"
#import "CouchbaseHelper.h"
#import "CampusList.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(CampusListSpec)

describe(@"CampusList", ^{
    __block CampusList *campusList;
    __block CouchConstants *couchDBnames;
    __block ApplicationConstants *appCounstants;

    beforeEach(^{
        // Get couchdb constants
        couchDBnames = [[CouchConstants alloc] init];
        // Get app constants
        appCounstants = [[ApplicationConstants alloc] init];
        
        campusList = [[CampusList alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:[couchDBnames databaseName]];
        
        // create locations db
        CouchbaseHelper *cbHelper = [[CouchbaseHelper alloc] init];
        bool bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:[couchDBnames databaseName] withMethod:@"PUT"];
        expect(bOK).to(equal(true));
        
        // add some campus'
        Campus *sf_campus = [[Campus alloc] init];
        [sf_campus setName:@"SF"];
        [sf_campus setDescription:@"San Francisco"];
        [sf_campus setOrganization:[appCounstants organization]];
        [campusList addCampus:sf_campus];
        
        Campus *oh_campus = [[Campus alloc] init];
        [oh_campus setName:@"OH"];
        [oh_campus setDescription:@"Ohio"];
        [oh_campus setOrganization:[appCounstants organization]];
        [campusList addCampus:oh_campus];
        
        Campus *petaluma = [[Campus alloc] init];
        [petaluma setName:@"Petaluma"];
        [petaluma setDescription:@"Description"];
        [petaluma setOrganization:[appCounstants organization]];
        [campusList addCampus:petaluma];
        
        // create the view to query by organization
        NSString *data = [[NSString alloc] initWithString:@"{\"language\": \"javascript\", \"views\": { \"by_organization\" : {\"map\": \"function(doc) { if (doc.type == \"Campus\" && doc.organization == \"Gap\") { emit(doc.description, doc); } }\" } } }"];
        bOK = [cbHelper createView:[couchDBnames baseDatasourceURL] withDatabase:@"locations/_design/campus" withData:data];
    });
    
    afterEach(^{
        CouchbaseHelper *cbHelper = [[CouchbaseHelper alloc] init];
        bool bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:[couchDBnames databaseName] withMethod:@"DELETE"];
        expect(bOK).to(equal(true));
    });
    
    // given an organization
    it(@"should have a list of campus for the organization",^{
        [appCounstants organization] should equal(@"Gap");
        NSDictionary *campusDict = [campusList campusListForOrganization:[appCounstants organization]];
        expect(campusDict.count).to(BeGreaterThan<int>(0));
    });
});

SPEC_END
