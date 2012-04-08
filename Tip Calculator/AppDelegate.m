//
//  AppDelegate.m
//  Tip Calculator
//
//  Created by Paul Keller on 10/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize customaryDetailsArray, jokesArray;
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    customaryDetailsArray = [[NSMutableArray alloc] init];
    jokesArray = [[NSMutableArray alloc] init];
    
    NSString * filePath = [self copyDatabaseToDocuments];
    
    [self readCustomaryDetailsFromDatabaseWithPath:filePath];
    [self readJokesFromDatabaseWithPath:filePath];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark - My Methods

- (NSString *)copyDatabaseToDocuments {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsPath = [paths objectAtIndex:0];
    NSString * filePath = [documentsPath stringByAppendingPathComponent:@"TipCalc"];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        NSString * bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"TipCalc"];
        [fileManager copyItemAtPath:bundlePath toPath:filePath error:nil];
    }
    
    return filePath;
}

- (void) readCustomaryDetailsFromDatabaseWithPath:(NSString *)filePath
{
    sqlite3 * database;
    if (sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) {
        const char * sqlStatement = "select * from customarydetails";
        sqlite3_stmt * compiledStatement;
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                NSNumber * dbDetailsID = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, 0)];
                NSString * dbCountry =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSNumber * dbMinTipPerc = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, 2)];
                NSNumber * dbMaxTipPerc = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, 3)];
                NSString * dbInitials =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                NSString * dbCurrencySymbol =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                
                CustomaryDetailsOM * cusDets = [[CustomaryDetailsOM alloc] init];
                
                cusDets.detailsID = dbDetailsID;
                cusDets.country = dbCountry;
                cusDets.minTipPerc = dbMinTipPerc;
                cusDets.maxTipPerc = dbMaxTipPerc;
                cusDets.initials = dbInitials;
                cusDets.currencySymbol = dbCurrencySymbol;
                
                [self.customaryDetailsArray addObject:cusDets];
            }
        } else
        {
            printf( "could not prepare statemnt: %s\n", sqlite3_errmsg(database) );
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
}

- (void) readJokesFromDatabaseWithPath:(NSString *)filePath
{
    sqlite3 * database;
    if (sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) {
        const char * sqlStatement = "select * from jokes";
        sqlite3_stmt * compiledStatement;
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                NSNumber * dbJokeID = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, 0)];
                NSString * dbQuestion = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString * dbAnswer = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)]; 
                
                JokeOM * joke = [[JokeOM alloc] init];
                
                joke.jokeID = dbJokeID;
                joke.question = dbQuestion;
                joke.answer = dbAnswer;
                
                [self.jokesArray addObject:joke];
            }
        } else
        {
            printf( "could not prepare statemnt: %s\n", sqlite3_errmsg(database) );
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
}

@end
