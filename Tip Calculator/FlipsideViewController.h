//
//  FlipsideViewController.h
//  Tip Calculator
//
//  Created by Paul Keller on 10/03/2012.
//  Copyright (c) 2012 Planet K Games. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "TipCalcConfig.h"
#import "CustomaryDetailsOM.h"
#import "AppDelegate.h"



@class FlipsideViewController;
//@class AppDelegate;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController <CLLocationManagerDelegate>{
    IBOutlet UISwitch * toggleSwitch;
    IBOutlet UILabel * currentCountry;
    IBOutlet UILabel * customaryTip;
    IBOutlet UILabel * currentCountryLabel;
    IBOutlet UILabel * customaryTipLabel;
    IBOutlet UILabel * countrySettingsHeader;
    
    BOOL updateLocation;
    CLLocationManager * locationManager;
    
    NSMutableArray * tipPercentageArray;
    IBOutlet UIPickerView * pickerView;
    
    AppDelegate * sharedAppDelegate;

}

@property (weak, nonatomic) IBOutlet id <FlipsideViewControllerDelegate> delegate;

@property (nonatomic) BOOL updateLocation;
@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;
@property (nonatomic, retain) NSMutableArray * numberOfPeopleArray;

- (IBAction)done:(id)sender;
- (IBAction)switchThrown:(id)sender;

@end
