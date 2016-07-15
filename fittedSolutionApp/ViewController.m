//
//  ViewController.m
//  fittedSolutionApp
//
//  Created by Avinash Singh on 4/9/16.
//  Copyright © 2016 Avinash Singh. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "XMLReader.h"
#import "AppDelegate.h"
//#import "MPVolumeButtons.h"



//

#import <ImageIO/ImageIO.h>

#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <ImageIO/CGImageSource.h>
#import <ImageIO/CGImageProperties.h>

///

//#import <OpenEars/OELogging.h>
//#import <OpenEars/OELanguageModelGenerator.h>
//#import <OpenEars/OEAcousticModel.h>
//#import <OpenEars/OEPocketsphinxController.h>
//#import <OpenEars/OEEventsObserver.h>

#define WINDOWS_IMAGE_UPLOAD_SIDE_SEGMENTATION_URL @"http://207.178.170.24/FittedSolutionsServices.asmx?op=SideFootUploadService"
#define WINDOWS_IMAGE_UPLOAD_FRONT_SEGMENTATION_URL @"http://207.178.170.24/FittedSolutionsServices.asmx?op=FrontFootUploadService"

#define LINUX_URL_FOR_IMAGE_UPLOAD_SIDE_FOOT  @"http://45.55.156.47:5060/detect_side"  //@"http://207.178.170.24:5060/detect_side"
#define LINUX_URL_FOR_IMAGE_UPLOAD_FRONT_FOOT @"http://45.55.156.47:5060/detect_front" //@"http://207.178.170.24:5060/detect_front"

@interface ViewController ()
{
 //    NSString *x1,*y1,*w1,*h1;
 //    NSString *x2,*y2,*w2,*h2;
    
    NSDictionary *dict;
    NSString *frontBody;
    UIView *myView;
    UIActivityIndicatorView *spinner;
    UIImage *sideFootImage;
    UIImage *frontFootImage;
    
    NSString *textToRead;
    NSString *imageName;
    
    int flag;
    int sideFootErrorFlag;
    
    UIButton *btn;
    UIImagePickerController *picker1;
   __block UIImage *myImage ;
    
    NSMutableData    *mutableData;
    NSMutableURLRequest *theRequest;
    NSURLSession *session;
}

@end

@implementation ViewController
{
    int errorFlag;
    
    NSData *postData;
    NSData *postFrontFootData;
    NSData *postSideFootData;
    
    AppDelegate *appDel;
    
    NSString *footId;
    NSString *archDistance;
    NSString *archHeight;
    NSString *footLength;
    NSString *menEuro;
    NSString *menUK;
    NSString *menUS;
    NSString *resultID;
    NSString *sideID;
    NSString *talusHeight;
    NSString *talusSlope;
    NSString *toeBoxHeight;
    NSString *womenEuro;
    NSString *womenUK;
    NSString *womenUS;
    NSString *errorMsg;
    NSString *errorMsg1;
    NSString *footID;
    NSString  *footWidth;
    NSString *menWidthCode;
    NSString *menWidthValue;
    NSString *womenWidthCode;
    NSString  *womenWidthValue;
}

//------- for speech Recognition

NSString *lmPath = nil;
NSString *dicPath = nil;

@synthesize mySnap;

-(void)viewWillAppear:(BOOL)animated
{
    self.title = @"Dashboard";
    
    [spinner stopAnimating];
    
    spinner.hidden = TRUE;
    
    postFrontFootData = [[NSData alloc]init];
    postSideFootData = [[NSData alloc]init];
    
    errorFlag=0;
    
    sideFootErrorFlag =0;
    
    _btnOutlet.hidden  = FALSE;
    _btnOutlet.enabled = TRUE;
    
    mySnap.hidden = TRUE;
    
    _transparentView.hidden = TRUE;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:55/255.0f green:130/255.0f blue:198/255.0f alpha:1.0f] }];
    
    _headerContainerView.hidden = TRUE;
    
    UIImage *menuImage = [UIImage imageNamed:@"menu"];
    
    UIBarButtonItem  *menuBtn = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target:self action:@selector(menuAction)];
    
    
    menuBtn.tintColor =  [UIColor colorWithRed:55/255.0f green:130/255.0f blue:198/255.0f alpha:1.0f];
    // create a spacer
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 0;
    
    NSArray *buttons = @[menuBtn,space];

    self.navigationItem.leftBarButtonItems = buttons;
    
    //---------------
    
    UIImage *homeImage = [UIImage imageNamed:@"infoIcon"];
    
    UIBarButtonItem  *InstructionBtn = [[UIBarButtonItem alloc] initWithImage:homeImage style:UIBarButtonItemStylePlain target:self action:@selector(infoButtonClicked)];
    
    InstructionBtn.tintColor =  [UIColor colorWithRed:55/255.0f green:130/255.0f blue:198/255.0f alpha:1.0f];
    
    // create a spacer
    UIBarButtonItem *space1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 0;
    
    NSArray *buttons1 = @[InstructionBtn,space1];
    
    self.navigationItem.rightBarButtonItems = buttons1;

}

-(void)menuAction
{
    
}

-(void)infoButtonClicked
{
    textToRead = @"take mirror selfie of your foot in two steps.   ";
    
    [self performSelector:@selector(function3) withObject:nil afterDelay:1];
    
    [self performSelector:@selector(function4) withObject:nil afterDelay:1];
    
    
    [self readTextFromString:textToRead];
}

-(void)infoAction
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    flag=0;
    
    
    
    sideFootImage= [[UIImage alloc]init];
    
    frontFootImage = [[UIImage alloc]init];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    //-----------activity Indicator -----------
    
 /*   UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    spinner.frame = CGRectMake(130, 250, 30, 30);
    
    spinner.backgroundColor = [UIColor blueColor];
    
    [spinner startAnimating];
    
    [self.view addSubview:spinner];
  */
    
    
    //----------activity Indicator -------------
    
    NSLog(@"%@", [AVSpeechSynthesisVoice speechVoices] );
    
    // set up our audio session
    _session = [AVAudioSession sharedInstance];
    
    [_session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // set up our TTS synth
       _synth = [[AVSpeechSynthesizer alloc] init];
    
      [_synth setDelegate:self];
    
    [self performSelector:@selector(function) withObject:nil afterDelay:0];
    
      [self performSelector:@selector(function1) withObject:nil afterDelay:1];
    
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takkePicBtnClk:(id)sender {
    
    [self performSelector:@selector(voiceRecognitionSetup) withObject:nil afterDelay:0];
    
    if (flag==1) {
        
        [self takeFrontPic];
    }
    else
    {
        
    _btnOutlet.hidden = TRUE;
        
    _headerContainerView.hidden = FALSE;
    
  //  _headerContainerView.backgroundColor = [UIColor colorWithRed:55/255.0f green:130/255.0f blue:198/255.0f alpha:1.0f];
        
          _headerContainerView.backgroundColor = [UIColor colorWithRed:71/255.0f green:130/255.0f blue:198/255.0f alpha:1.0f];
    
  //  textToRead = @"tap any where on the screen to take the picture";
        
  //  [self readTextFromString:textToRead];
        
        
//   [self performSelector:@selector(voiceRecognitionSetup) withObject:nil afterDelay:5];
        
      
    picker1 = [[UIImagePickerController alloc] init];
    picker1.delegate = self;
    picker1.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker1.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    picker1.showsCameraControls = NO;
    picker1.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
  
    CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 71.0); //This slots the preview exactly in the middle of the screen by moving it down 71 points
    picker1.cameraViewTransform = translate;
    
    CGAffineTransform scale = CGAffineTransformScale(translate, 1.333333, 1.333333);
    picker1.cameraViewTransform = scale;
    
    _headerContainerView.frame = CGRectMake(50, 0, 400, 40);
        
         _headerImage.image = [UIImage imageNamed:@"step1"];
   [picker1.view addSubview:_headerContainerView];
    
      
    
    
    [self presentViewController:picker1 animated:YES
                     completion:^ {
                         
                        
                         
                        btn = [[UIButton alloc]init];
                         
                        btn.enabled = TRUE;
                        btn.frame = CGRectMake(0,80, 375, 470);
                        //btn.backgroundColor = [UIColor redColor];
                         //btn.alpha = 0.5;
                         
                       [btn addTarget:self action:@selector(func5)   forControlEvents:UIControlEventTouchUpInside];
                         UIImage *btnImage = [UIImage imageNamed:@""];
                        
                         
                        [btn setImage:btnImage forState:UIControlStateNormal];
                         
                         UIImageView *appLogo = [[UIImageView alloc]init];
                         
                         appLogo.frame = CGRectMake(110, 280, 26, 26);//x 110
                         
                         appLogo.image = [UIImage imageNamed:@"appLogo"];
                         
                        appLogo.transform =  CGAffineTransformMakeRotation (3.14/2);
                         
                        [picker1.view addSubview:appLogo];
                         
                         
                      
                         UILabel *lbl = [[UILabel alloc]init];
                         
                         lbl.textColor = [UIColor greenColor];
                         
                         lbl.frame = CGRectMake(150, 500, 250, 80);//y 250
                         
                         lbl.numberOfLines =3;
                         
                         lbl.text = @"Locate This Icon \n on the smart phone \n in the mirror" ;
                         
                          lbl.transform =  CGAffineTransformMakeRotation (3.14/2);
                         
                         [picker1.view addSubview:lbl];
                         
                         
                         
                         UILabel *lbl1 = [[UILabel alloc]init];
                         
                         lbl1.textColor = [UIColor blueColor];
                         
                         lbl1.frame = CGRectMake(0, 400, 250, 80);
                         
                         lbl1.numberOfLines =3;
                         
                         lbl1.text = @"Locate This Icon \n on the foot \n in the mirror" ;
                         
                          lbl1 .transform =  CGAffineTransformMakeRotation (3.14/2);
                         
                         [picker1.view addSubview:lbl1];
                         
                         
                         UIImageView *appLogo1 = [[UIImageView alloc]init];
                         
                         appLogo1.frame = CGRectMake(260, 380, 26, 26);///y 425 x:100
                         
                         appLogo1.image = [UIImage imageNamed:@"appLogo"];
                         
                          appLogo1.transform =  CGAffineTransformMakeRotation (3.14/2);
                         
                         [picker1.view addSubview:appLogo1];
                         
                         [picker1.view addSubview:btn];
                         
                         UIButton *btn1 = [UIButton new];
                         btn1.frame = CGRectMake(-20,20, 100, 25);
                         btn1.backgroundColor = [UIColor clearColor];
                         [btn1 addTarget:self action:@selector(buttonClick)   forControlEvents:UIControlEventTouchUpInside];
                         UIImage *backImage = [UIImage imageNamed:@"back"];
                         [btn1 setImage:backImage forState:UIControlStateNormal];
                         
                         [picker1.view addSubview:btn1];

                     }];
        
    }
    
}

