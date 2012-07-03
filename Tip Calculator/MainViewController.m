//
//  MainViewController.m
//  Tip Calculator
//
//  Created by Paul Keller on 10/03/2012.
//  Copyright (c) 2012 Planet K Games. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController
@synthesize totalBill, tipPercentage, numberOfPeople, costPerPerson, totalBillCost, txtTotalBill, txtTipPercentage, txtNumberOfPeople, tip;
@synthesize lblTotalBill, lblTipPercentage, lblNumberOfPeople;
@synthesize myPickerView, billAmountArray, tipSelected, tipPercentageArray, numberOfPeopleArray;
@synthesize lblCostPerPersonLabel, lblTipLabel, lblTotalBillCostLabel, lblJoke;
@synthesize myContentView;
//@synthesize myAdBannerView;
@synthesize myAdBannerViewIsVisible;
@synthesize myAdBannerView;


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
    
    myPickerView.hidden = YES;
    pickerType = @"BillAmount"; // "TipPercentage"; "NumberOfPeople"
    
    billAmountArray = [[NSMutableArray alloc] init];
	for(int i = 1; i <= 300; i++) {
		NSString *myString = [NSString stringWithFormat:@"%d", i];
		[billAmountArray addObject:myString];
	}
    
    tipPercentageArray = [[NSMutableArray alloc] init];
    //for (int i = 1; i <= 30; i++) {
    for (int i = 0; i <= 30; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d%%", i];
		[tipPercentageArray addObject:myString];

    }
    
    NSUserDefaults* defaults  = [NSUserDefaults standardUserDefaults];
    lblTipPercentage.text = [NSString stringWithFormat:@"%d%%", [defaults integerForKey:K_DEFAULT_TIP_PERC]];
    
    numberOfPeopleArray = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 50; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d", i];
		[numberOfPeopleArray addObject:myString];
        
    }
    
    txtTotalBill.keyboardType = UIKeyboardTypeDecimalPad;
    
    lblJoke.text = @"";
    
    [self setLabelText];
    
    
    
    self.myAdBannerViewIsVisible = YES;
    
    myAdBannerView.delegate = self;
    myAdBannerView.frame = CGRectOffset(myAdBannerView.frame, 0.0, myAdBannerView.frame.size.height);
    self.myAdBannerViewIsVisible = NO;

    
    
}

- (void)viewDidUnload
{
    [self setMyAdBannerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    } else if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self setLabelText];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

#pragma mark - My Methods
+(MainViewController*)sharedMainViewController
{
    static MainViewController *sharedMainViewController;
    @synchronized(self)
    {
        if (!sharedMainViewController)
            sharedMainViewController = [[MainViewController alloc] init];
		
        return sharedMainViewController;
    }
	return sharedMainViewController;
}


- (void)setLabelText
{
    NSUserDefaults* defaults  = [NSUserDefaults standardUserDefaults];
    lblTipPercentage.text = [NSString stringWithFormat:@"%d%%", [defaults integerForKey:K_DEFAULT_TIP_PERC]];
    
    NSString * curSymbol = [defaults stringForKey:K_CURRENT_CURRENCY];
    
    if (curSymbol == nil || [curSymbol isEqualToString:@""]) 
    {
        lblTotalBill.text = @"Bill Amount:";
        lblCostPerPersonLabel.text = @"Cost Per Person:";
        lblTipLabel.text = @"Tip:";
        lblTotalBillCostLabel.text = @"Total Bill Cost:";
    }
    else
    {         
        lblTotalBill.text = [NSString stringWithFormat:@"Bill Amount (%@):", curSymbol];
        lblCostPerPersonLabel.text = [NSString stringWithFormat:@"Cost Per Person (%@):", curSymbol];
        lblTipLabel.text = [NSString stringWithFormat:@"Tip (%@):", curSymbol];
        lblTotalBillCostLabel.text = [NSString stringWithFormat:@"Total Bill Cost (%@):", curSymbol];
    }
}

- (IBAction)CalculateTip:(id)sender
{    
    if ([txtTotalBill.text isEqualToString:@""]) 
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Total Bill Amount is Empty."
                              message:nil
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    } 
    
    [txtTotalBill resignFirstResponder];
    myPickerView.hidden = YES;
    
    totalBill = [txtTotalBill.text floatValue];
    tipPercentage = [lblTipPercentage.text floatValue] / 100;
    numberOfPeople = [lblNumberOfPeople.text floatValue];
    tip = totalBill * tipPercentage;
    
    costPerPerson = (totalBill + (totalBill * tipPercentage)) / numberOfPeople;
    
    lblTip.text = [NSString stringWithFormat:@"%.2f", tip];
    lblCostPerPerson.text = [NSString stringWithFormat:@"%.2f", costPerPerson];
    lblTotalBillCost.text = [NSString stringWithFormat:@"%.2f", costPerPerson * numberOfPeople];
    
    [self rotateJoke];

}

