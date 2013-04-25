//
//  ApplicationConstants.m
//  Locus
//
//  Created by barry alexander on 4/23/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import "ApplicationConstants.h"

static ApplicationConstants *sharedInstance = nil;

NSString *kOrganizationKey        = @"organization";

@implementation ApplicationConstants

@synthesize organization;

- (id) init {
    self = [super init];
    if (self) {
        [self setupPreferences];
    }
    return self;
}

+ (ApplicationConstants*)sharedInstance
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
    NSString *organizationValue = [[NSUserDefaults standardUserDefaults] stringForKey:kOrganizationKey];
    
    if (organizationValue == nil)
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
            
            if ([keyValueStr isEqualToString:kOrganizationKey])
            {
                [self setOrganization:defaultValue];
            }
        }
        
        // since no default values have been set (i.e. no preferences file created), create it here
        NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                     organization, kOrganizationKey,
                                     nil];
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        organization = organizationValue;
    }
}

@end