-(void)buttonClick
{
    _btnOutlet.enabled = TRUE;
    
    _btnOutlet.hidden = TRUE;
    
    [picker1 dismissViewControllerAnimated:NO completion:nil];
}

-(void)func5
{
    [picker1 takePicture];
}

-(void)takeFrontPic  //takeFrontPic
{
    _headerContainerView.hidden = FALSE;
    _btnOutlet.hidden = TRUE;
    
    flag=1;
    
    picker1 = [[UIImagePickerController alloc] init];
    picker1.delegate = self;
    picker1.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker1.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    picker1.showsCameraControls = NO;
    picker1.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    
    CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 71.0);
    picker1.cameraViewTransform = translate;
    
    CGAffineTransform scale = CGAffineTransformScale(translate, 1.333333, 1.333333);
    picker1.cameraViewTransform = scale;

    
      _headerImage.image = [UIImage imageNamed:@"step2"];
     [picker1.view addSubview:_headerContainerView];

    [self presentViewController:picker1 animated:YES
                     completion:^ {
                         
                         btn = [[UIButton alloc]init];
                         btn.enabled = TRUE;
                         btn.frame = CGRectMake(0,150, 320, 470);
                         btn.backgroundColor = [UIColor clearColor];
                         //  [btn setTitle:@"Play" forState:UIControlStateNormal];
                         [btn addTarget:self action:@selector(func5)   forControlEvents:UIControlEventTouchUpInside];
                         UIImage *btnImage = [UIImage imageNamed:@""];
                         [btn setImage:btnImage forState:UIControlStateNormal];
                         
                         [picker1.view addSubview:btn];
                         
                         UIImageView *appLogo = [[UIImageView alloc]init];
                         appLogo.frame = CGRectMake(250, 260, 26, 26);
                         appLogo.image = [UIImage imageNamed:@"appLogo"];
                         appLogo.transform =  CGAffineTransformMakeRotation (3.14/2);
                         [picker1.view addSubview:appLogo];
                         
                         UILabel *lbl = [[UILabel alloc]init];
                         lbl.textColor = [UIColor greenColor];
                         lbl.frame = CGRectMake(130, 400, 250, 80);
                         lbl.numberOfLines =3;
                         lbl.text = @"Locate This Icon \n on the smart phone \n in the mirror" ;
                         lbl.transform =  CGAffineTransformMakeRotation (3.14/2);
                         [picker1.view addSubview:lbl];
                         
                        
                         UILabel *lbl1 = [[UILabel alloc]init];
                         lbl1.textColor = [UIColor blueColor];
                         lbl1.frame = CGRectMake(10, 400, 250, 80);
                         lbl1.numberOfLines =3;
                         lbl1.text = @"Locate This Icon \n on the foot \n in the mirror" ;
                         lbl1.transform =  CGAffineTransformMakeRotation (3.14/2);
                         [picker1.view addSubview:lbl1];
                         
                         UIImageView *appLogo1 = [[UIImageView alloc]init];
                         appLogo1.frame = CGRectMake(120, 260, 26, 26);
                         appLogo1.image = [UIImage imageNamed:@"appLogo"];
                         appLogo1.transform =  CGAffineTransformMakeRotation (3.14/2);
                         [picker1.view addSubview:appLogo1];
                         

                         UIButton *btn1 = [UIButton new];
                         btn1.frame = CGRectMake(-30,20, 100, 25);
                         btn1.backgroundColor = [UIColor clearColor];
                        [btn1 addTarget:self action:@selector(buttonClick)   forControlEvents:UIControlEventTouchUpInside];
                         
                         
                         UIImage *backImage = [UIImage imageNamed:@"back"];
                         [btn1 setImage:backImage forState:UIControlStateNormal];
                         
                         [self.view addSubview:btn1];
                         [picker1.view addSubview:btn1];
                         
                     }];
}

-(void)asd:(NSData *)imageData
{
    NSData *jpeg = imageData; //UIImageJPEGRepresentation(image, 1); //= [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer] ;
    
    CGImageSourceRef  source ;
    source = CGImageSourceCreateWithData((CFDataRef)jpeg, NULL);
    
    //get all the metadata in the image
    NSDictionary *metadata = (NSDictionary *) CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source,0,NULL));
    
    //make the metadata dictionary mutable so we can add properties to it
    NSMutableDictionary *metadataAsMutable = [metadata mutableCopy];

    
    NSMutableDictionary *EXIFDictionary = [[metadataAsMutable objectForKey:(NSString *)kCGImagePropertyExifDictionary]mutableCopy];
    NSMutableDictionary *GPSDictionary = [[metadataAsMutable objectForKey:(NSString *)kCGImagePropertyGPSDictionary]mutableCopy];
    if(!EXIFDictionary) {
        //if the image does not have an EXIF dictionary (not all images do), then create one for us to use
        EXIFDictionary = [NSMutableDictionary dictionary];
    }
    if(!GPSDictionary) {
        GPSDictionary = [NSMutableDictionary dictionary];
    }
    
    //Setup GPS dict
    
    
//    [GPSDictionary setValue:[NSNumber numberWithFloat:_lat] forKey:(NSString*)kCGImagePropertyGPSLatitude];
//    [GPSDictionary setValue:[NSNumber numberWithFloat:_lon] forKey:(NSString*)kCGImagePropertyGPSLongitude];
//    [GPSDictionary setValue:lat_ref forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
//    [GPSDictionary setValue:lon_ref forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
//    [GPSDictionary setValue:[NSNumber numberWithFloat:_alt] forKey:(NSString*)kCGImagePropertyGPSAltitude];
//    [GPSDictionary setValue:[NSNumber numberWithShort:alt_ref] forKey:(NSString*)kCGImagePropertyGPSAltitudeRef];
//    [GPSDictionary setValue:[NSNumber numberWithFloat:_heading] forKey:(NSString*)kCGImagePropertyGPSImgDirection];
//    [GPSDictionary setValue:[NSString stringWithFormat:@"%c",_headingRef] forKey:(NSString*)kCGImagePropertyGPSImgDirectionRef];
    
