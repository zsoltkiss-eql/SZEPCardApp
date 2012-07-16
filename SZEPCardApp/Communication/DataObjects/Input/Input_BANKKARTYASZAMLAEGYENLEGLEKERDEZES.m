//
//  InputBalanceQuery.m
//  SZEPCardApp
//
//  Created by EQL_MACMINI_3 on 2012.05.23..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Input_BANKKARTYASZAMLAEGYENLEGLEKERDEZES.h"
#import "Authentication.h"

@implementation Input_BANKKARTYASZAMLAEGYENLEGLEKERDEZES

+ (NSString *)createInput:(NSString *)cardNumber teleCode:(NSString *)teleCode {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Egyenleglekerdezes" ofType:@"xml"];
    NSLog(@"%@",path);

    NSError *error = nil;
    NSString *contentOfFile = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    //NSLog(@"content of file1: %@", contentOfFile);
    
    NSString *newFile = [NSString stringWithFormat:contentOfFile, cardNumber, teleCode];
    //NSLog(@"content of file2: %@", newFile);

    [contentOfFile release];    
    
    return newFile;
}

@end
