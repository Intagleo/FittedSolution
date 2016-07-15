//
//  footDescription.m
//  fittedSolutionApp
//
//  Created by Avinash Singh on 4/26/16.
//  Copyright © 2016 Avinash Singh. All rights reserved.
//

#import "footDescription.h"
#import "AppDelegate.h"
//#import "Base64.h"
#import "XMLReader.h"

#import <AVFoundation/AVFoundation.h>
#import <OpenEars/OELanguageModelGenerator.h>
#import <OpenEars/OEPocketsphinxController.h>
#import <OpenEars/OEAcousticModel.h>

#define LINUX_IMAGE_VALIDATION_URL @"http://207.178.170.24:5060"

#define WINDOWS_IMAGE_UPLOAD_SEGMENTATION_URL @"http://207.178.170.24/FittedSolutionsServices.asmx?op=uploadFrontFoot"

#define WINDOWS_IMAGE_UPLOAD_SIDE_FOOT_SEGMENTATION_URL @"http://207.178.170.24/FittedSolutionsServices.asmx?op=uploadSideFoot"

@interface footDescription ()
{
    AppDelegate *appDel;
}

@end

@implementation footDescription
{
    NSURLSession *session;
    NSMutableData    *mutableData;
    NSMutableURLRequest *theRequest;
    NSString *x1,*y1,*w1,*h1;
    NSString *programName;
    NSData *imageData;
    
    NSString *footId;
    
    float foot_width;
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //--------
    
  /*
    NSLog(@"%@", [AVSpeechSynthesisVoice speechVoices] );
    
    // set up our audio session
    _session = [AVAudioSession sharedInstance];
    
    [_session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // set up our TTS synth
    _synth = [[AVSpeechSynthesizer alloc] init];
    
    [_synth setDelegate:self];
    
    [self performSelector:@selector(function) withObject:nil afterDelay:0];
   */

    
    //--------
    
    appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.title = @"Foot Description";
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:55/255.0f green:130/255.0f blue:198/255.0f alpha:1.0f] }];
    
   
    
    UIImage *backImage = [UIImage imageNamed:@"back"];
    
    UIBarButtonItem  *backBtn = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    
    backBtn.tintColor =  [UIColor colorWithRed:55/255.0f green:130/255.0f blue:198/255.0f alpha:1.0f];
    // create a spacer
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 0;
    
    NSArray *buttons = @[backBtn,space];
    
    self.navigationItem.leftBarButtonItems = buttons;
    
    
    _footWidthTxt.translatesAutoresizingMaskIntoConstraints=YES;
    _footLengthLbl.translatesAutoresizingMaskIntoConstraints=YES;
    _footWidthLbl.translatesAutoresizingMaskIntoConstraints=YES;
    _archHeightLbl.translatesAutoresizingMaskIntoConstraints=YES;
    _archDistanceLbl.translatesAutoresizingMaskIntoConstraints=YES;
    _talusHeightLbl.translatesAutoresizingMaskIntoConstraints=YES;
    _toeBoxHeightLbl.translatesAutoresizingMaskIntoConstraints=YES;
    _talusSlopeLbl.translatesAutoresizingMaskIntoConstraints=YES;

    
    _footLengthLbl.frame = CGRectMake(8, 339, 92, 21);
    _footWidthLbl.frame = CGRectMake(8, 374, 85, 21);
    _archHeightLbl.frame = CGRectMake(8, 403, 91, 21);
    _archDistanceLbl.frame = CGRectMake(8, 435, 115, 21);
    _talusHeightLbl.frame = CGRectMake(8, 468, 96, 21);
    _toeBoxHeightLbl.frame = CGRectMake(8, 501, 117, 21);
    _talusSlopeLbl.frame = CGRectMake(8, 532, 117, 21);
    
    
    _footlengthTxt.translatesAutoresizingMaskIntoConstraints=YES;
    _footWidthTxt.translatesAutoresizingMaskIntoConstraints=YES;
    _archHeightTxt.translatesAutoresizingMaskIntoConstraints=YES;
    _archDistanceTxt.translatesAutoresizingMaskIntoConstraints=YES;
    _talusHeightTxt.translatesAutoresizingMaskIntoConstraints=YES;
    _toeBoxHeightTxt.translatesAutoresizingMaskIntoConstraints=YES;
    _talusSlopeTxt.translatesAutoresizingMaskIntoConstraints=YES;
    
    _footlengthTxt.frame = CGRectMake(130, 337, 50, 30);
    _footWidthTxt.frame =  CGRectMake(130, 374, 50, 30);
    _archHeightTxt.frame =  CGRectMake(130, 405, 50, 30);
    _archDistanceTxt.frame =  CGRectMake(130, 436, 50, 30);
    _talusHeightTxt.frame =  CGRectMake(130, 468, 50, 30);
    _toeBoxHeightTxt.frame =  CGRectMake(130, 503, 50, 30);
    _talusSlopeTxt.frame =  CGRectMake(130, 532, 50, 30);
    

    //Foot Divider
    _footDivider1Lbl.frame = CGRectMake(0, 368, 187, 1);
    _footDivider2Lbl.frame = CGRectMake(0, 401, 187, 1);
    _footDivider3Lbl.frame = CGRectMake(0, 433, 187, 1);
    _footDivider4Lbl.frame = CGRectMake(0, 468, 187, 1);
    _footDivider5Lbl.frame = CGRectMake(0, 501, 187, 1);
    _footDivider6Lbl.frame = CGRectMake(0, 531, 187, 1);
    
    // _ShoeDivider
    
    _shoeDivider1Lbl.translatesAutoresizingMaskIntoConstraints=YES;
    _shoeDivider2Lbl.translatesAutoresizingMaskIntoConstraints=YES;
    _shoeDivider3Lbl.translatesAutoresizingMaskIntoConstraints=YES;
    _shoeDivider4Lbl.translatesAutoresizingMaskIntoConstraints=YES;
    _shoeDivider5Lbl.translatesAutoresizingMaskIntoConstraints=YES;
    _shoeDivider6Lbl.translatesAutoresizingMaskIntoConstraints=YES;
    
    _shoeDivider1Lbl.frame = CGRectMake(202, 369, 300, 1);
    _shoeDivider2Lbl.frame = CGRectMake(202, 401, 300, 1);
    _shoeDivider3Lbl.frame = CGRectMake(202, 433, 300, 1);
    _shoeDivider4Lbl.frame = CGRectMake(202, 468, 300, 1);
    _shoeDivider5Lbl.frame = CGRectMake(202, 501, 300, 1);
    _shoeDivider6Lbl.frame = CGRectMake(202, 531, 300, 1);
    
    // _shoeDivider1Lbl.frame

    _mensUSLblTxt.translatesAutoresizingMaskIntoConstraints=YES;
    _mensEuroLblTxt.translatesAutoresizingMaskIntoConstraints=YES;
    _mensUKLblTxt.translatesAutoresizingMaskIntoConstraints=YES;
    
    _womensLblTxt.translatesAutoresizingMaskIntoConstraints=YES;
    _womensEuroLblTxt.translatesAutoresizingMaskIntoConstraints=YES;
    _womenUKLblTxt.translatesAutoresizingMaskIntoConstraints=YES;
    
    _shoeSizeLbl.translatesAutoresizingMaskIntoConstraints=YES;
    
    _shoeSizeLbl.textAlignment = NSTextAlignmentCenter;
    
    _shoeSizeLbl.frame = CGRectMake(230, 342, 117, 23);//X:216
    _mensUSLbl.frame = CGRectMake(202, 376, 80, 21);
    _mensEuroLbl.frame = CGRectMake(202, 411, 39, 21);
    _mensUKLbl.frame = CGRectMake(202, 440, 117, 21);
    
    _mensUSLblTxt.frame = CGRectMake(320, 376, 80, 21);// x290
    
    //   _mensUSLblTxt.backgroundColor =[UIColor redColor];
    
    _mensEuroLblTxt.frame = CGRectMake(320, 406, 80, 21);
    _mensUKLblTxt.frame = CGRectMake(320, 439, 80, 21);
    
    _womensLbl.frame = CGRectMake(202, 477, 91, 21);
    _womensEuroLbl.frame = CGRectMake(202, 508, 50, 21);
    _womenUKLbl.frame = CGRectMake(202, 536, 50, 21);
    
    
    _womensLblTxt.frame = CGRectMake(320, 477, 80, 21);
    _womensEuroLblTxt.frame = CGRectMake(320, 508, 80, 21);
    _womenUKLblTxt.frame = CGRectMake(320, 536, 80, 21);
    

    
   // _spinner.translatesAutoresizingMaskIntoConstraints = YES;
    
  //  _spinner.frame = CGRectMake(160, 180, 37, 37);
    
  //  [_spinner startAnimating];
    
   //  [self performSelectorInBackground:@selector(segmentationProcess) withObject:nil];
    
    
    _footImageView.image = [UIImage imageNamed:@"side"];
    
    _instructionLbl.text = @"Swipe left for front view";
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftAction)];
    
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
   
    [self.view addGestureRecognizer:swipeLeft];
    
  //  _footWidth = @"12.3456";
    
   /*
    _footWidth = @"12.3456";
    _footLength = @"12.3456";
    _archHeight = @"12.3456";
    _archDistance = @"12.3456";
    _talusHeight= @"12.3456";
    _toeBoxHeight = @"12.3456";
    _talusSlope = @"12.3456";
    */
  
    if (_footWidth.length == 0) {
       _footWidthTxt.text = @" ";
    }
    else
    {
        
    _footWidthTxt.text = [NSString stringWithFormat:@"%.2f\" ",[_footWidth floatValue]];
        
    }
    
    NSLog(@"foot width : %lu",_footWidth.length);
 //   _footlengthTxt.text =    @"1234";//_footLength;
    
    if (_footLength.length == 0) {
        _footlengthTxt.text = @" ";
    }
    else
    {
        _footlengthTxt.text = [NSString stringWithFormat:@"%.2f\"",[_footLength floatValue]];
        
    }
    
    
    if (_archHeight.length == 0) {
        _archHeightTxt.text = @" ";
    }
    else
    {
        _archHeightTxt.text = [NSString stringWithFormat:@"%.2f\"",[_archHeight floatValue]];
        
    }
    
    
    if (_archDistance.length == 0) {
        _archDistanceTxt.text = @" ";
    }
    else
    {
       _archDistanceTxt.text = [NSString stringWithFormat:@"%.2f\"",[_archDistance floatValue]];
        
    }
    
    
    
    if (_talusHeight.length == 0) {
        _talusHeightTxt.text = @" ";
    }
    else
    {
        _talusHeightTxt.text = [NSString stringWithFormat:@"%.2f\"",[_talusHeight floatValue]];
        
    }

    
    if (_toeBoxHeight.length == 0) {
        _toeBoxHeightTxt.text = @" ";
    }
    else
    {
        _toeBoxHeightTxt.text = [NSString stringWithFormat:@"%.2f\"",[_toeBoxHeight floatValue]];
        
    }
    
    
    if (_talusSlope.length == 0) {
        _talusSlopeTxt.text = @" ";
    }
    else
    {
        
        _talusSlopeTxt.text = [NSString stringWithFormat:@"%.2f\"",[_talusSlope floatValue]];

    }
    /*
    _menUS = @"10.5";
    _menEuro = @"10";
    _menUK = @"43/44";
    _womenUS = @"11.5";
    _womenEuro = @"42";
    _womenUK = @"9.5";
     
     */
    
    
    _mensUSLblTxt.text =  [NSString stringWithFormat:@"%.2f",[_menUS floatValue]];