//    [EXIFDictionary setValue:xml forKey:(NSString *)kCGImagePropertyExifUserComment];
    
    //add our modified EXIF data back into the image’s metadata
    [metadataAsMutable setObject:EXIFDictionary forKey:(NSString *)kCGImagePropertyExifDictionary];
    [metadataAsMutable setObject:GPSDictionary forKey:(NSString *)kCGImagePropertyGPSDictionary];
    
    CFStringRef UTI = CGImageSourceGetType(source); //this is the type of image (e.g., public.jpeg)
    
    //this will be the data CGImageDestinationRef will write into
    NSMutableData *dest_data = [NSMutableData data];
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((CFMutableDataRef)dest_data,UTI,1,NULL);
    
    if(!destination) {
        NSLog(@"***Could not create image destination ***");
    }
    
    //add the image contained in the image source to the destination, overidding the old metadata with our modified metadata
    CGImageDestinationAddImageFromSource(destination,source,0, (CFDictionaryRef) metadataAsMutable);
    
    //tell the destination to write the image data and metadata into our data object.
    //It will return false if something goes wrong
    BOOL success = NO;
    success = CGImageDestinationFinalize(destination);
    
    if(!success) {
        NSLog(@"***Could not create data from image destination ***");
    }
    
    //now we have the data ready to go, so do whatever you want with it
    //here we just write it to disk at the same path we were passed
    //[dest_data writeToFile:file atomically:YES];
    
    //cleanup
    
    CFRelease(destination);
    CFRelease(source);
}


-(void)asd_Or:(NSData *)imageData
{
    NSData *jpeg = imageData; //UIImageJPEGRepresentation(image, 1); //= [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer] ;
    
    CGImageSourceRef  source ;
    source = CGImageSourceCreateWithData((CFDataRef)jpeg, NULL);
    
    //get all the metadata in the image
    NSDictionary *metadata = (NSDictionary *) CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source,0,NULL));
    
    //make the metadata dictionary mutable so we can add properties to it
    NSMutableDictionary *metadataAsMutable = [metadata mutableCopy];
    
    
    NSMutableDictionary *EXIFDictionary = [[metadataAsMutable objectForKey:(NSString *)kCGImagePropertyExifDictionary]mutableCopy];
    NSMutableDictionary *GPSDictionary = [[metadataAsMutable objectForKey:(NSString *)kCGImagePropertyGPSDictionary]mutableCopy];
    if(!EXIFDictionary) {
        //if the image does not have an EXIF dictionary (not all images do), then create one for us to use
        EXIFDictionary = [NSMutableDictionary dictionary];
    }
    if(!GPSDictionary) {
        GPSDictionary = [NSMutableDictionary dictionary];
    }
    
    //Setup GPS dict
    
    
    //    [GPSDictionary setValue:[NSNumber numberWithFloat:_lat] forKey:(NSString*)kCGImagePropertyGPSLatitude];
    //    [GPSDictionary setValue:[NSNumber numberWithFloat:_lon] forKey:(NSString*)kCGImagePropertyGPSLongitude];
    //    [GPSDictionary setValue:lat_ref forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
    //    [GPSDictionary setValue:lon_ref forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
    //    [GPSDictionary setValue:[NSNumber numberWithFloat:_alt] forKey:(NSString*)kCGImagePropertyGPSAltitude];
    //    [GPSDictionary setValue:[NSNumber numberWithShort:alt_ref] forKey:(NSString*)kCGImagePropertyGPSAltitudeRef];
    //    [GPSDictionary setValue:[NSNumber numberWithFloat:_heading] forKey:(NSString*)kCGImagePropertyGPSImgDirection];
    //    [GPSDictionary setValue:[NSString stringWithFormat:@"%c",_headingRef] forKey:(NSString*)kCGImagePropertyGPSImgDirectionRef];
    
    //    [EXIFDictionary setValue:xml forKey:(NSString *)kCGImagePropertyExifUserComment];
    
    //add our modified EXIF data back into the image’s metadata
    [metadataAsMutable setObject:EXIFDictionary forKey:(NSString *)kCGImagePropertyExifDictionary];
    [metadataAsMutable setObject:GPSDictionary forKey:(NSString *)kCGImagePropertyGPSDictionary];
    //or
    CFStringRef UTI = CGImageSourceGetType(source); //this is the type of image (e.g., public.jpeg)
    
    //this will be the data CGImageDestinationRef will write into
    NSMutableData *dest_data = [NSMutableData data];
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((CFMutableDataRef)dest_data,UTI,1,NULL);
    
    if(!destination) {
        NSLog(@"***Could not create image destination ***");
    }
    
    //add the image contained in the image source to the destination, overidding the old metadata with our modified metadata
    CGImageDestinationAddImageFromSource(destination,source,0, (CFDictionaryRef) metadataAsMutable);
    
    //tell the destination to write the image data and metadata into our data object.
    //It will return false if something goes wrong
    BOOL success = NO;
    success = CGImageDestinationFinalize(destination);
    
    if(!success) {
        NSLog(@"***Could not create data from image destination ***");
    }
    
    //now we have the data ready to go, so do whatever you want with it
    //here we just write it to disk at the same path we were passed
    //[dest_data writeToFile:file atomically:YES];
    
    //cleanup
    
    CFRelease(destination);
    CFRelease(source);
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
   // UIImage *myImage = [info objectForKey:UIImagePickerControllerEditedImage];  //  self.mySnap.image = chosenImage;

//    self.mySnap.image = [UIImage imageNamed:@"sideFoot.jpg"];
//    
//    [picker dismissViewControllerAnimated:YES completion:^{
//        self.mySnap.image = [UIImage imageNamed:@"sideFoot.jpg"];
//    }];
    
    
    self.mySnap.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        self.mySnap.image = [info objectForKey:UIImagePickerControllerEditedImage];
        self.mySnap.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [[OEPocketsphinxController sharedInstance] stopListening];
        
        //NSData *data = UIImageJPEGRepresentation(self.mySnap.image, 1);
        //[self asd_Or:data];
        
        UIImage * originalImage = (UIImage *) [info objectForKey:  UIImagePickerControllerOriginalImage];
        NSDictionary *imageMetadata = [info objectForKey: UIImagePickerControllerMediaMetadata];
        NSLog(@"Metadata Exif Orientation: %@   UIImageOrientation %ld", imageMetadata[(NSString*)kCGImagePropertyOrientation],   (long)originalImage.imageOrientation);

     }];
    
    if (flag==0) {
        
        myView = [[UIView alloc]init];
        
        myView.frame = CGRectMake(0, 66, 400, 600);
        
        myView.backgroundColor = [UIColor blackColor];
        
        myView.alpha =0.5;
        
       // [self.view addSubview:myView];

        
      ///  _btnOutlet.hidden = YES;
        
        imageName = @"SideFeet.jpg";
        
        [appDel addactivity];
        
        appDel.mySpinner.frame = CGRectMake(150, 260, 30, 30);
        appDel.mySpinner.color = [UIColor blueColor];
        [appDel.mySpinner startAnimating];

        [self performSelectorInBackground:@selector(validateImage) withObject:nil];
    
    }
    else if(flag==1)
    {
        [appDel addactivity];
        
         appDel.mySpinner.frame = CGRectMake(150, 260, 30, 30);
         appDel.mySpinner.color = [UIColor blueColor];
         [appDel.mySpinner startAnimating];

   
        _btnOutlet.hidden = TRUE;
        _btnOutlet.enabled = TRUE;

        imageName = @"FrontFoot.jpg";
   
        [self performSelectorInBackground:@selector(validateImage) withObject:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if (flag==1)
        {
            [appDel addactivity];
            [self performSelectorInBackground:@selector(sideSegmentationProcess) withObject:nil];
            [self takeFrontPic];
        }
        else if (flag==2)
        {
           [self Upload_Front_Segmentation:postFrontFootData xGrid:appDel.x2 yGrid:appDel.y2 wGrid:appDel.w2 hGrid:appDel.h2];
        }
        else if(flag==3)
        {
            myView.hidden = TRUE;
            
            flag=0;
            
            footDescription *myFootData=  [self.storyboard instantiateViewControllerWithIdentifier:@"footView"];
            
            myFootData.footLength = footLength;
            myFootData.footWidth = footWidth;
            myFootData.archDistance = archDistance;
            myFootData.archHeight = archHeight;
            myFootData.talusSlope = talusSlope;
            myFootData.talusHeight = talusHeight;
            myFootData.toeBoxHeight = toeBoxHeight;
            myFootData.menEuro = menEuro;
            myFootData.menUK = menUK;
            myFootData.menUS = menUS;
            myFootData.womenEuro = womenEuro;
            myFootData.womenUK = womenUK;
            myFootData.womenUS = womenUS;
            myFootData.menWidthCode = menWidthCode;
            myFootData.menWidthValue = menWidthValue;
            myFootData.womenWidthCode = womenWidthCode;
            myFootData.womenWidthValue = womenWidthValue;
            
            [appDel removeActivity];
            
            [self.navigationController pushViewController:myFootData animated:YES];//87
        }
        else if (sideFootErrorFlag==1)
        {
            sideFootErrorFlag=0;
            flag = 0;
            [picker1 dismissViewControllerAnimated:YES completion:NULL];
        }
    }
   
}

