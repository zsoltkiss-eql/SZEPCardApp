//
//  Input_HB_BEJELENTKEZES.m
//  SZEPCardApp
//
//  Created by Karesz on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Input_HB_BEJELENTKEZES.h"

@implementation Input_HB_BEJELENTKEZES

+ (NSString *) createInput {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HB_BEJELENTKEZES" ofType:@"xml"];
    NSLog(@"%@",path);
    
    NSError *error = nil;
    NSString *contentOfFile = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"content of file1: %@", contentOfFile);
    
    
    return [contentOfFile autorelease];

}

@end
