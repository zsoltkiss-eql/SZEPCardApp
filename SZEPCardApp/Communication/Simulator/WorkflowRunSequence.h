//
//  WorkflowRunSequence.h
//  SZEPCardApp
//
//  Created by Karesz on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkflowRunSequence : NSObject

- (id)initWithName:(NSString *)workflowName andSequence:(NSMutableArray *)sequence;
- (NSString *)nextAnswer;
- (BOOL)isEmpty;
- (void)rebuild;

@property (nonatomic, readonly) BOOL workflowAnswerAvailable;

@end