-(void)cancel
{
    [picker1 dismissViewControllerAnimated:YES completion:NULL];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    flag=0;
    
    _btnOutlet.enabled = TRUE;


    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - AVSpeechSynthesizerDelegate

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance
{
    
    
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance;
{
    
}

-(void)readTextFromString:(NSString*)text
{
    
    AVSpeechUtterance* utterance = [AVSpeechUtterance speechUtteranceWithString:textToRead];
    
    _voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    
    
    
    utterance.voice = _voice;
    
    utterance.pitchMultiplier = 1.1;
    
    utterance.volume = 1;
    
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate;
    
    utterance.preUtteranceDelay = 0;
    
    utterance.postUtteranceDelay = 0;
    
    [_synth speakUtterance:utterance];
    
}
-(void)function
{
    textToRead = @"welcome to fitted solution.";
    
    [self readTextFromString:textToRead];

}

-(void)function1
{
    textToRead = @"tap on info for App Instructions.";
    
    [self readTextFromString:textToRead];
    
}

-(void)function3
{
    textToRead = @"step1 : take front snap of your foot .";
    
    [self readTextFromString:textToRead];
    
}

-(void)function4
{
    textToRead = @"step 2 take side snap of your foot.";
    
    [self readTextFromString:textToRead];
    
}

-(void)function5
{
    textToRead = @"please ensure that your feet is inside the feet grid outlines";
    
    [self readTextFromString:textToRead];
}

- (IBAction)infoBtnClk:(id)sender {
    
    textToRead = @"take mirror selfie of your foot in two steps.   ";
    
    [self performSelector:@selector(function3) withObject:nil afterDelay:1];
    
    [self performSelector:@selector(function4) withObject:nil afterDelay:1];

    [self readTextFromString:textToRead];
}
- (IBAction)btnTap:(id)sender {
    
      [picker1 takePicture];
}

- (void)startListening {
    
}

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID
{
    NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    
    //int score = [recognitionScore intValue];
    
    if ([hypothesis isEqualToString:@"CLICK"])
    {
         [picker1 takePicture];
    }
}

- (void) pocketsphinxDidStartListening {
    NSLog(@"Pocketsphinx is now listening.");
}

- (void) pocketsphinxDidDetectSpeech {
    NSLog(@"Pocketsphinx has detected speech.");
}

- (void) pocketsphinxDidDetectFinishedSpeech {
    NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
}

- (void) pocketsphinxDidStopListening {
    NSLog(@"Pocketsphinx has stopped listening.");
}

- (void) pocketsphinxDidSuspendRecognition {
    NSLog(@"Pocketsphinx has suspended recognition.");
}

- (void) pocketsphinxDidResumeRecognition {
    NSLog(@"Pocketsphinx has resumed recognition.");
}

- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
    NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

- (void) pocketSphinxContinuousSetupDidFailWithReason:(NSString *)reasonForFailure {
    NSLog(@"Listening setup wasn't successful and returned the failure reason: %@", reasonForFailure);
}

- (void) pocketSphinxContinuousTeardownDidFailWithReason:(NSString *)reasonForFailure {
    NSLog(@"Listening teardown wasn't successful and returned the failure reason: %@", reasonForFailure);
}

- (void) testRecognitionCompleted {
    NSLog(@"A test file that was submitted for recognition is now complete.");
}





-(void)drawBoxOnImage:(UIImage *)image :(int)x :(int)y :(int)w :(int)h
{
    // begin a graphics context of sufficient size
    UIGraphicsBeginImageContext(image.size);
    
    // draw original image into the context
    [image drawAtPoint:CGPointZero];
    
    // get the context for CoreGraphics
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // set stroking color and draw circle
    [[UIColor whiteColor] setStroke];
    
    
    // make circle rect 5 px from border
    CGRect circleRect = CGRectMake(x, y,
                                   w,
                                   h);
    circleRect = CGRectInset(circleRect, 50, 50);
    
    // draw rectangle
    
//    CGContextStrokeEllipseInRect(ctx, circleRect);
    CGContextStrokeRect(ctx, circleRect);
    
    
    //// write text on image
    NSString *text = [NSString stringWithFormat:@"x: %d, y: %d, w: %d, h: %d",x,y,w,h];
    UIFont *font = [UIFont boldSystemFontOfSize:100];
    //[image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(x, y-50, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    [text drawInRect:CGRectIntegral(rect) withFont:font];
    ///
    
    
    
    
    // make image out of bitmap context
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // free the context
    UIGraphicsEndImageContext();
    
    
    
    
    
    UIImageWriteToSavedPhotosAlbum(retImage, self, nil, nil);

}

//BOOL firstTryOfSecondStep;

-(void)uploadImageData1:(NSData *)imageData forFootSide:(NSString *)footSide
{
    NSString * deviceScreenResolution = [NSString stringWithFormat:@"%.1f*%.1f",[app_manager getDeviceScreenSizeInPixels].width , [app_manager getDeviceScreenSizeInPixels].height];
    
    // Dictionary that holds post parameters. You can set your post parameters that your server accepts or programmed to accept.
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];

    [_params setObject:[NSString stringWithFormat:@"%@", [app_manager getDeviceID]]         forKey:[NSString stringWithString:@"deviceId"]];
    [_params setObject:[NSString stringWithFormat:@"%@", [app_manager getDeviceiOSVersion]] forKey:[NSString stringWithString:@"deviceiOSVersion"]];
    [_params setObject:[NSString stringWithFormat:@"%@", deviceScreenResolution]            forKey:[NSString stringWithString:@"deviceScreenResolution"]];
    
    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = [NSString stringWithString:@"----------V2ymHFg03ehbqgZCaKO6jy"];
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    NSString* FileParamConstant = [NSString stringWithString:@"file"];
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL;
    if ([footSide isEqualToString:@"side"])
    {
        requestURL = [NSURL URLWithString:LINUX_URL_FOR_IMAGE_UPLOAD_SIDE_FOOT];
    }
    else
    {
        requestURL = [NSURL URLWithString:LINUX_URL_FOR_IMAGE_UPLOAD_FRONT_FOOT];
    }
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in _params)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    //NSData *imageData = UIImageJPEGRepresentation(imageToPost, 1.0);

    if (imageData)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:requestURL];

    
    NSHTTPURLResponse   *response = nil;
    NSError         *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
}

-(void)uploadImageData2:(NSData *)imageData forFootSide:(NSString *)footSide
{
    NSString * deviceID               = [app_manager getDeviceID];
    NSString * deviceScreenResolution = [NSString stringWithFormat:@"%.1f*%.1f",[app_manager getDeviceScreenSizeInPixels].width , [app_manager getDeviceScreenSizeInPixels].height];
    NSString * deviceiOSVersion       = [app_manager getDeviceiOSVersion];
    
    // Build the request body
    NSString *boundary = @"SportuondoFormBoundary";
    NSMutableData *body = [NSMutableData data];
    
    // Body part for "deviceId" parameter. This is a string.
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"deviceId"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", deviceID] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Body part for "deviceiOSVersion" parameter. This is a string.
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"deviceiOSVersion"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", deviceiOSVersion] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Body part for "deviceScreenResolution" parameter. This is a string.
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"deviceScreenResolution"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", deviceScreenResolution] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Body part for the attachament. This is an image.
    //NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"ranking"], 0.6);
    
    if (imageData)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"image"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Setup the session
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"api-key"       : @"55e76dc4bbae25b066cb",
                                                   @"Accept"        : @"application/json",
                                                   @"Content-Type"  : [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
                                                   };
    
    // Create the session
    // We can use the delegate to track upload progress
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    
    // Data uploading task. We could use NSURLSessionUploadTask instead of NSURLSessionDataTask if we needed to support uploads in the background
    NSURL *url ;
    
    if ([footSide isEqualToString:@"side"])
    {
        url = [NSURL URLWithString:LINUX_URL_FOR_IMAGE_UPLOAD_SIDE_FOOT];
    }
    else
    {
        url = [NSURL URLWithString:LINUX_URL_FOR_IMAGE_UPLOAD_FRONT_FOOT];
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = body;
    NSURLSessionDataTask *uploadTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // Process the response
    }];
    [uploadTask resume];
}


