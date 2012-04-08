//
//  CustomaryDetailsOM.h
//  Tip Calculator
//
//  Created by Paul Keller on 20/03/2012.
//  Copyright (c) 2012 Planet K Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface CustomaryDetailsOM : NSObject {
    NSNumber * detailsID;
    NSString * country;
    NSNumber * minTipPerc;
    NSNumber * maxTipPerc;
    NSString * initials;
    NSString * currencySymbol;
}

@property (nonatomic, retain) NSNumber * detailsID;
@property (nonatomic, retain) NSNumber * minTipPerc;
@property (nonatomic, retain) NSNumber * maxTipPerc;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * initials;
@property (nonatomic, retain) NSString * currencySymbol;

- (id)init;

@end
