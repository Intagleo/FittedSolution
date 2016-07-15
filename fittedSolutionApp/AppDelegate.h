//
//  AppDelegate.h
//  fittedSolutionApp
//
//  Created by Avinash Singh on 4/9/16.
//  Copyright © 2016 Avinash Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIActivityIndicatorView *mySpinner;
-(void)addactivity;
-(void)removeActivity;


@property (strong, nonatomic) NSString *footLength;
@property (assign) float footWidh;
@property (strong, nonatomic) NSString *archHeight;
@property (strong, nonatomic) NSString *archDistance;
@property (strong, nonatomic) NSString *talusHeight;
@property (strong, nonatomic) NSString *toeBoxHeight;
@property (strong, nonatomic) NSString *talusSlope;
@property (strong, nonatomic) NSString *DL;
@property (strong, nonatomic) NSString *frontFootImage;
@property (strong, nonatomic) NSString *sideFootImage;

@property (strong, nonatomic) NSString *men_US;
@property (strong, nonatomic) NSString *men_Euro;
@property (strong, nonatomic) NSString *men_UK;

@property (strong, nonatomic) NSString *resultID;
@property (strong, nonatomic) NSString *sideID;


@property (strong, nonatomic) NSString *women_US;
@property (strong, nonatomic) NSString *women_Euro;
@property (strong, nonatomic) NSString *women_UK;


@property (strong, nonatomic) NSData *postImageDataFront;

@property (strong, nonatomic) NSData *postImageDataSide;



@property(assign) int x1;
@property(assign) int y1;
@property(assign) int w1;
@property(assign) int h1;
@property(assign) int x2;
@property(assign) int y2;
@property(assign) int w2;
@property(assign) int h2;






@end