-(void)validateImage
{
    if (flag==0)  // validating side  foot camera image  from linux server
    {
        CGSize constraint = CGSizeMake(3264,2448);
        
        //NSLog(@"original snap orientation : %ld",(long)self.mySnap.image.imageOrientation);
        
        //UIImage *testImage = [self.mySnap.image resizedImage:constraint interpolationQuality:kCGInterpolationHigh];
        //NSLog(@"TestImage orientation : %ld",(long)testImage.imageOrientation);
        
        UIImage *newImage = [self scaleImage:self.mySnap.image toSize:constraint];
        //NSLog(@"newImage orientation : %ld",(long)newImage.imageOrientation);
        
        postSideFootData = UIImageJPEGRepresentation(newImage, 1.0);//0.01
        
        UIImage *scaledCameraImage = [UIImage imageWithData:postSideFootData];
        //NSLog(@"scaledCameraImage orientation : %ld",(long)scaledCameraImage.imageOrientation);
        
        
        ///////
        //NSData *testdata = UIImageJPEGRepresentation(testImage, 1.0);
        //[self asd:testdata];
        ///////
        
        UIImageWriteToSavedPhotosAlbum(scaledCameraImage, self, nil, nil);
        
        NSLog(@"image size ===== %lu",(unsigned long)postSideFootData.length);
        
        sideFootImage = self.mySnap.image;
        
        NSData *Data = UIImagePNGRepresentation(sideFootImage);
        
        NSLog(@"origunal size of Image : %lu",(unsigned long)Data.length);

        NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postSideFootData length]];
    
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        NSLog(@"url for side foot %@",LINUX_URL_FOR_IMAGE_UPLOAD_SIDE_FOOT);
        [request setURL:[NSURL URLWithString:LINUX_URL_FOR_IMAGE_UPLOAD_SIDE_FOOT]]; //@"http://207.178.170.24:5060/detect_side"
        
        [request setHTTPMethod:@"POST"];
        
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        
        [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:postSideFootData];
        
        NSHTTPURLResponse   *response = nil;
        
        NSError         *error = nil;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSString * convertedStr =[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        NSLog(@"grid values from linux server : %@",convertedStr);
        
        if ([convertedStr intValue]!=0)
        {
            NSLog(@"Converted String = %@",convertedStr);
            
            NSArray *contentArr = [[NSArray alloc]init];
            
            contentArr = [convertedStr componentsSeparatedByString:@"("];
            
            NSString *str = [[[contentArr objectAtIndex:1]componentsSeparatedByString:@")"]objectAtIndex:0];
            
            NSArray *locArr = [[NSArray alloc]init];
            
            locArr = [str componentsSeparatedByString:@","];
            
            NSLog(@"grid aray : %@",locArr);
            
            NSLog(@"response from srever ::: %@",contentArr);
            
            if ([[contentArr objectAtIndex:0]intValue]==1)
            {
                
                UIImageWriteToSavedPhotosAlbum(scaledCameraImage, self, nil, nil);//self.mySnap.image

                
                NSLog(@"parameter : %@",str);
                NSLog(@"side foot linux param x :%@ ,y :%@ ,w :%@ ,h :%@",[locArr objectAtIndex:0],[locArr objectAtIndex:1],[locArr objectAtIndex:2],[locArr objectAtIndex:3]);
                
                
                appDel.x1=  [[[locArr objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] intValue];
                appDel.y1=  [[[locArr objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] intValue];
                appDel.w1=  [[[locArr objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] intValue];
                appDel.h1 = [[[locArr objectAtIndex:3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] intValue];
                
                [self drawBoxOnImage:scaledCameraImage :appDel.x1 :appDel.y1 :appDel.w1 :appDel.h1];
                
                NSLog(@"x : %d",[[[locArr objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] intValue]);
                NSLog(@"y : %d",[[[locArr objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] intValue]);
                NSLog(@"w : %d",[[[locArr objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] intValue]);
                NSLog(@"h : %d",[[[locArr objectAtIndex:3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] intValue]);

                
                frontFootImage = self.mySnap.image;
                
                flag=1;
                
                NSString *stringWithSideGrid = [NSString stringWithFormat:@"sideX:%d | sideY:%d | sideW:%d | sideH: %d",appDel.x1,appDel.y1,appDel.w1,appDel.h1];
                
                
                
              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fitted Solutions SideFoot"
                                                                message:stringWithSideGrid
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
               
                
             /*   
              
              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🎁 Fitted Solutions 🎁"
                                                                message:@"Side Foot Picture seems good .press OK to take the front snap of feet \n\n "
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
              
              */
                
            

            }
            else if([[contentArr objectAtIndex:0]intValue]==0||[[contentArr objectAtIndex:0]intValue]<0)
            {
                
                NSLog(@"Retake");
                
                 [appDel removeActivity];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🎁 Fitted Solutions 🎁"
                                                                message:@"Sorry side picture of foot seems invalid please press OK to retake the picture"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
             
                flag=0;
                
            }
        }
        else
        {
            [appDel removeActivity];
            
            NSLog(@"linux server response : %@",convertedStr);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🎁 Fitted Solutions 🎁"
                                                            message:@"Sorry side picture of foot seems invalid please press OK to retake the picture"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            flag=0;
            
            picker1 = [[UIImagePickerController alloc] init];
            picker1.delegate = self;
            
            picker1.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker1.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            picker1.showsCameraControls = NO;
            picker1.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            
            CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 71.0);
            picker1.cameraViewTransform = translate;
            
            CGAffineTransform scale = CGAffineTransformScale(translate, 1.333333, 1.333333);
            picker1.cameraViewTransform = scale;
            
            _headerContainerView.frame = CGRectMake(50, 0, 400, 40);
            
            _headerImage.image = [UIImage imageNamed:@"step1"];
            [picker1.view addSubview:_headerContainerView];
            
            
            
            [self presentViewController:picker1 animated:YES
                             completion:^ {
                                 
                                 btn = [[UIButton alloc]init];
                                 btn.enabled = TRUE;
                                 btn.frame = CGRectMake(0,80, 375, 470);
                                 btn.backgroundColor = [UIColor clearColor];
                              
                                 [btn addTarget:self action:@selector(func5)   forControlEvents:UIControlEventTouchUpInside];
                                 UIImage *btnImage = [UIImage imageNamed:@""];
                                 
                                 
                                 [btn setImage:btnImage forState:UIControlStateNormal];
                                 
                                 UIImageView *appLogo = [[UIImageView alloc]init];
                                 
                                 appLogo.frame = CGRectMake(110, 280, 26, 26);
                                 
                                 appLogo.image = [UIImage imageNamed:@"appLogo"];
                                 
                                 appLogo.transform =  CGAffineTransformMakeRotation (3.14/2);

                                 
                                 [picker1.view addSubview:appLogo];
                                 
                                 
                                 
                                 UILabel *lbl = [[UILabel alloc]init];
                                 
                                 lbl.textColor = [UIColor greenColor];
                                 
                                 lbl.frame = CGRectMake(150, 500, 250, 80);
                                 
                                 lbl.numberOfLines =3;
                                 
                                 lbl.text = @"Locate This Icon \n on the smart phone \n in the mirror" ;
                                 
                                 lbl.transform =  CGAffineTransformMakeRotation (3.14/2);

                                 
                                 [picker1.view addSubview:lbl];
                                 
                                 
                                 
                                 UILabel *lbl1 = [[UILabel alloc]init];
                                 
                                 lbl1.textColor = [UIColor blueColor];
                                 
                                 lbl1.frame = CGRectMake(0, 400, 250, 80);
                                 
                                 lbl1.numberOfLines =3;
                                 
                                 lbl1.text = @"Locate This Icon \n on the foot \n in the mirror" ;
                                 
                                 lbl1.transform =  CGAffineTransformMakeRotation (3.14/2);

                                 
                                 [picker1.view addSubview:lbl1];
                                 
                                 
                                 UIImageView *appLogo1 = [[UIImageView alloc]init];
                                 
                                 appLogo1.frame = CGRectMake(260, 380, 26, 26);
                                 
                                 appLogo1.image = [UIImage imageNamed:@"appLogo"];
                                 
                                 appLogo1.transform =  CGAffineTransformMakeRotation (3.14/2);

                                 
                                 [picker1.view addSubview:appLogo1];
                             
                                 
                                 [picker1.view addSubview:btn];
                                 
                                 UIButton *btn1 = [UIButton new];
                                 btn1.frame = CGRectMake(-20,20, 100, 25);
                                 btn1.backgroundColor = [UIColor clearColor];
                                 [btn1 addTarget:self action:@selector(buttonClick)   forControlEvents:UIControlEventTouchUpInside];
                                 UIImage *backImage = [UIImage imageNamed:@"back"];
                                 [btn1 setImage:backImage forState:UIControlStateNormal];
                                 
                                [picker1.view addSubview:btn1];
                                 
                             }];

            
        }
    
        
    }
    else if (flag==1)  // validating  camera front foot image from linux server
    {
        /*
        if (!firstTryOfSecondStep) 
        {
            firstTryOfSecondStep = TRUE;
        }
        else
        {
            self.mySnap.image = [UIImage imageNamed:@"frontFoot.jpg"] ;
        }
        */
    
        
        CGSize constraint = CGSizeMake(3264,2448);
        
        UIImage *newImage = [self scaleImage:self.mySnap.image toSize:constraint];
        
        postFrontFootData = UIImageJPEGRepresentation(newImage, 1.0f);
        
        UIImage *scaledCameraImage = [UIImage imageWithData:postFrontFootData];
        
        UIImageWriteToSavedPhotosAlbum(scaledCameraImage, self, nil, nil);//self.mySnap.image
        
        //NSLog(@"image ===== %@",postFrontFootData);
        
        frontFootImage = self.mySnap.image;
        
        NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postFrontFootData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:LINUX_URL_FOR_IMAGE_UPLOAD_FRONT_FOOT]];  //@"http://207.178.170.24:5060/detect_front"
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];//octet-stream x-www-form-urlencoded
        [request setHTTPBody:postFrontFootData];
        
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        NSHTTPURLResponse   *response = nil;
        NSError         *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        
        NSString * convertedStr =[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        NSLog(@"Converted String = %@",convertedStr);
        
        
        if ([convertedStr intValue]!=0)
        {
            
            NSArray *contentArr = [[NSArray alloc]init];
            
            contentArr = [convertedStr componentsSeparatedByString:@"("];
            
            NSString *str = [[[contentArr objectAtIndex:1]componentsSeparatedByString:@")"]objectAtIndex:0];
            
            NSArray *locArr = [[NSArray alloc]init];
            
            locArr = [str componentsSeparatedByString:@","];
            
            NSLog(@"response from srever ::: %@",contentArr);

            
            //----------------
        
            if ([[contentArr objectAtIndex:0]intValue]==1)
            {
                
                 //  [appDel removeActivity];
                
                UIImageWriteToSavedPhotosAlbum(scaledCameraImage, self, nil, nil);//self.mySnap.image
                
                NSLog(@"parameter : %@",str);
                
                NSLog(@"x:%@ ,y:%@ ,w:%@ ,h:%@",[locArr objectAtIndex:0],[locArr objectAtIndex:1],[locArr objectAtIndex:2],[locArr objectAtIndex:3]);
                
                frontFootImage = self.mySnap.image;
                
               appDel.x2= [[locArr objectAtIndex:0] intValue];
               appDel.y2 = [[locArr objectAtIndex:1] intValue];
               appDel.w2 = [[locArr objectAtIndex:2]intValue];
               appDel.h2 = [[locArr objectAtIndex:3] intValue];
                
                [self drawBoxOnImage:scaledCameraImage :appDel.x2 :appDel.y2 :appDel.w2 :appDel.h2];
                
              //  flag=3;//2
                
                flag=2;
                
                 NSString *stringWithFrontGrid = [NSString stringWithFormat:@"frontX:%d | frontX:%d | frontX:%d | frontX: %d",appDel.x2,appDel.y2,appDel.w2,appDel.h2];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fitted Solutions frontFoot"
                                                                message:stringWithFrontGrid
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];

                
             /*   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🎁 Fitted Solutions 🎁"
                                                                message:@"Front Foot Picture seems good .press OK to upload the image to windows server."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                */
            }
            else if([[contentArr objectAtIndex:0]intValue]==0||[[contentArr objectAtIndex:0]intValue]<0)
            {
                
                NSLog(@"Retake");
                
                 [appDel removeActivity];
                
                flag=1;
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🎁 Fitted Solutions 🎁"
                                                                message:@"Sorry Front Foot picture of foot seems invalid please press OK to retake the picture"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                [self takeFrontPic];
                
            }
        }
        else
        {
             [appDel removeActivity];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🎁 Fitted Solutions 🎁"
                                                            message:@"Sorry Front Foot picture of foot seems invalid please press OK to retake the picture"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
            NSLog(@"Retake");
            
            flag=1;
            
            [self takeFrontPic];
            
        }
    }

}



//--------
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

-(void)sideSegmentationProcess
{
    [self Upload_Side_Segmentation:postSideFootData xGrid:appDel.x1 yGrid:appDel.y1 wGrid:appDel.w1 hGrid:appDel.h1];
}

-(void)Upload_Side_Segmentation:(NSData*)imgData xGrid:(int)X1 yGrid:(int)Y1 wGrid:(int)W1  hGrid:(int)H1
{
    UIImage *scaledCameraImage = [UIImage imageWithData:imgData];
    
    UIImageWriteToSavedPhotosAlbum(scaledCameraImage, self, nil, nil);//self.mySnap.image

    
  //   UIImageWriteToSavedPhotosAlbum(scaledCameraImage, self, nil, nil);//self.mySnap.image
    
    NSLog(@"upload side x : %d  y : %d  w : %d  h : %d",X1,Y1,W1,H1);
    
    
    NSDictionary *headers = @{ @"SOAPAction": @"http://tempuri.org/SideFootUploadService",
                               @"content-type": @"text/xml; charset=utf-8",
                               @"cache-control": @"no-cache",
                               };
    
    NSString *base64String = [imgData base64Encoding];
    
    NSData *segmentData = [[NSData alloc] initWithData:[[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><SideFootUploadService xmlns=\"http://tempuri.org/\"><Image>%@</Image><pointA>%d</pointA><pointB>%d</pointB><pointC>%d</pointC><pointD>%d</pointD></SideFootUploadService></soap:Body></soap:Envelope>",base64String,appDel.x1,appDel.y1,appDel.w1,appDel.h1] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:WINDOWS_IMAGE_UPLOAD_SIDE_SEGMENTATION_URL]   cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:segmentData];
    [request setTimeoutInterval:5*60];
    
    session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
    if (error)
    {
        NSLog(@"%@", error);
    }
    else
    {
        NSDictionary *dict1 = [XMLReader dictionaryForXMLData:data
                                                     options:XMLReaderOptionsProcessNamespaces
                                                       error:&error];
                                                            
                                                            
         NSLog(@"final response : %@",dict1);
        
          errorMsg = [[[[[[dict1 valueForKey:@"Envelope"]valueForKey:@"Body"]valueForKey:@"SideFootUploadServiceResponse"]valueForKey:@"SideFootUploadServiceResult"]valueForKey:@"ErrorMessage"]valueForKey:@"text"];
        
        NSLog(@"error message : %@",errorMsg);
        
        if ([errorMsg length]!=0)
        {
            [self performSelectorOnMainThread:@selector(DisplayError) withObject:nil waitUntilDone:NO];
        }
        else
        {
            archDistance = [[[[[[dict1 valueForKey:@"Envelope"]valueForKey:@"Body"]valueForKey:@"SideFootUploadServiceResponse"]valueForKey:@"SideFootUploadServiceResult"]valueForKey:@"ArchDistance"]valueForKey:@"text"];;
                
                    
            archHeight = [[[[[[dict1 valueForKey:@"Envelope"]valueForKey:@"Body"]valueForKey:@"SideFootUploadServiceResponse"]valueForKey:@"SideFootUploadServiceResult"]valueForKey:@"ArchHeight"]valueForKey:@"text"];
                                                                    

                                                                    
            footLength = [[[[[[dict1 valueForKey:@"Envelope"]valueForKey:@"Body"]valueForKey:@"SideFootUploadServiceResponse"]valueForKey:@"SideFootUploadServiceResult"]valueForKey:@"FootLength"]valueForKey:@"text"];
                                                                    

                                                                    
            menEuro = [[[[[[dict1 valueForKey:@"Envelope"]valueForKey:@"Body"]valueForKey:@"SideFootUploadServiceResponse"]valueForKey:@"SideFootUploadServiceResult"]valueForKey:@"MenEuro"]valueForKey:@"text"];
                                                                    

                                                                    
            menUK = [[[[[[dict1 valueForKey:@"Envelope"]valueForKey:@"Body"]valueForKey:@"SideFootUploadServiceResponse"]valueForKey:@"SideFootUploadServiceResult"]valueForKey:@"MenUK"]valueForKey:@"text"];
                                                                    

                                                                    
            menUS = [[[[[[dict1 valueForKey:@"Envelope"]valueForKey:@"Body"]valueForKey:@"SideFootUploadServiceResponse"]valueForKey:@"SideFootUploadServiceResult"]valueForKey:@"MenUS"]valueForKey:@"text"];
                                                                    
                    
            resultID = [[[[[[dict1 valueForKey:@"Envelope"]valueForKey:@"Body"]valueForKey:@"SideFootUploadServiceResponse"]valueForKey:@"SideFootUploadServiceResult"]valueForKey:@"ResultID"]valueForKey:@"text"];
                                                                    
                    
            sideID = [[[[[[dict1 valueForKey:@"Envelope"]valueForKey:@"Body"]valueForKey:@"SideFootUploadServiceResponse"]valueForKey:@"SideFootUploadServiceResult"]valueForKey:@"SideID"]valueForKey:@"text"];
                                                                    
                    
            talusHeight = [[[[[[dict1 valueForKey:@"Envelope"]valueForKey:@"Body"]valueForKey:@"SideFootUploadServiceResponse"]valueForKey:@"SideFootUploadServiceResult"]valueForKey:@"TalusHeight"]valueForKey:@"text"];
                                                                    
                    
            talusSlope = [[[[[[dict1 valueForKey:@"Envelope"]valueForKey:@"Body"]valueForKey:@"SideFootUploadServiceResponse"]valueForKey:@"SideFootUploadServiceResult"]valueForKey:@"TalusSlope"]valueForKey:@"text"];
                                                                    
                    
            toeBoxHeight = [[[[[[dict1 valueForKey:@"Envelope"]valueForKey:@"Body"]valueForKey:@"SideFootUploadServiceResponse"]valueForKey:@"SideFootUploadServiceResult"]valueForKey:@"ToeBoxHeight"]valueForKey:@"text"];
                                                                    
                    
            womenEuro = [[[[[[dict1 valueForKey:@"Envelope"]valueForKey:@"Body"]valueForKey:@"SideFootUploadServiceResponse"]valueForKey:@"SideFootUploadServiceResult"]valueForKey:@"WomenEuro"]valueForKey:@"text"];
                    
            womenUK = [[[[[[dict1 valueForKey:@"Envelope"]valueForKey:@"Body"]valueForKey:@"SideFootUploadServiceResponse"]valueForKey:@"SideFootUploadServiceResult"]valueForKey:@"WomenUK"]valueForKey:@"text"];
                    
            womenUS = [[[[[[dict1 valueForKey:@"Envelope"]valueForKey:@"Body"]valueForKey:@"SideFootUploadServiceResponse"]valueForKey:@"SideFootUploadServiceResult"]valueForKey:@"WomenUS"]valueForKey:@"text"];
                                                                    
//            NSLog(@"Arch Distance : %@",archDistance);
//            NSLog(@"Arch height : %@",archHeight);
//            NSLog(@"Foot Length : %@",footLength);
//            NSLog(@"Men Euro : %@",menEuro);
//            NSLog(@"Men UK : %@",menUK);
//            NSLog(@"Men US %@",menUS);
//            NSLog(@"Result ID : %@",resultID);
//            NSLog(@"Side ID : %@",sideID);
//            NSLog(@"Talus Height : %@",talusHeight);
//            NSLog(@"Talus Slope : %@",talusSlope);
//            NSLog(@"Toe Box Height : %@",toeBoxHeight);
//            NSLog(@"Women Euro : %@",womenEuro);
//            NSLog(@"Women UK : %@",womenUK);
//            NSLog(@"Women US : %@",womenUS);
            
            [self performSelectorOnMainThread:@selector(DisplayData) withObject:nil waitUntilDone:NO];
        }
     }
}];
    
    [dataTask resume];
}


////--------------- front Foot ------

-(void)Upload_Front_Segmentation:(NSData*)imgData xGrid:(int)X2 yGrid:(int)Y2 wGrid:(int)W2  hGrid:(int)H2
{
    UIImage *scaledCameraImage = [UIImage imageWithData:imgData];
    
    UIImageWriteToSavedPhotosAlbum(scaledCameraImage, self, nil, nil);//self.mySnap.image

    
//    NSLog(@"front grid box x: %d y: %d w: %d  h: %d",X2,Y2,W2,H2);
    
    NSDictionary *headers = @{ @"SOAPAction": @"http://tempuri.org/FrontFootUploadService",
                               @"content-type": @"text/xml; charset=utf-8",
                               @"cache-control": @"no-cache",
                               };
    
    NSString *base64String = [imgData base64Encoding];
    
    NSData *segmentData = [[NSData alloc] initWithData:[[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><FrontFootUploadService xmlns=\"http://tempuri.org/\"><Image>%@</Image><pointA>%d</pointA><pointB>%d</pointB><pointC>%d</pointC><pointD>%d</pointD></FrontFootUploadService></soap:Body></soap:Envelope>",base64String,X2,Y2,W2,H2] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:WINDOWS_IMAGE_UPLOAD_FRONT_SEGMENTATION_URL]   cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:segmentData];
    [request setTimeoutInterval:5*60];
    
    session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error)
    {
        NSLog(@"%@", error);
    }
    else
    {
        dict = [XMLReader dictionaryForXMLData:data options:XMLReaderOptionsProcessNamespaces error:&error];
                                                        
                                                        
        errorMsg1 = [[[[[[dict valueForKey:@"Envelope"]valueForKey:@"Body"]valueForKey:@"FrontFootUploadServiceResponse"]valueForKey:@"FrontFootUploadServiceResult"]valueForKey:@"ErrorMessage"]valueForKey:@"text"];
                                                                
        if ([errorMsg1 length]!=0)
        {
           [self performSelectorOnMainThread:@selector(DisplayErrorFrontFootData) withObject:nil waitUntilDone:YES];
        }
        else
        {
           footWidth = [[[[[[dict valueForKey:@"Envelope"]valueForKey:@"Body"]valueForKey:@"FrontFootUploadServiceResponse"]valueForKey:@"FrontFootUploadServiceResult"]valueForKey:@"FootWidth"]valueForKey:@"text"];
                                                                
            NSLog(@"foot Width : %@",footWidth);
                
            [self performSelectorOnMainThread:@selector(DisplayFrontFootData) withObject:nil waitUntilDone:NO];
        }
    }
                                                    
    }];
    
    [dataTask resume];
}

