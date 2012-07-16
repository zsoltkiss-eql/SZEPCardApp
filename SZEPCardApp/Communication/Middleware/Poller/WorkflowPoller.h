//
//  WorkflowPoller.h
//  SZEPCardApp
//
//  Created by Karesz on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WorkflowPoller;

@protocol WorkflowPollerDelegate <NSObject>

-(void)pollerDidFinishPolling:(WorkflowPoller *)poller;

@end

@interface WorkflowPoller : NSObject {
	
}

+ (NSString *) searchForPollString:(NSString *)soapMessage;

+ (NSData *)base64DataFromString: (NSString *)string;

- (id)initWithPollString:(NSString *)pollString;

- (void)poll;

/*
 Ez ha minden jol ment a folyamat hivassal, akkor valoban soapResponse lesz.
 Ha timeout tortent, akkor viszont NIL-t adjon vissza. Ilyenkor ui. - mivel nem volt sikeres a pollozas - nincs is soapResponse-unk. 
 
 A kliens majd ezt a property-t kerje le, ha a teljes soap response-ot meg akarja vizsgalni. 
 
 
 */
@property (nonatomic, readonly) NSString *soapResponse;

/*
 A MiddlewarePoller a SOAP response-bol vissza tudja adni csak azt a fragment-et is, ami mar valoban a folyamat valasza. Az eredeti soap response-ban ez Base64 kodolassal van benne, de amit itt visszaadunk, az mar dekodolva van!
 */
@property (nonatomic, readonly) NSString *workflowAnswer;

//@property (nonatomic, readonly) NSData *workflowAnswerAsData;

//assign property, nem szabad release-elni sehol
@property (nonatomic, assign) id<WorkflowPollerDelegate> delegate;

@end
