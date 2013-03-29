#import "SpecHelper.h"
#import "AppDelegate.h"
#import "Datasource.h"
#import "CouchbaseHelper.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(DatasourceSpec)


describe(@"Datasource", ^{

    beforeEach(^{

    });
    
    it(@"should have a default datasource", ^{
        // Get the app delegate
        AppDelegate *appDelegate = [[AppDelegate alloc] init];
        [appDelegate setupPreferences];
        // Get datasource URL
        NSLog(@"Datasource URL%@\n", [appDelegate datasourceURL]);
        [appDelegate datasourceURL] should equal(@"http://127.0.0.1:5984/");
    });
    
    it(@"should return a valid response from the datasource", ^{
        // Get the app delegate
        AppDelegate *appDelegate = [[AppDelegate alloc] init];
        [appDelegate setupPreferences];
        // how to call an http request sychronously and assert the response is 200
        NSLog(@"Datasource URL%@\n", [appDelegate datasourceURL]);

        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[appDelegate datasourceURL]]];
        
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSError *jsonParsingError = nil;
        NSDictionary *DBResponse = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
        
        expect(DBResponse).to(be_truthy());
        
        expect([DBResponse objectForKey:@"couchdb"]).to(equal(@"Welcome"));
    });
    
    it(@"should have a locations database", ^{
        // Get the app delegate
        AppDelegate *appDelegate = [[AppDelegate alloc] init];
        [appDelegate setupPreferences];

        // need a couchbase helper
        CouchbaseHelper *cbHelper = [[CouchbaseHelper alloc] init];
        
        // for local dev testing, there should be a locations db created:
        // curl -X PUT http://127.0.0.1:5984/locations
        bool bOK = [cbHelper databaseOperation:[appDelegate datasourceURL] withDatabase:@"locations" withMethod:@"PUT"];
        expect(bOK).to(equal(true));
        
        // clean up
        bOK = [cbHelper databaseOperation:[appDelegate datasourceURL] withDatabase:@"locations" withMethod:@"DELETE"];
        
        expect(bOK).to(equal(true));
    });
    
    it(@"should create a database entry",^{
        // Get the app delegate
        AppDelegate *appDelegate = [[AppDelegate alloc] init];
        [appDelegate setupPreferences];
        
        // need a couchbase helper
        CouchbaseHelper *cbHelper = [[CouchbaseHelper alloc] init];
        
        // create the locations db
        bool bOK = [cbHelper databaseOperation:[appDelegate datasourceURL] withDatabase:@"locations" withMethod:@"PUT"];
        expect(bOK).to(equal(true));
        
        bOK = [cbHelper createData:[appDelegate datasourceURL] withDatabase:@"locations" withData:@"{\"loc\": [37.791269,-122.390978]}" andKey:@"SF2F"];
        expect(bOK).to(equal(true));
        
        // clean up
        bOK = [cbHelper databaseOperation:[appDelegate datasourceURL] withDatabase:@"locations" withMethod:@"DELETE"];
        
        expect(bOK).to(equal(true));
    });
    
    
});

SPEC_END