-(void)DisplayErrorFrontFootData
{
   // displaying the side foot details evenIf there is an error with front foot segmentation
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🎁Windows Front Foot Error🎁"
                                                    message:errorMsg1
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

    footDescription *myFootData=  [self.storyboard instantiateViewControllerWithIdentifier:@"footView"];
    
    myFootData.footLength = footLength;
    myFootData.footWidth = footWidth;
    myFootData.archDistance = archDistance;
    myFootData.archHeight = archHeight;
    myFootData.talusSlope = talusSlope;
    myFootData.talusHeight = talusHeight;
    myFootData.toeBoxHeight = toeBoxHeight;
    myFootData.menEuro = menEuro;
    myFootData.menUK = menUK;
    myFootData.menUS = menUS;
    myFootData.womenEuro = womenEuro;
    myFootData.womenUK = womenUK;
    myFootData.womenUS = womenUS;
    myFootData.menWidthCode = menWidthCode;
    myFootData.menWidthValue = menWidthValue;
    myFootData.womenWidthCode = womenWidthCode;
    myFootData.womenWidthValue = womenWidthValue;
    
    [appDel removeActivity];
    
    [self.navigationController pushViewController:myFootData animated:YES];//87
}

-(void)DisplayFrontFootData
{
  //  flag=3;
    
  /*  NSString *str = [NSString stringWithFormat:@"\n Foot ID : %@  \n Foot Width : %@ \n Mens Width Code : %@ \n Mens Width Value : %@ \n Women Width Code : %@ \n Women Width Value : %@",footID,footWidth,menWidthCode,menWidthCode,womenWidthCode,womenWidthValue];
   
   */
    
    flag=0;
    
  //  [self footWidthSize];
 

    footDescription *myFootData=  [self.storyboard instantiateViewControllerWithIdentifier:@"footView"];
    
    myFootData.footLength = footLength;
    myFootData.footWidth = footWidth;
    myFootData.archDistance = archDistance;
    myFootData.archHeight = archHeight;
    myFootData.talusSlope = talusSlope;
    myFootData.talusHeight = talusHeight;
    myFootData.toeBoxHeight = toeBoxHeight;
    myFootData.menEuro = menEuro;
    myFootData.menUK = menUK;
    myFootData.menUS = menUS;
    myFootData.womenEuro = womenEuro;
    myFootData.womenUK = womenUK;
    myFootData.womenUS = womenUS;
    myFootData.menWidthCode = menWidthCode;
    myFootData.menWidthValue = menWidthValue;
    myFootData.womenWidthCode = womenWidthCode;
    myFootData.womenWidthValue = womenWidthValue;
    
    [appDel removeActivity];
    
    [self.navigationController pushViewController:myFootData animated:YES];//87
    
}


