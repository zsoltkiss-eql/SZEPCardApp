//
//  WorkflowRunSequence.m
//  SZEPCardApp
//
//  Created by Karesz on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorkflowRunSequence.h"
#import "SimulatorResource.h"

@interface WorkflowRunSequence() {
@private
    NSString *wfName_;
    NSArray *lifoOri_;              //eredeti peldany; sosem modosulhat! Referenciakent hasznaljuk, ha szukseg lenne a peldanyban a sequence ujraepitesere
    NSMutableArray *lifoWork_;      //munkapeldany, ebbol remove-olunk
}

@end

@implementation WorkflowRunSequence
@dynamic workflowAnswerAvailable;

#pragma mark - private methods

#pragma mark - initializer
- (id)initWithName:(NSString *)workflowName andSequence:(NSMutableArray *)sequence {
    
    self = [super init];
    if(self) {
        wfName_ = workflowName;
        [wfName_ retain];
        
        lifoOri_ = [NSArray arrayWithArray:sequence];
        [lifoOri_ retain];
        
        lifoWork_ = [NSMutableArray arrayWithArray:sequence];
        [lifoWork_ retain];
    }
    
    return self;
    
}

- (NSString *)nextAnswer {
    
    if([lifoWork_ count] < 1) {
        //ha ide jutunk, akkor a kliens(ek) kiszedtek minden valasz xml-t a run sequence-bol... Nem biztos, hogy ez "uzemszeru" mukodes, de egy bonyolultabb app-ban elofordulhat, hogy ugyanaz a folyamat tobb szalon, egyidoben tobbszor is meghivasra kerul... Ha ez elofordulna a jovoben, akkor at kell gondolni a koncepciot es ujraepiteni a WorkflowRunSequence peldanyt a SimulatorConfig cache-ben
        NSLog(@"!!LIFO %@ is EMPTY now!!! It should be reinited???", lifoWork_);
        return nil;
    }
    
    NSError *err;
    
    NSString *templateName = [(SimulatorResource *)[lifoWork_ lastObject]fileName];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:templateName ofType:@"xml"];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
    
    [lifoWork_ removeLastObject];
    
    return content;
}

- (BOOL)isEmpty {
    return (lifoWork_ == nil || [lifoWork_ count] == 0);
}

- (void)rebuild {
    [lifoWork_ release];
    lifoWork_ = nil;
    
    lifoWork_ = [NSMutableArray arrayWithArray:lifoOri_];
    [lifoWork_ retain];
}

- (NSString *)description {
    NSMutableString *ms = [[NSMutableString alloc]init];
    
    [ms appendString:[super description]];
    [ms appendString:@"{"];
    [ms appendFormat:@"%@", lifoWork_];
    [ms appendString:@"}"];
    
    return [ms autorelease];
    
}

#pragma mark - custom setters/getters
/*
    Ez gyakorlatilag abbol a feltetelezesbol indul ki, hogy ha a stack-en egyetlen valasz xml maradt mar csak, akkor az a VEGSO valasz lesz. Azaz valoszinuleg
 
 
 */
- (BOOL)workflowAnswerAvailable {
    BOOL available = NO;
    if([lifoWork_ count] == 1) {
        if([(SimulatorResource *)[lifoWork_ objectAtIndex:0]type] == ANSWER_READY) {
            available = YES;
        }
    }
    
    return available;
}

#pragma mark - dealloc
- (void)dealloc {
    [wfName_ release];
    [lifoOri_ release];
    [lifoWork_ release];
    
    [super dealloc];
}


@end
