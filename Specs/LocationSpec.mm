#import "SpecHelper.h"
#import "AppDelegate.h"
#import "Location.h"
#import "FakeOrganization.h"
#import "Campus.h"
#import "User.h"
#import "OrganizationMock.h"
#import "CouchbaseHelper.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(LocationSpec)

describe(@"User locations", ^{        
        Location *location = [[Location alloc] init];
        
        [location startTracking];
        [location currentPosition];
        
        // Create a user
        User *user = [[User alloc] init];
        user.location = location;

        it(@"should know the location of the user", ^{
            [user.location latitude] should_not equal(NULL);
            [user.location longitude] should_not equal(NULL);
        });

        it(@"should know the nearest Gap campus of user", ^{
            Organization *organization = [[Organization alloc] init];
            // Get the app delegate
            AppDelegate *appDelegate = [[AppDelegate alloc] init];
            [appDelegate setupPreferences];
            // set the datasource of organization
            [organization setBaseDatasourceURL:[appDelegate datasourceURL]];
            // add some campus to the datastore
            Campus *campus = [organization campusNear: user.location];
            [campus.location latitude] should_not equal(NULL);
            [campus.location longitude] should_not equal(NULL);
        });
    
        it(@"should have a spatial view", ^{
            // Get the app delegate
            AppDelegate *appDelegate = [[AppDelegate alloc] init];
            [appDelegate setupPreferences];
            
            // use the couchdb helper to create a locations database and spatial view
            CouchbaseHelper *cbHelper = [[CouchbaseHelper alloc] init];
            
            // create the locations db
            bool bOK = [cbHelper databaseOperation:[appDelegate datasourceURL] withDatabase:@"locations" withMethod:@"PUT"];
            expect(bOK).to(equal(true));
            
            // create the spatial M/R emit function block as a JSON string
            NSString *viewData = [[NSString alloc]initWithString:@"{\"spatial\":{\"points\" : \"function(doc) {\\n if (doc.loc) {\\n emit({\\n type: \\\"Point\\\", \\n coordinates: [doc.loc[0], doc.loc[1]]\\n}, [doc._id, doc.loc]);\\n}};\"}}"];
            bOK = [cbHelper createView:[appDelegate datasourceURL] withDatabase:@"locations" withData:viewData];
            expect(bOK).to(equal(true));
            
            // clean up
            bOK = [cbHelper databaseOperation:[appDelegate datasourceURL] withDatabase:@"locations" withMethod:@"DELETE"];
            
            expect(bOK).to(equal(true));
        });
});
    
SPEC_END
