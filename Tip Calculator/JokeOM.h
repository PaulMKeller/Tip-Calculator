//
//  JokeOM.h
//  Tip Calculator
//
//  Created by Paul Keller on 25/03/2012.
//  Copyright (c) 2012 Planet K Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JokeOM : NSObject {
    NSNumber * jokeID;
    NSString * question;
    NSString * answer;
}

@property (nonatomic, retain) NSNumber * jokeID;
@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSString * answer;

@end
