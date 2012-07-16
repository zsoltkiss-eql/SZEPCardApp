//
//  SimulatorConfig.h
//  SZEPCardApp
//
//  Created by Karesz on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WorkflowRunSequence;

@interface SimulatorConfig : NSObject



+ (NSMutableDictionary *)sharedConfig;	

+ (WorkflowRunSequence *)runSequenceFor:(NSString *)workflow;

@end