;
    _mensEuroLblTxt.text = [NSString stringWithFormat:@"%.2f",[_menEuro floatValue]];
    _mensUKLblTxt.text = _menUK;//[NSString stringWithFormat:@"%.2f\"",[_menUK floatValue]];
    
  //  _womensLblTxt.text = [NSString stringWithFormat:@"%.2f",[_womenUS floatValue]] ;
    
    _womensLblTxt.text = _womenUS;
    
   // _womensEuroLblTxt.text = [NSString stringWithFormat:@"%.2f",[_womenEuro floatValue]] ;
    
    _womensEuroLblTxt.text = _womenEuro;
    
  ///  _womenUKLblTxt.text = [NSString stringWithFormat:@"%.2f",[_womenUK floatValue]];
    
    _womenUKLblTxt.text = _womenUK;
    
  //   [self performSelectorInBackground:@selector(validateImageProcess) withObject:nil];
    
    // Do any additional setup after loading the view.
}

-(void)swipeLeftAction
{
     _instructionLbl.text = @"Swipe right for side view";
    
    
  /*  _footlengthTxt.text = @"13.3";
    _footWidthTxt.text =  @"6.67";
    _archHeightTxt.text = @"0.577";
    _archDistanceTxt.text = @"4.24";
    _talusHeightTxt.text = @"6.89";
    _toeBoxHeightTxt.text = @"2.28";*/
    
     _footImageView.image = [UIImage imageNamed:@"front"];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightAction)];
    
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeRight];

}

