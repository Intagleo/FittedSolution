//
//  footDescription.h
//  fittedSolutionApp
//
//  Created by Avinash Singh on 4/26/16.
//  Copyright © 2016 Avinash Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <OpenEars/OELanguageModelGenerator.h>
#import <OpenEars/OEPocketsphinxController.h>
#import <OpenEars/OEAcousticModel.h>


@interface footDescription : UIViewController<AVSpeechSynthesizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,OEEventsObserverDelegate>

@property (strong, nonatomic) AVAudioSession *session;

@property (strong, nonatomic) AVSpeechSynthesizer *synth;

@property (strong, nonatomic) AVSpeechSynthesisVoice *voice;

@property (strong, nonatomic) OEEventsObserver *openEarsEventsObserver;


@property (weak, nonatomic) IBOutlet UIImageView *footImageView;
@property (weak, nonatomic) IBOutlet UILabel *instructionLbl;

@property (weak, nonatomic) IBOutlet UILabel *footLengthLbl;
@property (weak, nonatomic) IBOutlet UILabel *footWidthLbl;
@property (weak, nonatomic) IBOutlet UILabel *archHeightLbl;
@property (weak, nonatomic) IBOutlet UILabel *archDistanceLbl;
@property (weak, nonatomic) IBOutlet UILabel *talusHeightLbl;
@property (weak, nonatomic) IBOutlet UILabel *talusSlopeLbl;
@property (weak, nonatomic) IBOutlet UILabel *toeBoxHeightLbl;

@property (weak, nonatomic) IBOutlet UILabel *footDivider1Lbl;
@property (weak, nonatomic) IBOutlet UILabel *footDivider2Lbl;
@property (weak, nonatomic) IBOutlet UILabel *footDivider3Lbl;
@property (weak, nonatomic) IBOutlet UILabel *footDivider4Lbl;
@property (weak, nonatomic) IBOutlet UILabel *footDivider5Lbl;
@property (weak, nonatomic) IBOutlet UILabel *footDivider6Lbl;


@property (weak, nonatomic) IBOutlet UILabel *shoeSizeLbl;
@property (weak, nonatomic) IBOutlet UILabel *mensUSLbl;
@property (weak, nonatomic) IBOutlet UILabel *mensEuroLbl;
@property (weak, nonatomic) IBOutlet UILabel *mensUKLbl;


@property (weak, nonatomic) IBOutlet UILabel *mensUSLblTxt;
@property (weak, nonatomic) IBOutlet UILabel *mensEuroLblTxt;
@property (weak, nonatomic) IBOutlet UILabel *mensUKLblTxt;

@property (weak, nonatomic) IBOutlet UILabel *womensLbl;
@property (weak, nonatomic) IBOutlet UILabel *womensEuroLbl;
@property (weak, nonatomic) IBOutlet UILabel *womenUKLbl;

@property (weak, nonatomic) IBOutlet UILabel *womensLblTxt;
@property (weak, nonatomic) IBOutlet UILabel *womensEuroLblTxt;
@property (weak, nonatomic) IBOutlet UILabel *womenUKLblTxt;

@property (weak, nonatomic) IBOutlet UILabel *shoeDivider1Lbl;
@property (weak, nonatomic) IBOutlet UILabel *shoeDivider2Lbl;
@property (weak, nonatomic) IBOutlet UILabel *shoeDivider3Lbl;
@property (weak, nonatomic) IBOutlet UILabel *shoeDivider4Lbl;
@property (weak, nonatomic) IBOutlet UILabel *shoeDivider5Lbl;
@property (weak, nonatomic) IBOutlet UILabel *shoeDivider6Lbl;


@property (weak, nonatomic) IBOutlet UILabel *footlengthTxt;

@property (weak, nonatomic) IBOutlet UILabel *footWidthTxt;
@property (weak, nonatomic) IBOutlet UILabel *archHeightTxt;

@property (weak, nonatomic) IBOutlet UILabel *archDistanceTxt;

@property (weak, nonatomic) IBOutlet UILabel *talusHeightTxt;
@property (weak, nonatomic) IBOutlet UILabel *toeBoxHeightTxt;
@property (weak, nonatomic) IBOutlet UILabel *talusSlopeTxt;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (weak, nonatomic) NSString *footLength;
@property (weak, nonatomic) NSString *footWidth;
@property (weak, nonatomic) NSString *archDistance;
@property (weak, nonatomic) NSString *archHeight;
@property (weak, nonatomic) NSString *talusHeight;
@property (weak, nonatomic) NSString *talusSlope;
@property (weak, nonatomic) NSString *toeBoxHeight;
@property (weak, nonatomic) NSString *menEuro;
@property (weak, nonatomic) NSString *menUK;
@property (weak, nonatomic) NSString *menUS;
@property (weak, nonatomic) NSString *womenEuro;
@property (weak, nonatomic) NSString *womenUK;
@property (weak, nonatomic) NSString *womenUS;

@property (weak, nonatomic) NSString *menWidthCode;
@property (weak, nonatomic) NSString *menWidthValue;
@property (weak, nonatomic) NSString *womenWidthCode;
@property (weak, nonatomic) NSString *womenWidthValue;



@end
