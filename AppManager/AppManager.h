//
//  AppManager.h
//  fittedSolutionApp
//
//  Created by Waqar Ali on 11/07/2016.
//  Copyright © 2016 Avinash Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define app_manager [AppManager sharedInstance]

@interface AppManager : NSObject

+(AppManager *)sharedInstance;

-(NSString *) getDeviceID;
-(NSString *) getDeviceiOSVersion;
-(CGSize)getDeviceScreenSizeInPoints;
-(CGSize)getDeviceScreenSizeInPixels;

@end
