//
//  ViewController.h
//  fittedSolutionApp
//
//  Created by Avinash Singh on 4/9/16.
//  Copyright © 2016 Avinash Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <OpenEars/OELanguageModelGenerator.h>
#import <OpenEars/OEPocketsphinxController.h>
#import <OpenEars/OEAcousticModel.h>
#import "footDescription.h"
#import "MPVolumeButtons.h"

#import "AppManager.h"

@class MPVolumeButtons;

@interface ViewController : UIViewController <AVSpeechSynthesizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,OEEventsObserverDelegate>
{
    UIViewController *footDescription;
}

@property (nonatomic, retain) MPVolumeButtons *buttonStealer;

@property (weak, nonatomic) IBOutlet UIView *btnView;

@property (strong, nonatomic) AVAudioSession *session;

@property (strong, nonatomic) AVSpeechSynthesizer *synth;

@property (strong, nonatomic) AVSpeechSynthesisVoice *voice;

@property (strong, nonatomic) OEEventsObserver *openEarsEventsObserver;


@property (strong, nonatomic) IBOutlet UIImageView *mySnap;
- (IBAction)takkePicBtnClk:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnOutlet;

- (IBAction)infoBtnClk:(id)sender;



@property (weak, nonatomic) IBOutlet UIView *headerContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UIView *transparentView;
@property (weak, nonatomic) IBOutlet UIImageView *footPrint;


- (IBAction)btnTap:(id)sender;

@end

