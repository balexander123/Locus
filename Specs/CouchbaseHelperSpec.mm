#import "CouchbaseHelper.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(CouchbaseHelperSpec)

describe(@"CouchbaseHelper", ^{
    __block CouchbaseHelper *model;

    beforeEach(^{

    });
    
    it(@"should generate a UUID",^{
        CouchbaseHelper *cbHelper = [[CouchbaseHelper alloc] init];
        NSString *uuid = [cbHelper uuid];
        
        NSLog(@"uuid: %@", uuid);
        
        expect(uuid.length).to(equal(36));
        
    });
});

SPEC_END
