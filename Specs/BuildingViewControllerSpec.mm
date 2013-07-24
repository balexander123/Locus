#import "SpecHelper.h"
#import "ApplicationConstants.h"
#import "CouchConstants.h"
#import "BuildingViewController.h"
#import "Campus.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(BuildingViewControllerSpec)

describe(@"BuildingViewController", ^{
    __block BuildingViewController *buildingViewController;
    __block UITableView *buildingTableView;
    __block Campus *campus;
    __block CouchConstants *couchDBnames;
    __block ApplicationConstants *appCounstants;
    __block NSString *sf_desc = @"San Francisco";
    __block NSString *sfmb = @"SFMB";
    __block NSString *sf1h = @"SF1H";
    __block NSString *sf2f = @"SF2F";

    beforeEach(^{
        // Get couchdb constants
        couchDBnames = [[CouchConstants alloc] init];
        // Get app constants
        appCounstants = [[ApplicationConstants alloc] init];
        
        campus = [[Campus alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:[couchDBnames databaseName]];
        [campus setName:@"SF"];
        [campus setDescription:sf_desc];
        [campus setOrganization:[appCounstants organization]];
        NSArray* sfBuildings = [[NSArray alloc] initWithObjects:sfmb, sf1h, sf2f, nil];
        [campus setBuildings:sfBuildings];
        [campus create:campus];
        buildingViewController = [[BuildingViewController alloc] initWithCampus:campus];
        [buildingViewController viewWillAppear:false];
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
        buildingTableView = [[UITableView alloc] init];
        expect([buildingViewController tableView:buildingTableView numberOfRowsInSection:0]).to(equal(3));
    });
    
    it(@"should be able to retrieve a building given a building id", ^{
        
    });
});

SPEC_END
