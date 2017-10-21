//
//  ViewController.m
//  Paige
//
//  Created by Justin Edwards on 2017-10-06.
//  Copyright © 2017 Justin Edwards. All rights reserved.
//

#import "ViewController.h"
#import "AVFoundation/AVFoundation.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

bool speekLetter;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _txtText.delegate = self;
    
    speekLetter = [[NSUserDefaults standardUserDefaults] boolForKey:@"speekLetter"];
    if(speekLetter)
    {
        [_switchSayLetter setOn:speekLetter];
    }
    
    float sRvalue = [[NSUserDefaults standardUserDefaults] floatForKey:@"defaultSpeechRate"];
    NSLog(@"Slider Starting value: %f", sRvalue);
    _sliderRate.maximumValue = 0.55;
    _sliderRate.minimumValue = 0.3;
    _sliderRate.value = sRvalue;
    
    float sPvalue = [[NSUserDefaults standardUserDefaults] floatForKey:@"defaultSpeechPitch"];
    NSLog(@"Pitch Starting value: %f", sPvalue);
    _sliderPitch.maximumValue = 2.0;
    _sliderPitch.minimumValue = 0.50;
    _sliderPitch.value = sPvalue;
    
    
    _arrOfLang = [[NSArray alloc] initWithObjects:@"en-AU",@"en-GB",@"en-IE",@"en-US",@"en-ZA",nil];
    _arrOfLangNames = [[NSArray alloc] initWithObjects:@"Karen",@"Daniel",@"Moira",@"Samantha",@"Tessa",nil];

    _langPicker.delegate = self;
    _langPicker.dataSource = self;
    _langPicker.showsSelectionIndicator = YES;
    int langValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"defaultLang"];
    [_langPicker selectRow:langValue inComponent:0 animated:YES];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_arrOfLang count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@", [_arrOfLangNames objectAtIndex:row]];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [[NSUserDefaults standardUserDefaults] setInteger:row forKey:@"defaultLang"];
}


- (IBAction)sliderRateChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setFloat:_sliderRate.value forKey:@"defaultSpeechRate"];

    NSLog(@"Slider Rate: %f", _sliderRate.value);
}

- (IBAction)sliderPitchChanged:(id)sender {
    
    float pvalue = _sliderPitch.value;
    [[NSUserDefaults standardUserDefaults] setFloat:pvalue forKey:@"defaultSpeechPitch"];
    
    NSLog(@"Slider Pitch: %f", pvalue);
}
- (IBAction)btnDefaults:(id)sender {
    NSLog(@"Rate: %f", AVSpeechUtteranceDefaultSpeechRate );
    [_sliderRate setValue:AVSpeechUtteranceDefaultSpeechRate];
    [_sliderPitch setValue:1.0];  // default developer.apple.com/documentation/avfoundation/avspeechutterance/1619683-pitchmultiplier
    [_langPicker selectRow:3 inComponent:0 animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setFloat:_sliderRate.value forKey:@"defaultSpeechRate"];
    [[NSUserDefaults standardUserDefaults] setFloat:_sliderPitch.value forKey:@"defaultSpeechPitch"];
    [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"defaultLang"];
    
}

- (IBAction)btnViewSettings:(id)sender {
    if(_lblSpeechRate.isHidden)
    {
        [_btnDefaults setHidden:FALSE];
        [_lblSpeechPitch setHidden:FALSE];
        [_lblSpeechRate setHidden:FALSE];
        [_langPicker setHidden:FALSE];
        [_sliderPitch setHidden:FALSE];
        [_sliderRate setHidden:FALSE];
    }
    else
    {
        [_btnDefaults setHidden:TRUE];
        [_lblSpeechPitch setHidden:TRUE];
        [_lblSpeechRate setHidden:TRUE];
        [_langPicker setHidden:TRUE];
        [_sliderPitch setHidden:TRUE];
        [_sliderRate setHidden:TRUE];
    }
}

- (IBAction)btnDelete:(id)sender {
    [_txtText setText:@""];
}


- (IBAction)btnBackspace:(id)sender {
    NSString *string = _txtText.text;
    if(string.length>0)
        [_txtText setText:[string substringToIndex:string.length - 1]];
}

- (IBAction)sayLetterChanged:(id)sender {
    
    if(speekLetter)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:NO forKey:@"speekLetter"];
        [userDefaults synchronize];
        speekLetter = NO;
    }
    else
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:YES forKey:@"speekLetter"];
        [userDefaults synchronize];
        speekLetter = YES;
    }
}


- (IBAction)btnLetter:(id)sender {
    NSString *button = [sender currentTitle];
    if(button.length == 1)
    {
        
        [_txtText setText:[NSString stringWithFormat:@"%@%@", _txtText.text,  [sender currentTitle]]];
        
        if(speekLetter)
        {
            [self tts:button];
        }
        
    }
    else
    {
        [_txtText setText:[NSString stringWithFormat:@"%@ ", _txtText.text]];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if(_txtText.text.length>0){
        [self tts:_txtText.text];
    }
    
    return NO;
}


-(void)tts:(NSString *)text{
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[text lowercaseString]];
    AVSpeechSynthesizer *syn = [[AVSpeechSynthesizer alloc] init];
    
    float sRvalue = [[NSUserDefaults standardUserDefaults] floatForKey:@"defaultSpeechRate"];
    NSLog(@"Speech Rate value: %f", sRvalue);
    [utterance setRate:sRvalue];
    
    
    float spvalue = [[NSUserDefaults standardUserDefaults] floatForKey:@"defaultSpeechPitch"];
    NSLog(@"Speech Pitch value: %f", spvalue);
    [utterance setPitchMultiplier:spvalue];
    
    NSString *voice = [_arrOfLang objectAtIndex:[_langPicker selectedRowInComponent:0]];

    [utterance setVoice:[AVSpeechSynthesisVoice voiceWithLanguage:voice]];
    [syn speakUtterance:utterance];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
