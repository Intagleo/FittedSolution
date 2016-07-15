//
//  AppDelegate.m
//  fittedSolutionApp
//
//  Created by Avinash Singh on 4/9/16.
//  Copyright © 2016 Avinash Singh. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize footLength,footWidh,archHeight,archDistance,talusHeight,toeBoxHeight,talusSlope,DL,mySpinner;
@synthesize x1,y1,w1,h1,x2,y2,w2,h2,postImageDataFront,postImageDataSide,men_US,men_Euro,men_UK,women_US,women_Euro,women_UK,resultID,sideID;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    footLength = @"";
    footWidh = 0;
    archHeight = @"";
    archDistance = @"";
    talusHeight = @"";
    talusSlope = @"";
    toeBoxHeight = @"";
    return YES;
}

-(void)addactivity
{
    [mySpinner removeFromSuperview];
    mySpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.window addSubview:mySpinner];
    [self.window bringSubviewToFront:mySpinner];
}

-(void)removeActivity
{
    [mySpinner removeFromSuperview];
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
