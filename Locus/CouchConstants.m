//
//  CouchConstants.m
//  Locus
//
//  Created by barry alexander on 4/23/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import "CouchConstants.h"

static CouchConstants *sharedInstance = nil;

NSString *kDatasourceKey        = @"couch_db_url";
NSString *kDatabaseKey          = @"database";

@implementation CouchConstants

@synthesize baseDatasourceURL;
@synthesize databaseName;

- (id) init {
    self = [super init];
    if (self) {
        [self setupPreferences];
    }
    return self;
}

+ (CouchConstants*)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (void)setupPreferences
{
    NSString *datasourceValue = [[NSUserDefaults standardUserDefaults] stringForKey:kDatasourceKey];
    NSString *databaseValue = [[NSUserDefaults standardUserDefaults] stringForKey:kDatabaseKey];
    
    if (datasourceValue == nil || databaseValue == nil)
    {
        // no default values have been set, create them here based on what's in our Settings bundle info
        //
        NSString *pathStr = [[NSBundle mainBundle] bundlePath];
        NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
        NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        
        NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
        NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
        
        NSDictionary *prefItem;
        for (prefItem in prefSpecifierArray)
        {
            NSString *keyValueStr = [prefItem objectForKey:@"Key"];
            id defaultValue = [prefItem objectForKey:@"DefaultValue"];
            
            if ([keyValueStr isEqualToString:kDatasourceKey])
            {
                [self setBaseDatasourceURL:defaultValue];
            }
            else if ([keyValueStr isEqualToString:kDatabaseKey])
            {
                [self setDatabaseName:defaultValue];
            }
        }
        
        // since no default values have been set (i.e. no preferences file created), create it here
        NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                     baseDatasourceURL, kDatasourceKey,
                                     databaseName, kDatabaseKey,
                                     nil];
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        baseDatasourceURL = datasourceValue;
        databaseName = databaseValue;
    }
}

@end