- (void) rotateJoke
{
    sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSInteger count = [sharedAppDelegate.jokesArray count];
    NSInteger num = (arc4random() % count);
    
    JokeOM * randomJoke;
    
    randomJoke = [sharedAppDelegate.jokesArray objectAtIndex:num];
    lblJoke.text = [NSString stringWithFormat:@"%@\n%@", randomJoke.question, randomJoke.answer];
    
}

- (IBAction)endEdit:(id)sender
{
    
}

- (IBAction)beginEdit:(id)sender
{
    myPickerView.hidden = YES;
    txtTotalBill.text = @"";
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView { // This method needs to be used. It asks how many columns will be used in the UIPickerView
	//return 1; // We only need one column so we will return 1.
    if (pickerType == @"BillAmount") {
        return 1;
    } else if (pickerType == @"TipPercentage"){
        return 1;
    } else {
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component { // This method also needs to be used. This asks how many rows the UIPickerView will have.
	//return [billAmountArray count]; // We will need the amount of rows that we used in the pickerViewArray, so we will return the count of the array.
    if (pickerType == @"BillAmount") {
        return [billAmountArray count];
    } else if (pickerType == @"TipPercentage"){
        return [tipPercentageArray count];
    } else {
        return [numberOfPeopleArray count];
    }
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { // This method asks for what the title or label of each row will be.
	//return [billAmountArray objectAtIndex:row]; // We will set a new row for every string used in the array.
    if (pickerType == @"BillAmount") {
        return [billAmountArray objectAtIndex:row];
    } else if (pickerType == @"TipPercentage"){
        return [tipPercentageArray objectAtIndex:row];
    } else {
        return [numberOfPeopleArray objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component { // And now the final part of the UIPickerView, what happens when a row is selected.

    if (pickerType == @"BillAmount") {
        CGFloat bill = row + 1;
        lblTotalBill.text = [NSString stringWithFormat:@"%.0f", bill];
    } else if (pickerType == @"TipPercentage"){
        //tipSelected = row + 1; // We will set the float 'tipSelected' to row + 1 because the row count starts at 0, so it is 1 number behind our array.
        tipSelected = row; // Now you can have 0%
        lblTipPercentage.text = [NSString stringWithFormat:@"%.0f%%", tipSelected];
    } else {
        CGFloat numPeeps = row + 1;
       lblNumberOfPeople.text = [NSString stringWithFormat:@"%.0f", numPeeps];
    }
    
}

- (IBAction)pickBillAmount:(id)sender
{
    
    pickerType = @"BillAmount";
    [myPickerView reloadAllComponents];
    
    myPickerView.hidden = NO;
    [myPickerView selectRow:0 inComponent:0 animated:YES];
    
}

- (IBAction)pickTipPercentage:(id)sender
{    
    [txtTotalBill resignFirstResponder];

    myPickerView.hidden = NO;
    pickerType = @"TipPercentage";
    [myPickerView reloadAllComponents];
    
    [myPickerView selectRow:0 inComponent:0 animated:YES];
    lblTipPercentage.text = [NSString stringWithFormat:@"%.0f%%", 0];
    
}

- (IBAction)pickNumberOfPeople:(id)sender
{
    [txtTotalBill resignFirstResponder];
    
    myPickerView.hidden = NO;
    pickerType = @"NumberOfPeople";
    [myPickerView reloadAllComponents];
    
    [myPickerView selectRow:0 inComponent:0 animated:YES];
}

#pragma mark iAd Methods
//- (void)bannerViewDidLoadAd:(ADBannerView *)banner
//{
//    if (!self.myAdBannerViewIsVisible)
//    {
//        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
//        // Assumes the banner view is just off the bottom of the screen.
//        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
//        [UIView commitAnimations];
//        self.myAdBannerViewIsVisible= YES;
//    }
//}
//
//- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
//{
//    if (self.myAdBannerViewIsVisible)
//    {
//        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
//        // Assumes the banner view is placed at the bottom of the screen.
//        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
//        [UIView commitAnimations];
//        self.myAdBannerViewIsVisible = NO;
//    }
//}

- (void)bannerViewDidLoadAd:(ADBannerView *)aBanner {
    if (!self.myAdBannerViewIsVisible) {
        [UIView beginAnimations:@"animatedAdBannerOn" context:NULL];
        myAdBannerView.frame = CGRectOffset(myAdBannerView.frame, 0.0, -myAdBannerView.frame.size.height);
        [UIView commitAnimations];
        self.myAdBannerViewIsVisible = YES;
        NSLog(@"Has Ads, showing");
    }
}

- (void)bannerView:(ADBannerView *)aBanner didFailToReceiveAdWithError:(NSError *)error {
    if (self.myAdBannerViewIsVisible) {
        [UIView beginAnimations:@"animatedAdBannerOff" context:NULL];
        myAdBannerView.frame = CGRectOffset(myAdBannerView.frame, 0.0, myAdBannerView.frame.size.height);
        [UIView commitAnimations];
        self.myAdBannerViewIsVisible = NO;
        NSLog(@"Has No Ads, Hiding");
    }
}


@end
