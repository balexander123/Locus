#import "CampusViewController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(CampusViewControllerSpec)

describe(@"CampusViewController", ^{
    __block CampusViewController *campusViewController;

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
    
});

SPEC_END
