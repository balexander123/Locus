#import "CampusViewController.h"
#import "MockCampus.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(CampusViewControllerSpec)

describe(@"CampusViewController", ^{
    __block CampusViewController *campusViewController;
    __block UITableView *campusTableView;
    __block MockCampus *campus;

    beforeEach(^{
        campusViewController = [[CampusViewController alloc] init];
        [campusViewController viewWillAppear:false];
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
    
});

SPEC_END
