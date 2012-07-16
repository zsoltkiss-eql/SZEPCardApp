//
//  OutputBalanceQuery.m
//  SZEPCardApp
//
//  Created by EQL_MACMINI_3 on 2012.05.24..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OutputBalanceQuery.h"

@implementation OutputBalanceQuery

@synthesize hospitality, leisure, lodging, message, date;

- (void)dealloc{
    
    [date release];
    [message release];
    [hospitality release];
    [leisure release];
    [lodging release];
    
    [super dealloc];
}

@end
