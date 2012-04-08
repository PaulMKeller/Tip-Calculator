//
//  AppDelegate.h
//  Tip Calculator
//
//  Created by Paul Keller on 10/03/2012.
//  Copyright (c) 2012 Planet K Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <sqlite3.h>
#import "CustomaryDetailsOM.h"
#import "JokeOM.h"

@class CustomaryDetailsOM;
@class JokeOM;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSMutableArray * customaryDetailsArray;
    NSMutableArray * jokesArray;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSMutableArray * customaryDetailsArray; 
@property (nonatomic, retain) NSMutableArray * jokesArray;

//- (void) copyDatabaseIfNeeded;
//- (NSString *) getDBPath;

- (NSString *)copyDatabaseToDocuments;
- (void) readCustomaryDetailsFromDatabaseWithPath:(NSString *)filePath;
- (void) readJokesFromDatabaseWithPath:(NSString *)filePath;



@end
