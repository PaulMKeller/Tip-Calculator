//
//  FlipsideViewController.m
//  Tip Calculator
//
//  Created by Paul Keller on 10/03/2012.
//  Copyright (c) 2012 Planet K Games. All rights reserved.
//

#import "FlipsideViewController.h"

@implementation FlipsideViewController

@synthesize delegate = _delegate;
@synthesize locationManager, updateLocation;
@synthesize numberOfPeopleArray;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    customaryTip.text = @"";
    currentCountry.text = @"";
    
    tipPercentageArray = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 30; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d%%", i];
		[tipPercentageArray addObject:myString];
    }
    
}

- (void)viewDidUnload
{
    [self setLocationManager:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults* defaults  = [NSUserDefaults standardUserDefaults];
    toggleSwitch.on = [defaults boolForKey: K_SWITCH_KEY];
    
    [self switchThrown:self];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{    
    NSInteger row;
    row = [pickerView selectedRowInComponent:0];
    
    NSUserDefaults * defaults  = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:row + 1 forKey: K_DEFAULT_TIP_PERC];
    [defaults synchronize];
    
    [self.delegate flipsideViewControllerDidFinish:self];
    
}

- (IBAction)switchThrown:(id)sender
{
    customaryTip.text = @"";
    currentCountry.text = @"";
    
    // Make the labels visible or invisible
    if (toggleSwitch.on == YES) {
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
    } else {
        [locationManager stopUpdatingLocation];
    }
    
    countrySettingsHeader.hidden = !toggleSwitch.on;
    currentCountry.hidden = !toggleSwitch.on;
    currentCountryLabel.hidden = !toggleSwitch.on;
    customaryTip.hidden = !toggleSwitch.on;
    customaryTipLabel.hidden = !toggleSwitch.on;
    
    NSUserDefaults * defaults  = [NSUserDefaults standardUserDefaults];
    
    if (customaryTip.hidden == YES) {
        customaryTip.text = @"";
        currentCountry.text = @"";
        
        [defaults setObject:@"" forKey:K_CURRENT_COUNTRY];
        [defaults setInteger:1 forKey:K_DEFAULT_TIP_PERC];
        [defaults setObject:nil forKey:K_CURRENT_CURRENCY];
    }
    
    [defaults setBool: toggleSwitch.on forKey: K_SWITCH_KEY];
    [defaults synchronize];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
    
    NSLog(@"Location: %@", [newLocation description]);
    
    __block BOOL isCountryFound = NO;
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            currentCountry.text = [placemark country];
            
            sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            for (CustomaryDetailsOM * cusDet in sharedAppDelegate.customaryDetailsArray) {
                if ([cusDet.country isEqualToString:currentCountry.text]) {
                    isCountryFound = YES;
                    //NSLog(@"Country: %@", currentCountry.text);
                    customaryTip.text = [NSString stringWithFormat:@"%@%% and %@%%", cusDet.minTipPerc ,cusDet.maxTipPerc];
                    
                    
                    //Now set the spinner to minTipPerc
                    [pickerView selectRow:[cusDet.minTipPerc intValue] - 1 inComponent:0 animated:YES];
                    
                    //Now set the currency symbol property
                    NSUserDefaults * defaults  = [NSUserDefaults standardUserDefaults];
                    NSString * cusSymbol = cusDet.currencySymbol;
                    //[defaults setObject:cusDet.currencySymbol forKey:K_CURRENT_CURRENCY];
                    [defaults setObject:cusSymbol forKey:K_CURRENT_CURRENCY];
                    [defaults synchronize];
                }
            }
        }    
    }];
    
    if (isCountryFound == NO) {
        currentCountry.text = @"No Country Info Found";
        customaryTip.text = @"No Tip Info Found";
        NSUserDefaults * defaults  = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"" forKey:K_CURRENT_COUNTRY];
        [defaults setInteger:1 forKey:K_DEFAULT_TIP_PERC];
        [defaults setObject:nil forKey:K_CURRENT_CURRENCY];
        [defaults synchronize];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error description]);
}

#pragma mark Picker Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView { // This method needs to be used. It asks how many columns will be used in the UIPickerView
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component { // This method also needs to be used. This asks how many rows the UIPickerView will have.
	return [tipPercentageArray count]; // We will need the amount of rows that we used in the pickerViewArray, so we will return the count of the array.
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { // This method asks for what the title or label of each row will be.
	return [tipPercentageArray objectAtIndex:row]; // We will set a new row for every string used in the array.
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component { // And now the final part of the UIPickerView, what happens when a row is selected.
    
    NSUserDefaults * defaults  = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:row + 1 forKey:K_DEFAULT_TIP_PERC];
    [defaults synchronize];
    
}



@end
