#import "SpecHelper.h"
#import "ApplicationConstants.h"
#import "CouchConstants.h"
#import "CouchDBHelper.h"
#import "User.h"
#import "Location.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UserSpec)

describe(@"User", ^{
    __block CouchConstants *couchDBnames;
    __block ApplicationConstants *appCounstants;
    __block NSString *sfCampus = @"SF";
    __block NSString *sfUser = @"Barry";
    __block NSString *project = @"mobile";
    
    beforeEach(^{
        // Get couchdb constants
        couchDBnames = [[CouchConstants alloc] init];
        // Get app constants
        appCounstants = [[ApplicationConstants alloc] init];
        
        // create locations db
        CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
        bool bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:[couchDBnames databaseName] withMethod:@"PUT"];
        expect(bOK).to(equal(true));
    });
    
    afterEach(^{
        CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
        bool bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:[couchDBnames databaseName] withMethod:@"DELETE"];
        expect(bOK).to(equal(true));
    });
    
    it(@"should persist a user", ^{
        User *user = [[User alloc] initWithDatasource:[couchDBnames baseDatasourceURL] database:[couchDBnames databaseName]];
        
        [user setCampus:sfCampus];
        [user setName:sfUser];
        Location *userLocation = [[Location alloc] init];        
        [userLocation startTracking];
        [userLocation currentPosition];
        [user setLocation:userLocation];
        [user setProject:project];
        expect([user create]).to(equal(true));
    });
    
    it(@"should know the location of the user", PENDING);
    
    it(@"should allow a user to publish their location", PENDING);
    
    it(@"should allow a user to enable/disable location tracking", PENDING);
    
    it(@"should publish when a user enters/leaves a campus", PENDING);
    
    it(@"should allow a user to search for another user", PENDING);
    
});

SPEC_END
