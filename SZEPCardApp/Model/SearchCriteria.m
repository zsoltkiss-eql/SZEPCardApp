//
//  SearchCriteria.m
//  SZEPCardApp
//
//  Created by Karesz on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchCriteria.h"

@implementation SearchCriteria
@synthesize longitude, latitude, settlement, hospitalityExpected, leisureExpected, lodgingExpected, searchRadius, searchType;


- (NSString *)description {
    NSMutableString *ms = [[NSMutableString alloc]init];
    
    [ms appendFormat:@"%@", [super description]];
    [ms appendString:@"{"];
    [ms appendFormat:@"searchType: %d", searchType];
    
    [ms appendFormat:@", settlement: %@, %@", settlement.zipCode, settlement.name];
    [ms appendFormat:@", longitude: %d, latitude: %d", longitude, latitude];
    
    [ms appendString:@"}"];
    
    return [ms autorelease];
}

#pragma mark - dealloc

- (void)dealloc {
    [settlement release];
    
    
    [super dealloc];
}

@end