-(void)swipeRightAction
{
     _instructionLbl.text = @"Swipe left for front view";
    
 /*   _footlengthTxt.text = @"10.3";
    _footWidthTxt.text = @"3.67";
    _archHeightTxt.text = @"0.567";
    _archDistanceTxt.text = @"4.24";
    _talusHeightTxt.text = @"5.29";
    _toeBoxHeightTxt.text = @"1.28";*/
    
    _footImageView.image = [UIImage imageNamed:@"side"];

}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//--------

- (IBAction)uploadClk:(id)sender
{
    
    [self performSelectorInBackground:@selector(segmentationProcess) withObject:nil];
    
    //  [self upload]; // freezes the UI
    
}






-(void)segmentationProcess
{
    
    NSLog(@"Postdata front  foot : %@",appDel.postImageDataFront);
    NSLog(@"Input to windows linux grid params : x: %d  y: %d  w : %d h : %d",appDel.x2,appDel.y2,appDel.w2,appDel.h2);
    
    [self UploadFrontSegmentation:appDel.postImageDataFront xGrid:appDel.x2 yGrid:appDel.y2 wGrid:appDel.w2 hGrid:appDel.h2];
    
   
}

-(void)UploadFrontSegmentation:(NSData*)imgData xGrid:(int)X2 yGrid:(int)Y2 wGrid:(int)W2  hGrid:(int)H2
{
    
    //  UIImage *image = [UIImage imageNamed:@"IMG_1284.JPG"];
    //  CGSize constraint = CGSizeMake(640, 480);
    //  UIImage *newImage = [self scaleImage:image toSize:constraint];
    //  NSData   *imgData = UIImageJPEGRepresentation(image, 1.0f);
    
    
    NSDictionary *headers = @{ @"SOAPAction": @"http://tempuri.org/uploadFrontFoot",
                               @"content-type": @"text/xml; charset=utf-8",
                               @"cache-control": @"no-cache",
                               };
    
    NSString *base64String = [appDel.postImageDataFront base64Encoding];
    
    NSData *segmentData = [[NSData alloc] initWithData:[[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><uploadFrontFoot xmlns=\"http://tempuri.org/\"><Image>%@</Image><pointA>%d</pointA><pointB>%d</pointB><pointC>%d</pointC><pointD>%d</pointD></uploadFrontFoot></soap:Body></soap:Envelope>",base64String,X2,Y2,W2,H2] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:WINDOWS_IMAGE_UPLOAD_SEGMENTATION_URL]   cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:segmentData];
    [request setTimeoutInterval:5*60];
    
    session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    }
                                                    else {
                                                        
                                                        
                                                        NSDictionary *dict = [XMLReader dictionaryForXMLData:data
                                                                                                     options:XMLReaderOptionsProcessNamespaces
                                                                                                       error:&error];
                                                        
                                                        
                                                        NSLog(@"final response : %@",dict);
                                                        
                                                        
                                                        
                                                        NSString *finalStr = [[[[[dict valueForKey:@"Envelope"]valueForKey:@"Body"]valueForKey:@"uploadFrontFootResponse"]valueForKey:@"uploadFrontFootResult"]valueForKey:@"text"];
                                                        
                                                        
                                                        NSArray *errorArr = [finalStr componentsSeparatedByString:@":"];
                                                        
                                                        NSString *errorTxt  = [errorArr objectAtIndex:0];
                                                        
                                                        
                                                        errorTxt = [errorTxt stringByReplacingOccurrencesOfString:@"\""
                                                                                                       withString:@""];
                                                        
                                                        errorTxt = [errorTxt stringByReplacingOccurrencesOfString:@"{"
                                                                                                       withString:@""];
                                                        
                                                        NSLog(@"error txt : %@",errorTxt);
                                                        
                                                        if ([errorTxt isEqualToString:@"errorMessage"]) {
                                                            
                                                            NSLog(@"Segmentation Failure");
                                                            
                                                            [self performSelectorOnMainThread:@selector(stopActivity) withObject:nil waitUntilDone:YES];
                                                            
                                                            NSString *errorMsg = [errorArr objectAtIndex:1];
                                                            
                                                            errorMsg = [errorMsg stringByReplacingOccurrencesOfString:@"}"
                                                                                                           withString:@""];
                                                            
                                                            NSLog(@"side Feet Error : %@",errorMsg);
                                                            
                                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🎁 Fitted Solutions Error 🎁"
                                                                                                            message:errorMsg
                                                                                                           delegate:self
                                                                                                  cancelButtonTitle:@"OK"
                                                                                                  otherButtonTitles:nil];
                                                            [alert show];

                                                            
                                                                                                                      
                                                        }
                                                        else{
                                                            
                                                            
                                                            NSArray *resultArr = [finalStr componentsSeparatedByString:@","];
                                                            
                                                            NSLog(@"foot responce : %@",resultArr);
                                                            
                                                            
                                                            NSString *temp = [resultArr objectAtIndex:0];
                                                            
                                                            temp = [temp stringByReplacingOccurrencesOfString:@"\""
                                                                                                   withString:@""];
                                                            
                                                            temp = [temp stringByReplacingOccurrencesOfString:@"{"
                                                                                                   withString:@""];
                                                            
                                                            footId = [[temp componentsSeparatedByString:@":"]objectAtIndex:1];
                                                            
                                                            
                                                            
                                                            
                                                            NSLog(@"foot id: %@",footId);
                                                            
                                                            NSString *temp1 = [resultArr objectAtIndex:1];
                                                            
                                                            temp1 = [temp1 stringByReplacingOccurrencesOfString:@"\""
                                                                                                     withString:@""];
                                                            
                                                            temp1 = [temp1 stringByReplacingOccurrencesOfString:@" "
                                                                                                     withString:@""];
                                                            
                                                            temp1 = [temp1 stringByReplacingOccurrencesOfString:@"}"
                                                                                                     withString:@""];
                                                            
                                                            foot_width = [[[temp1 componentsSeparatedByString:@":"]objectAtIndex:1]intValue];
                                                            
                                                            appDel.footWidh = foot_width;
                                                            
                                                            NSLog(@"foot width : %f",foot_width);
                                                            
                                                            NSString *strTemp = [NSString stringWithFormat:@"foot Id : %@ | foot width : %f",footId,foot_width];
                                                            
                                                           /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fitted Solutions Foot ID : Foot Width "
                                                                                                            message:strTemp
                                                                                                           delegate:nil
                                                                                                  cancelButtonTitle:@"OK"
                                                                                                  otherButtonTitles:nil];
                                                            [alert show];*/

                                                            
                                                         //   _footWidthTxt.text =  appDel.footWidh;
                                                            
                                                        //    [self performSelectorInBackground:@selector(sideFootSegmentation) withObject:nil];
                                                            
                                                            [self sideFootSegmentation];
                                                            
                                                        }
                                                        
                                                        
                                                        
                                                        
                                                        
                                                    }
                                                    
                                                    
                                                }];
    
    [dataTask resume];
}

