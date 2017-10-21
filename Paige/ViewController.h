//
//  ViewController.h
//  Paige
//
//  Created by Justin Edwards on 2017-10-06.
//  Copyright © 2017 Justin Edwards. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtText;
@property (weak, nonatomic) IBOutlet UISwitch *switchSayLetter;
@property (weak, nonatomic) IBOutlet UISlider *sliderRate;
@property (weak, nonatomic) IBOutlet UISlider *sliderPitch;
@property (weak, nonatomic) IBOutlet UIPickerView *langPicker;

@property (strong, nonatomic) NSArray *arrOfLang;
@property (strong, nonatomic) NSArray *arrOfLangNames;

@property (weak, nonatomic) IBOutlet UILabel *lblSpeechRate;
@property (weak, nonatomic) IBOutlet UILabel *lblSpeechPitch;
@property (weak, nonatomic) IBOutlet UIPickerView *pvLangPicker;
@property (weak, nonatomic) IBOutlet UIButton *btnDefaults;

@end

