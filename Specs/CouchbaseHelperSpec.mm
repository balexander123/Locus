#import "SpecHelper.h"
#import "CouchDBHelper.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(CouchDBHelperSpec)

describe(@"CouchDBHelper", ^{
    __block CouchDBHelper *cbHelper;

    beforeEach(^{
        cbHelper = [[CouchDBHelper alloc] init];
    });
    
    it(@"should generate a UUID",^{
        NSString *uuid = [cbHelper uuid];
        
        NSLog(@"uuid: %@", uuid);
        
        expect(uuid.length).to(equal(36));
        
    });
});

SPEC_END