-(void)sideFootSegmentation
{
   // appDel.postImageDataSide = UIImageJPEGRepresentation([UIImage imageNamed:@"IMG_1284.JPG"],1.0);
    
//    appDel.x1 = 203;
//    appDel.y1 = 274;
//    appDel.w1 = 402;
//    appDel.h1 = 134;
    
    NSLog(@"Postdata side  foot : %@",appDel.postImageDataSide);
    NSLog(@"Input to windows linux grid params for side foot: x: %d  y: %d  w : %d h : %d",appDel.x1,appDel.y1,appDel.w1,appDel.h1);
    
    [self UploadSideSegmentation:appDel.postImageDataSide xGrid:appDel.x1 yGrid:appDel.y1 wGrid:appDel.w1 hGrid:appDel.h1 footId:[footId intValue] footWidth:appDel.footWidh];
}

-(void)UploadSideSegmentation:(NSData*)imgData xGrid:(int)X1 yGrid:(int)Y1 wGrid:(int)W1  hGrid:(int)H1 footId:(int)FootId footWidth:(float)FootWidth
{
   // UIImage *image = [UIImage imageNamed:@"IMG_1284.JPG"];
  //  NSData   *myImgData = UIImageJPEGRepresentation(image, 1.0f);

    
    
    NSDictionary *headers = @{ @"SOAPAction": @"http://tempuri.org/uploadSideFoot",
                               @"content-type": @"text/xml; charset=utf-8",
                               @"cache-control": @"no-cache",
                               };
    
   NSString *base64String = [imgData base64Encoding];
    
  //  FootWidth = 4;
  //  FootId = 2;
    
    NSData *segmentData = [[NSData alloc] initWithData:[[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><uploadSideFoot xmlns=\"http://tempuri.org/\"><Image>%@</Image><pointA>%d</pointA><pointB>%d</pointB><pointC>%d</pointC><pointD>%d</pointD><footID>%d</footID><footWidth>%f</footWidth></uploadSideFoot></soap:Body></soap:Envelope>",base64String,X1,Y1 ,W1,H1,FootId,FootWidth] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:WINDOWS_IMAGE_UPLOAD_SIDE_FOOT_SEGMENTATION_URL]   cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:segmentData];
    [request setTimeoutInterval:5*60];
    
    session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    }
                                                    else {
                                                                                                  
                                                        
                NSDictionary *dict = [XMLReader dictionaryForXMLData:data
                                                                options:XMLReaderOptionsProcessNamespaces
                                                                                                       error:&error];
                                                        
                                                        
                                                        NSLog(@"final response : %@",dict);
                                                        
            NSString *finalStr = [[[[[dict valueForKey:@"Envelope"]valueForKey:@"Body"]valueForKey:@"uploadSideFootResponse"]valueForKey:@"uploadSideFootResult"]valueForKey:@"text"];
                                                        
                                                        
            NSArray *errorArr = [finalStr componentsSeparatedByString:@":"];
                                                        
            NSString *errorTxt  = [errorArr objectAtIndex:0];
                                                        
                                                        
            errorTxt = [errorTxt stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                                        
            errorTxt = [errorTxt stringByReplacingOccurrencesOfString:@"{" withString:@""];
                                                        
                                    NSLog(@"error txt : %@",errorTxt);
                                                        
                                    if ([errorTxt isEqualToString:@"errorMessage"]) {
                                                            
                                    NSString *errorMsg = [errorArr objectAtIndex:1];
                                                            
                                    errorMsg = [errorMsg stringByReplacingOccurrencesOfString:@"}"
                                                        withString:@""];
                                                            
                                                            NSLog(@"side Feet Error : %@",errorMsg);
                                        
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fitted Solutions Error"
                                                                                        message:errorMsg
                                                                                       delegate:self
                                                                              cancelButtonTitle:@"OK"
                                                                              otherButtonTitles:nil];
                                        [alert show];

                                        
                                                        }
                                                        else{
                                                            
                                                            
                                                            _spinner.hidden = TRUE;
                                                            
                                                            NSArray *resultArr = [finalStr componentsSeparatedByString:@","];
                                                            
                                                            
                                                            NSLog(@"side foot Result : %@",resultArr);
                                                            
                                                            NSString *temp = [resultArr objectAtIndex:0];
                                                            
                                                            temp = [temp stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                                            
                                                            temp = [temp stringByReplacingOccurrencesOfString:@"{" withString:@""];
                                                            
                                                            NSString *footLength = [[temp componentsSeparatedByString:@":"]objectAtIndex:1];
                                                            
                                                            NSLog(@"foot Length >>>>> %@",footLength);
                                                            
                                                            appDel.footLength = footLength;
                                                            
                                                            //-----------------------------------------------
                                                            
                                                            NSString *temp1 = [resultArr objectAtIndex:1];
                                                            
                                                            temp1 = [temp1 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                                            
                                                            NSString *footWidth = [[temp1 componentsSeparatedByString:@":"]objectAtIndex:1];
                                                            
                                                            NSLog(@"foot width >>>>>> %@",footWidth);
                                                            
                                                            appDel.footWidh = [footWidth intValue];
                                                            //-----------------------------------------------
                                                            
                                                            NSString *temp2 = [resultArr objectAtIndex:2];
                                                            
                                                            temp2 = [temp2 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                                            
                                                            NSString *ArchHeight = [[temp2 componentsSeparatedByString:@":"]objectAtIndex:1];
                                                            
                                                            NSLog(@"Arch Height >>>>>> %@",ArchHeight);
                                                            
                                                            appDel.archHeight = ArchHeight;
                                                            
                                                            //-----------------------------------------------
                                                            
                                                            NSString *temp3 = [resultArr objectAtIndex:3];
                                                            
                                                            temp3 = [temp3 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                                            
                                                            NSString *ArchDistance = [[temp3 componentsSeparatedByString:@":"]objectAtIndex:1];
                                                            
                                                            NSLog(@"Arch Distance >>>>>> %@",ArchDistance);
                                                            
                                                            appDel.archDistance = ArchDistance;
                                                            
                                                            //-----------------------------------------------
                                                            
                                                            NSString *temp4 = [resultArr objectAtIndex:4];
                                                            
                                                            temp4 = [temp4 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                                            
                                                            NSString *TalusHeight = [[temp4 componentsSeparatedByString:@":"]objectAtIndex:1];
                                                            
                                                            NSLog(@"Talus Height >>>>>> %@",TalusHeight);
                                                            
                                                            appDel.talusHeight = TalusHeight;
                                                            
                                                            //-----------------------------------------------
                                                            
                                                            NSString *temp5 = [resultArr objectAtIndex:5];
                                                            
                                                            temp5 = [temp5 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                                            
                                                            NSString *ToeBoxHeight = [[temp5 componentsSeparatedByString:@":"]objectAtIndex:1];
                                                            
                                                            NSLog(@"Toe Box Height >>>>>> %@",ToeBoxHeight);
                                                            
                                                            appDel.toeBoxHeight = ToeBoxHeight;
                                                            
                                                            //-----------------------------------------------
                                                            
                                                            NSString *temp6 = [resultArr objectAtIndex:6];
                                                            
                                                            temp6 = [temp6 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                                            
                                                            NSString *TalusSlope = [[temp6 componentsSeparatedByString:@":"]objectAtIndex:1];
                                                            
                                                            NSLog(@"Talus Slope >>>>>> %@",TalusSlope);
                                                            
                                                            appDel.talusSlope = TalusSlope;
                                                            
                                                            //-----------------------------------------------
                                                            
                                                            NSString *temp7 = [resultArr objectAtIndex:7];
                                                            
                                                            temp7 = [temp7 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                                            
                                                            NSString *MenUS = [[temp7 componentsSeparatedByString:@":"]objectAtIndex:1];
                                                            
                                                            NSLog(@"Men US >>>>>> %@",MenUS);
                                                            
                                                            appDel.men_US = MenUS;
                                                            
                                                            //-----------------------------------------------
                                                            
                                                            NSString *temp8 = [resultArr objectAtIndex:8];
                                                            
                                                            temp8 = [temp8 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                                            
                                                            NSString *MenEuro = [[temp8 componentsSeparatedByString:@":"]objectAtIndex:1];
                                                            
                                                            NSLog(@"Men Euro >>>>>> %@",MenEuro);
                                                            
                                                            appDel.men_Euro = MenEuro;
                                                            
                                                            //-----------------------------------------------
                                                            
                                                            NSString *temp9 = [resultArr objectAtIndex:9];
                                                            
                                                            temp9 = [temp9 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                                            
                                                            NSString *MenUK = [[temp9 componentsSeparatedByString:@":"]objectAtIndex:1];
                                                            
                                                            NSLog(@"Men UK >>>>>> %@",MenUK);
                                                            
                                                            appDel.men_UK = MenUK;
                                                            
                                                            //-----------------------------------------------
                                                            
                                                            NSString *temp10 = [resultArr objectAtIndex:10];
                                                            
                                                            temp10 = [temp10 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                                            
                                                            NSString *womenUS = [[temp10 componentsSeparatedByString:@":"]objectAtIndex:1];
                                                            
                                                            NSLog(@"Women US >>>>>> %@",womenUS);
                                                            
                                                            appDel.women_US = womenUS;
                                                            
                                                            //-----------------------------------------------
                                                            
                                                            NSString *temp11 = [resultArr objectAtIndex:11];
                                                            
                                                            temp11 = [temp11 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                                            
                                                            NSString *womenEuro = [[temp11 componentsSeparatedByString:@":"]objectAtIndex:1];
                                                            
                                                            NSLog(@"Women Euro >>>>>> %@",womenEuro);
                                                            
                                                            appDel.women_Euro = womenEuro;
                                                            
                                                            //-----------------------------------------------
                                                            
                                                            NSString *temp12 = [resultArr objectAtIndex:12];
                                                            
                                                            temp12 = [temp12 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                                            
                                                            temp12 = [temp12 stringByReplacingOccurrencesOfString:@"}" withString:@""];
                                                            
                                                            NSString *womenUK = [[temp12 componentsSeparatedByString:@":"]objectAtIndex:1];
                                                            
                                                            NSLog(@"Women UK >>>>>> %@",womenUK);
                                                            
                                                            appDel.women_UK = womenUK;
                                                            
                                                            [self performSelectorOnMainThread:@selector(DisplayData) withObject:nil waitUntilDone:NO];
                                                            
                                                            
                                                            
                                                        }
                                                    }
                                                    
                                                }];
    
    [dataTask resume];
}

-(void)DisplayData
{
   [_spinner stopAnimating];
   [_spinner setHidden:YES];
}

-(void)stopActivity
{
    [_spinner stopAnimating];

    _spinner.hidden = TRUE;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //Code for OK button
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)function
{
    [self readTextFromString:@"Please wait while the segmentation is in progress."];
}

-(void)readTextFromString:(NSString*)text
{
    
    AVSpeechUtterance* utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    
    _voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    
    
    
    utterance.voice = _voice;
    
    utterance.pitchMultiplier = 1.1;
    
    utterance.volume = 1;
    
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate;// - (AVSpeechUtteranceDefaultSpeechRate*0.4);//
    
    utterance.preUtteranceDelay = 0;
    
    utterance.postUtteranceDelay = 0;
    
    //AVSpeechUtteranceDefaultSpeechRate - (AVSpeechUtteranceDefaultSpeechRate*0.4);
    
    [_synth speakUtterance:utterance];
    
}


@end
