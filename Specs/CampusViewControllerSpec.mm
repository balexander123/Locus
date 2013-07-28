#import "CouchConstants.h"
#import "ApplicationConstants.h"
#import "CouchDBHelper.h"
#import "CampusViewController.h"
#import "MockCampus.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(CampusViewControllerSpec)

describe(@"CampusViewController", ^{
    __block CampusViewController *campusViewController;
    __block UITableView *campusTableView;
    __block MockCampus *campus;
    __block CouchConstants *couchDBnames;
    __block ApplicationConstants *appCounstants;
    __block NSString *sf_desc = @"San Francisco";
    __block NSString *sfmb = @"SFMB";
    __block NSString *sf1h = @"SF1H";
    __block NSString *sf2f = @"SF2F";
    __block NSString *oh_desc = @"Ohio";
    __block NSString *occ = @"OCC";
    __block NSString *ofc = @"OFC";

    beforeEach(^{
        campusViewController = [[CampusViewController alloc] init];
        [campusViewController viewWillAppear:false];
        
        // Get couchdb constants
        couchDBnames = [[CouchConstants alloc] init];
        // Get app constants
        appCounstants = [[ApplicationConstants alloc] init];
        
        // create locations db
        CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
        bool bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:[couchDBnames databaseName] withMethod:@"PUT"];
        expect(bOK).to(equal(true));
        
        Campus *sfCampus = [[Campus alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:[couchDBnames databaseName]];
        [sfCampus setName:@"SF"];
        [sfCampus setDescription:sf_desc];
        [sfCampus setOrganization:[appCounstants organization]];
        NSArray* sfBuildings = [[NSArray alloc] initWithObjects:sfmb, sf1h, sf2f, nil];
        [sfCampus setBuildings:sfBuildings];
        expect([sfCampus create]).to(equal(true));
        
        Campus *ohCampus = [[Campus alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:[couchDBnames databaseName]];
        [ohCampus setName:@"OH"];
        [ohCampus setDescription:oh_desc];
        [ohCampus setOrganization:[appCounstants organization]];
        NSArray* ohBuildings = [[NSArray alloc] initWithObjects:ofc, occ, nil];
        [ohCampus setBuildings:ohBuildings];
        expect([ohCampus create]).to(equal(true));
        
        // create the view to query by organization
        NSString *data = [[NSString alloc] initWithString:@"{\"language\": \"javascript\", \"views\": { \"by_organization\" : {\"map\": \"function(doc) { if (doc.type == \\\"Campus\\\" && doc.organization == \\\"Gap\\\") { emit(doc.description, doc); } }\" } } }"];
        NSLog(@"by_organization view: %@", data);
        bOK = [cbHelper createView:[couchDBnames baseDatasourceURL] withDatabase:[couchDBnames databaseName] withUrlSuffix:@"/_design/campus" withData:data];
    });
    
    afterEach(^{
        CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
        bool bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:[couchDBnames databaseName] withMethod:@"DELETE"];
        expect(bOK).to(equal(true));
    });
    
    it(@"should have campus object set",^{
        expect(campusViewController.campus).to_not(be_nil());
    });
    
    it(@"should have application constants set",^{
        expect(campusViewController.appConstants).to_not(be_nil());
    });
    
    it(@"should have couch db constants set",^{
        expect(campusViewController.couchConstants).to_not(be_nil());
    });
    
    it(@"should have a campus list available",^{
        campusTableView = [[UITableView alloc] init];
        campus = [[MockCampus alloc] init];
        [campusViewController setCampus:campus];
        expect([campusViewController tableView:campusTableView numberOfRowsInSection:0]).to(equal(3));
    });
    
    it(@"should get the campus selected by the user", ^{
        expect([campusViewController tableView:campusTableView numberOfRowsInSection:0]).to(equal(2));
        Campus *sf = [campusViewController campusAtIndex:1];
        expect([sf description]).to(equal(sf_desc));
        expect([sf buildings].count).to(equal(3));
        NSArray *buildings = [sf buildings];
        expect([buildings objectAtIndex:0]).to(equal(sfmb));
        expect([buildings objectAtIndex:1]).to(equal(sf1h));
        expect([buildings objectAtIndex:2]).to(equal(sf2f));
    });
    
});

SPEC_END
