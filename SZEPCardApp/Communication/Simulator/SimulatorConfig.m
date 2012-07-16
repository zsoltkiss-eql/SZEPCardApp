//
//  SimulatorConfig.m
//  SZEPCardApp
//
//  Created by Karesz on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SimulatorConfig.h"
#import "WorkflowRunSequence.h"
#import "SimulatorResource.h"

@implementation SimulatorConfig

static NSMutableDictionary *sharedConfig_ = NULL;


#pragma mark - class methods

+ (NSMutableDictionary *)sharedConfig {
    if(sharedConfig_ == nil) {
        sharedConfig_ = [[NSMutableDictionary alloc]init];
        
        /*
        WorkflowRunSequence *wrs1 = [[WorkflowRunSequence alloc]initWithName:@"HB_BEJELENTKEZES" andSequence:[[NSMutableArray alloc]initWithObjects:@"bankkartyaszamlaegyenleg", @"getWorkflowStateResponse", @"getWorkflowStateResponse", @"startWorkflowResponse", nil]];
         */
        
        
         WorkflowRunSequence *wrs1 = [[WorkflowRunSequence alloc]initWithName:@"HB_BEJELENTKEZES" andSequence:[[NSMutableArray alloc]initWithObjects:[[SimulatorResource alloc]initWithType:ANSWER_READY andFileName:@"bankkartyaszamlaegyenleg"], [SimulatorResource simulatorResourcePolling], [SimulatorResource simulatorResourcePolling], [SimulatorResource simulatorResourceRunWorkflow], nil]];
        
         WorkflowRunSequence *wrs2 = [[WorkflowRunSequence alloc]initWithName:@"BANKKARTYASZAMLAEGYENLEGLEKERDEZES" andSequence:[[NSMutableArray alloc]initWithObjects:[[SimulatorResource alloc]initWithType:ANSWER_READY andFileName:@"bankkartyaszamlaegyenleg"], [SimulatorResource simulatorResourcePolling], [SimulatorResource simulatorResourcePolling], [SimulatorResource simulatorResourcePolling], [SimulatorResource simulatorResourceRunWorkflow], nil]];
        
        [sharedConfig_ setObject:wrs1 forKey:@"HB_BEJELENTKEZES"];
        [sharedConfig_ setObject:wrs2 forKey:@"BANKKARTYASZAMLAEGYENLEGLEKERDEZES"];
        
    }
    
    return sharedConfig_;
}

+ (WorkflowRunSequence *)runSequenceFor:(NSString *)workflow {
    NSDictionary *simuConf = [SimulatorConfig sharedConfig];
    //NSLog(@"simuConf %@", simuConf);
    WorkflowRunSequence *wrs = [simuConf objectForKey:workflow];
    //NSLog(@"wrs for %@: %@", workflow, wrs);
    
    if([wrs isEmpty]) {
        [wrs rebuild];
    }
    
    return wrs;
}

/*
+ (NSMutableArray *)getConfigFor:(NSString *)workflow {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"BANKKARTYASZAMLAEGYENLEGLEKERDEZES", @"egyenleg, pollString(4)", 
                         nil ];
    
    NSString *rawString = [dic objectForKey:workflow];
    
    NSArray *chunks = [rawString componentsSeparatedByString:@","];
    
    NSMutableArray *lifoImpl = [[[NSMutableArray alloc]init]autorelease];
    for(NSString *str in chunks) {
        
        NSRange r1 = [str rangeOfString:@"("];
        NSRange r2 = [str rangeOfString:@")"];
        
        if(r1.location != NSNotFound) {
            
            NSRange r3 = NSMakeRange(r1.location + 1, r2.location - r1.location - 1);
            
            int count = [[str substringWithRange:r3]intValue];
            
            for(int i=0;i<count;i++) {
                [lifoImpl addObject:[str substringToIndex:r1.location]];
            }
            
            
        } else {
            [lifoImpl addObject:str];
        }
        
    }
    
    return lifoImpl;
}
 */


@end
