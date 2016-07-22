//
//  AppDelegate.m
//  Qasim
//
//  Created by Lion0324 on 11/19/15.
//  Copyright © 2015 Lion0324. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize g_photoImage;
@synthesize g_flagImage;

+(AppDelegate*) sharedInstance
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSShadow * shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor lightGrayColor];
    shadow.shadowOffset = CGSizeMake(0, -1);
    
    NSDictionary * navBarTitleTextAttributes =
  @{ NSForegroundColorAttributeName : [UIColor whiteColor],
     NSShadowAttributeName          : shadow,
     NSFontAttributeName            : [UIFont systemFontOfSize:20] };
    
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];
    
    
    UIImage *image = [UIImage imageNamed:@"bar_bg.png"];
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

//    [[UINavigationBar appearance] setBackgroundImage:[UIImage new]
//                             forBarMetrics:UIBarMetricsDefault];
//    [UINavigationBar appearance].shadowImage = [UIImage new];
//    [UINavigationBar appearance].translucent = YES;
//    
//    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:206.0/255.0 green:54.0/255.0 blue:4.0/255.0 alpha:0.8]];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
