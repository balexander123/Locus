//
//  AppDelegate.h
//  Locus
//
//  Created by barry alexander on 1/8/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@class CampusViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CampusViewController *campusViewController;
@property (strong, nonatomic) UITabBarController *locusController;
@property (strong, nonatomic) UINavigationController *browseNavController;
@property (strong, nonatomic) UINavigationController *userNavController;

@end