-(void)DisplayError
{
    // displaying the side foot error ie Foot Segmentation Failure
    // on click of ok of alert message the app goes to Home Page
    // app going home page handled by alertView activity handler
    
    sideFootErrorFlag =1;
    
    flag=0;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🎁windows side foot error🎁"
                                                    message:errorMsg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}
-(void)DisplayData
{
    NSString *str = [NSString stringWithFormat:@"\n Arch Distance : %@  \n Arch height : %@ \n Foot Length : %@ \n Men Euro : %@ \n Men UK : %@ \n Men US : %@ \n Result ID : %@ \n Side ID : %@ \n Talus Height : %@ \n Talus Slope : %@ \n Toe Box Height : %@ \n Womens Euro : %@\n Womens UK : %@\n Women US : %@",archDistance,archHeight,footLength,menEuro,menUK,menUS,resultID,sideID,talusHeight,talusSlope,toeBoxHeight,womenEuro,womenUK,womenUS];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🎁 Windows Side Foot Data : 🎁"
                                                    message:str
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
  
 /*  footDescription *myFootData = [[footDescription alloc]init];
    
    myFootData.footLength = footLength;
    myFootData.archDistance = archDistance;
    myFootData.archHeight = archHeight;
    myFootData.talusSlope = talusSlope;
    myFootData.talusHeight = talusHeight;
    myFootData.toeBoxHeight = toeBoxHeight;
    myFootData.menEuro = menEuro;
    myFootData.menUK = menUK;
    myFootData.menUS = menUS;
    myFootData.womenEuro = womenEuro;
    myFootData.womenUK = womenUK;
    myFootData.womenUS = womenUS;
    
    [self.storyboard instantiateViewControllerWithIdentifier:@"footView"];
    [self.navigationController pushViewController:myFootData animated:YES];
   */
   

}
///-----------

