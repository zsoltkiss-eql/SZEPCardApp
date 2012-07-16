//
//  SimulatorResource.h
//  SZEPCardApp
//
//  Created by Karesz on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
    Sima VO, amely leir egy answer type-ot es az ot reprezentalo konkret xml fajlt.
 
 */

#import <Foundation/Foundation.h>

//mwacces public WS-en meghivott szolgaltasok "tipusai". Mivel a leggyakoribb esetben a startWorkflow, majd a startWorkflowState metodusokat hivjuk a WS-en, ezekre epulnek a szimulacioban alkalmazott SOAP response-ok tipusai...
typedef enum {
    RUN_WORKFLOW,               //startWorkflowResponse.xml
    POLLING,                    //getWorkflowStateResponse.xml
    ANSWER_READY                //tetszoleges xml, amiben mar csak middleware-es folyamat valasz van, SOAP nincs
} ResponseType;

@interface SimulatorResource : NSObject

@property (nonatomic, readonly) ResponseType type;
@property (nonatomic, readonly) NSString *fileName;

+ (SimulatorResource *)simulatorResourceRunWorkflow;
+ (SimulatorResource *)simulatorResourcePolling;

- (id)initWithType:(ResponseType)type andFileName:(NSString *)file;

@end
