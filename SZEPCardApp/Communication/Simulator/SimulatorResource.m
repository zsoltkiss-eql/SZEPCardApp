//
//  SimulatorResource.m
//  SZEPCardApp
//
//  Created by Karesz on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SimulatorResource.h"

@interface SimulatorResource() {
@private
    ResponseType type_;
    NSString *fileName_;
}
@end

@implementation SimulatorResource

@synthesize type = type_, fileName = fileName_;

#pragma mark - static factory methods
+ (SimulatorResource *)simulatorResourceRunWorkflow {
    SimulatorResource *sr = [[SimulatorResource alloc]initWithType:RUN_WORKFLOW andFileName:@"startWorkflowResponse"];
    
    return [sr autorelease];
}

+ (SimulatorResource *)simulatorResourcePolling {
    SimulatorResource *sr = [[SimulatorResource alloc]initWithType:RUN_WORKFLOW andFileName:@"getWorkflowStateResponse"];
    
    return [sr autorelease];
}

#pragma mark - initializer

- (id)initWithType:(ResponseType)type andFileName:(NSString *)file {
    self = [super init];
    
    if(self) {
        type_ = type;
        
        fileName_ = file;
        [fileName_ retain];
    }
    
    return self;
}

#pragma mark - description

- (NSString *)description {
    NSMutableString *ms = [[NSMutableString alloc]init];
    
    [ms appendFormat:@"%@", [super description]];
    [ms appendString:@"{"];
    [ms appendFormat:@"%@", fileName_];
    [ms appendString:@"}"];
    
    return [ms autorelease];
    
}

#pragma mark - dealloc
- (void) dealloc {
    
    [fileName_ release];
    
    [super dealloc];
    
}

@end
