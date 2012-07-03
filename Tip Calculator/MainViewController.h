//
//  MainViewController.h
//  Tip Calculator
//
//  Created by Paul Keller on 10/03/2012.
//  Copyright (c) 2012 Planet K Games. All rights reserved.
//

#import "FlipsideViewController.h"
#import "TipCalcConfig.h"
#import "AppDelegate.h"
//#import "iAd/ADBannerView.h"
#import <iAd/iAd.h>


@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, ADBannerViewDelegate>
{
    CGFloat totalBill;
    CGFloat tipPercentage;
    NSInteger numberOfPeople;
    CGFloat costPerPerson;
    
    IBOutlet UITextField * txtTotalBill;
    IBOutlet UITextField * txtTipPercentage;
    IBOutlet UITextField * txtNumberOfPeople;
    
    IBOutlet UILabel * lblCostPerPerson;
    IBOutlet UILabel * lblCostPerPersonLabel;
    IBOutlet UILabel * lblTotalBillCost;
    IBOutlet UILabel * lblTotalBillCostLabel;
    IBOutlet UILabel * lblTip;
    IBOutlet UILabel * lblTipLabel;
    
    IBOutlet UILabel * lblTotalBill;
    IBOutlet UILabel * lblTipPercentage;
    IBOutlet UILabel * lblNumberOfPeople;
    
    IBOutlet UILabel * lblJoke;
    
    IBOutlet UIPickerView * myPickerView;
    NSMutableArray * billAmountArray;
    NSMutableArray * tipPercentageArray;
    NSMutableArray * numberOfPeopleArray;

    CGFloat tipSelected;
    
    NSString * pickerType;
    
    AppDelegate * sharedAppDelegate;
    
    UIView * myContentView;
    //id myAdBannerView;
    BOOL myAdBannerViewIsVisible;
    
}

@property (nonatomic, assign) CGFloat totalBill;
@property (nonatomic, assign) CGFloat tipPercentage;
@property (nonatomic, assign) NSInteger numberOfPeople;
@property (nonatomic, assign) CGFloat tip;
@property (nonatomic, assign) CGFloat costPerPerson;
@property (nonatomic, assign) CGFloat totalBillCost;
@property (nonatomic, retain) UITextField * txtTotalBill;
@property (nonatomic, retain) UITextField * txtTipPercentage;
@property (nonatomic, retain) UITextField * txtNumberOfPeople;

@property (nonatomic, retain) UILabel * lblTotalBill;
@property (nonatomic, retain) UILabel * lblTipPercentage;
@property (nonatomic, retain) UILabel * lblNumberOfPeople;

@property (nonatomic, retain) UILabel * lblCostPerPersonLabel;
@property (nonatomic, retain) UILabel * lblTotalBillCostLabel;
@property (nonatomic, retain) UILabel * lblTipLabel;

@property (nonatomic, retain) UILabel * lblJoke;

@property (nonatomic, retain) UIPickerView * myPickerView;
@property (nonatomic, retain) NSMutableArray * billAmountArray;
@property (nonatomic, retain) NSMutableArray * tipPercentageArray;
@property (nonatomic, retain) NSMutableArray * numberOfPeopleArray;
@property (nonatomic, assign) CGFloat tipSelected;

@property (nonatomic, retain) IBOutlet UIView * myContentView;
//@property (nonatomic, retain) id myAdBannerView;
@property (nonatomic, assign) BOOL myAdBannerViewIsVisible;
@property (strong, nonatomic) IBOutlet ADBannerView *myAdBannerView;



- (IBAction)CalculateTip:(id)sender;
- (IBAction)endEdit:(id)sender;
- (IBAction)beginEdit:(id)sender;
+ (MainViewController*)sharedMainViewController;

- (IBAction)pickBillAmount:(id)sender;
- (IBAction)pickTipPercentage:(id)sender;
- (IBAction)pickNumberOfPeople:(id)sender;
- (void) setLabelText;
- (void) rotateJoke;


@end
