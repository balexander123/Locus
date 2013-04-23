#import "SpecHelper.h"
#import "CouchbaseHelper.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(CouchbaseHelperSpec)

describe(@"CouchbaseHelper", ^{
    __block CouchbaseHelper *cbHelper;

    beforeEach(^{
        cbHelper = [[CouchbaseHelper alloc] init];
    });
    
    it(@"should generate a UUID",^{
        NSString *uuid = [cbHelper uuid];
        
        NSLog(@"uuid: %@", uuid);
        
        expect(uuid.length).to(equal(36));
        
    });
});

SPEC_END