-(void)viewDidAppear:(BOOL)animated{
    
    [self setAudioOutputSpeaker:YES];
    
}
-(void)voiceRecognitionSetup
{
    self.openEarsEventsObserver = [[OEEventsObserver alloc] init];
    [self.openEarsEventsObserver setDelegate:self];
    
    OELanguageModelGenerator *lmGenerator = [[OELanguageModelGenerator alloc] init];
    
    NSArray *words = [NSArray arrayWithObjects: @"CLICK", nil];
    NSString *name = @"NameIWantForMyLanguageModelFiles";
    
    
//    NSError *err = [lmGenerator generateRejectingLanguageModelFromArray:words
//                                                         withFilesNamed:name
//                                                 withOptionalExclusions:nil
//                                                        usingVowelsOnly:FALSE
//                                                             withWeight:nil
//                                                 forAcousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"]];
    
    
    NSError *err = [lmGenerator generateLanguageModelFromArray:words withFilesNamed:name forAcousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"]];
    // Change "AcousticModelEnglish" to "AcousticModelSpanish" to create a Spanish language model instead of an English one.
    
    if(err == nil) {
        
        lmPath = [lmGenerator pathToSuccessfullyGeneratedLanguageModelWithRequestedName:@"NameIWantForMyLanguageModelFiles"];
        dicPath = [lmGenerator pathToSuccessfullyGeneratedDictionaryWithRequestedName:@"NameIWantForMyLanguageModelFiles"];
        
    } else {
        NSLog(@"Error: %@",[err localizedDescription]);
    }
    
    [[OEPocketsphinxController sharedInstance] setActive:TRUE error:nil];
    [[OEPocketsphinxController sharedInstance] startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF: NO]; // start listening
    
}


- (void)setAudioOutputSpeaker:(BOOL)enabled
{
    AVAudioSession *audioSession =[AVAudioSession sharedInstance];
    NSError *error;
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [audioSession setMode:AVAudioSessionModeVoiceChat error:&error];
    if (enabled) // Enable speaker
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
    else // Disable speaker
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:&error];
    [audioSession setActive:YES error:&error];
}


-(void)DisplayFrontFootResponce
{
   /* NSString *resp = [NSString stringWithFormat:@"Front Foot Resp : %@",dict];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🎁 window Front Foot Responce 🎁"
                                                    message: resp //errorMsg1
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];*/

}


-(void)footWidthSize
{
    
    NSDictionary *headers = @{ @"SOAPAction": @"http://tempuri.org/WidthCodeService",
                               @"content-type": @"text/xml; charset=utf-8",
                               @"cache-control": @"no-cache",
                               };
    
    NSData *segmentData = [[NSData alloc] initWithData:[[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><WidthCodeService xmlns=\"http://tempuri.org/\"><MenUS>%@</MenUS><WomenUS>%@</WomenUS><FootWidth>%@</FootWidth></WidthCodeService></soap:Body></soap:Envelope>",menUS,womenUS,footWidth] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://207.178.170.24/FittedSolutionsServices.asmx?op=FrontFootUploadService"]   cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
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
                                                        
                                                        
                                                        dict = [XMLReader dictionaryForXMLData:data options:XMLReaderOptionsProcessNamespaces
                                                                                                       error:&error];
                                                        
                                                        NSLog(@"FootID : %@",dict);
                                                        
                                                        
                                                        errorMsg1 = [[[[[[dict valueForKey:@"Envelope"]valueForKey:@"Body"]valueForKey:@"WidthCodeServiceResponse"]valueForKey:@"WidthCodeServiceResult"]valueForKey:@"ErrorMessage"]valueForKey:@"text"];
                                                        
                                                        if ([errorMsg1 length]!=0) {
                                                            
                                                            [self performSelectorOnMainThread:@selector(DisplayErrorFrontFootData) withObject:nil waitUntilDone:NO];
                                                            
                                                        }
                                                        
                                                        
                                                        
                                                        footWidth = [[[[[[dict valueForKey:@"Envelope"]valueForKey:@"Body"]valueForKey:@"WidthCodeServiceResponse"]valueForKey:@"WidthCodeServiceResult"]valueForKey:@"FootWidth"]valueForKey:@"text"];
                                                        
                                                        NSLog(@"foot Width beore: %@",footWidth);
                                                        
                                                        [self performSelectorOnMainThread:@selector(DisplayWidthSize) withObject:nil waitUntilDone:NO];
                                                        
                                                        
                                                    }
                                                }];
    [dataTask resume];
}
-(void)DisplayWidthSize
{
    
}


@end
