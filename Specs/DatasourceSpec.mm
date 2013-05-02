#import "SpecHelper.h"
#import "AppDelegate.h"
#import "Datasource.h"
#import "CouchDBHelper.h"
#import "CouchConstants.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(DatasourceSpec)


describe(@"Datasource", ^{

    beforeEach(^{

    });
    
    // get the database url and name from the couchdb singleton
    CouchConstants *couchDBnames = [[CouchConstants alloc] init];
    
    it(@"should have a default datasource", ^{
        // Get datasource URL
        NSLog(@"Datasource URL%@\n", [couchDBnames baseDatasourceURL]);
        [couchDBnames baseDatasourceURL] should equal(@"http://127.0.0.1:5984/");
    });
    
    it(@"should return a valid response from the datasource", ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[couchDBnames baseDatasourceURL]]];
        
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSError *jsonParsingError = nil;
        NSDictionary *DBResponse = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
        
        expect(DBResponse).to(be_truthy());
        
        expect([DBResponse objectForKey:@"couchdb"]).to(equal(@"Welcome"));
    });
    
    it(@"should have a locations database", ^{
        // need a couchbase helper
        CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
        
        // for local dev testing, there should be a locations db created:
        // curl -X PUT http://127.0.0.1:5984/locations
        bool bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:[couchDBnames databaseName] withMethod:@"PUT"];
        expect(bOK).to(equal(true));
        
        // clean up
        bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:[couchDBnames databaseName] withMethod:@"DELETE"];
        
        expect(bOK).to(equal(true));
    });
    
    it(@"should create a database entry",^{
        // need a couchbase helper
        CouchDBHelper *cbHelper = [[CouchDBHelper alloc] init];
        
        // create the locations db
        bool bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:[couchDBnames databaseName] withMethod:@"PUT"];
        expect(bOK).to(equal(true));
        
        bOK = [cbHelper createData:[couchDBnames baseDatasourceURL] withDatabase:[couchDBnames databaseName] withData:@"{\"loc\": [37.791269,-122.390978]}" andKey:@"SF2F"];
        expect(bOK).to(equal(true));
        
        // clean up
        bOK = [cbHelper databaseOperation:[couchDBnames baseDatasourceURL] withDatabase:[couchDBnames databaseName] withMethod:@"DELETE"];
        
        expect(bOK).to(equal(true));
    });
    
    
});

SPEC_END
