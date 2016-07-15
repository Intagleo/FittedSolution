//
//  AppManager.m
//  fittedSolutionApp
//
//  Created by Waqar Ali on 11/07/2016.
//  Copyright © 2016 Avinash Singh. All rights reserved.
//

#import "AppManager.h"

@implementation AppManager

+(AppManager *)sharedInstance
{
    static AppManager *instance = nil;
    
    if (!instance)
    {
        instance = [AppManager new];
    }
    return instance;
}

-(NSString *) getDeviceID
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

-(NSString *)getDeviceiOSVersion
{
    return [UIDevice currentDevice].systemVersion;
}

-(CGSize)getDeviceScreenSizeInPoints
{
    CGSize screenSize  = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    return screenSize;
}

-(CGSize)getDeviceScreenSizeInPixels
{
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize screenSize   = CGSizeMake([[UIScreen mainScreen] bounds].size.width * screenScale, [[UIScreen mainScreen] bounds].size.height * screenScale);
    return screenSize;
}

@end
