//
//  WorkflowPoller.m
//  SZEPCardApp
//
//  Created by Karesz on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorkflowPoller.h"
#import "SoapUtil.h"
#import "SoapResponseSaver.h"
#import "SimulatorConfig.h"
#import "WorkflowRunSequence.h"

/*
 Pollozas: adott idokozonkent meg kell hivni az mwaccesspublic WS-en a getWorkflowState metodust. Ez a metodus egyetlen xsd:string tipusu parametert vesz at. Parameterul azt a stringet kell atadni, amelyet a middleware folyamat aszinkron meghivasakor a startWorkflow WS metodus visszaadott. Ennek a string-nek a formatuma: %FOLYAMAT_NEVE%;%TR_ID%;%WIP_CIM:PORT%.
 
 A Poller egy tipikusan ALLAPOTTAROLO tipusu objektum, ezert tobb ertelme van peldany metodusokkal dolgozni, mint csupan class (statikus) metodusokkal.
 
 A Poller peldanyt egy konkret pollString-re initeljuk, hogy vegig az eletciklusa folyaman tudja, kire kell polloznia. A pollString_ egy private valtozoja lesz ezert. Szinten allapot jellemzo az az NSDate, amikor a pollozás el lett inditva!  Max 120 masodpercig pollozunk, utana hibat jelzunk. Allapot tovabba, hogy eppen "fut" (polloz), mar elkezdte es meg tart, ezert a kliens NE HIVJA MEG UJRA a poll metodust... Stb., stb., csomo olyan dolog, ami miatt szerencsesebb, ha a Poller egy peldanyosithato vlmi es nem csak egy class metodus gyujtemenybol allo util osztaly.
 
 */


#define POLLING_INTERVAL 3      //masodpercben
#define POLLING_TIMEOUT  120    //max. ennyi masodpercig pollozunk a [Poller poll] metodus meghivasatol szamitva, utana hibat jelzunk


typedef enum {
    TIMEOUT,
    COMMUNICATION_ERROR
} PollerError;

@interface WorkflowPoller() {
@private
    
    //ez az a string amire pollozunk. Formatuma: %FOLYAMAT_NEV%;%TR_ID%;%IP_CIM%
    NSString *pollString_;
    
    // a teljes soap response, amennyiben sikerult megszerezni
    NSString *soapResponse_;
    
    //csak a middleware folyamat valasz, ugy, hogy a Base64 dekodolas mar el lett vegezve rajta
    //NSString *workflowAnswer_;
    
    //ezzel jelezzuk, hogy ez a poller peldanyt mar el lett inditva. Hogy ne lehessen 1-nel tobbszor meghivni rajta a poll metodust
    BOOL running_;
    
    //ezzel jelezzuk, hogy ez a poller peldany mar le lett allitva. Akar azert, mert megvan a valasz, akar azert, mert hibara futott, timeout-olt stb...
    BOOL stopped_;
    
    //a vegso valasz megvan-e
    BOOL answerReceived_;
    
    NSDate *pollerStartingDate_;
    
    NSInteger errorCode_;
}

- (NSString *) sendPollRequest;
- (BOOL) completed:(NSString *)pollAnswer;

@end

@implementation WorkflowPoller
@synthesize soapResponse = soapResponse_, delegate;
@dynamic workflowAnswer;


#pragma mark - class methods


+ (NSString *)searchForPollString:(NSString *)soapMessage{

    NSRange r1 = [soapMessage rangeOfString:@"<return xsi:type=\"xsd:string\">"];
	NSRange r2 = [soapMessage rangeOfString:@"</return>"];
	
		
	if(r1.length <= 0 || r2.length <=0)
	{
		NSLog(@"Pollstring not found!");
	}
    
	
	NSRange r = NSMakeRange(r1.location + r1.length, r2.location - r1.location-r1.length); 
	NSString* pollstring = [soapMessage substringWithRange:r];
	
    NSString* regex = @"\\w*;\\d*;[0-9.:]*";
    NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    if ([regextest evaluateWithObject:pollstring]){
    
        return pollstring; 
        
    }
    
    else {
        return nil;
    }
    
}



+ (NSData *)base64DataFromString: (NSString *)string {
	unsigned long ixtext, lentext;
	unsigned char ch, input[4], output[3];
	short i, ixinput;
	Boolean flignore, flendtext = false;
	const char *temporary;
	NSMutableData *result;
	
	if (!string) {
		return [NSData data];
	}
	
	ixtext = 0;
	
	temporary = [string UTF8String];
	
	lentext = [string length];
	
	result = [NSMutableData dataWithCapacity: lentext];
	
	ixinput = 0;
	
	while (true) {
		if (ixtext >= lentext) {
			break;
		}
		
		ch = temporary[ixtext++];
		
		flignore = false;
		
		if ((ch >= 'A') && (ch <= 'Z')) {
			ch = ch - 'A';
		} else if ((ch >= 'a') && (ch <= 'z')) {
			ch = ch - 'a' + 26;
		} else if ((ch >= '0') && (ch <= '9')) {
			ch = ch - '0' + 52;
		} else if (ch == '+') {
			ch = 62;
		} else if (ch == '=') {
			flendtext = true;
		} else if (ch == '/') {
			ch = 63;
		} else {
			flignore = true;
		}
		
		if (!flignore) {
			short ctcharsinput = 3;
			Boolean flbreak = false;
			
			if (flendtext) {
				if (ixinput == 0) {
					break;
				}
				
				if ((ixinput == 1) || (ixinput == 2)) {
					ctcharsinput = 1;
				} else {
					ctcharsinput = 2;
				}
				
				ixinput = 3;
				
				flbreak = true;
			}
			
			input[ixinput++] = ch;
			
			if (ixinput == 4) {
				ixinput = 0;
				
				output[0] = (input[0] << 2) | ((input[1] & 0x30) >> 4);
				output[1] = ((input[1] & 0x0F) << 4) | ((input[2] & 0x3C) >> 2);
				output[2] = ((input[2] & 0x03) << 6) | (input[3] & 0x3F);
				
				for (i = 0; i < ctcharsinput; i++) {
					[result appendBytes: &output[i] length: 1];
				}
			}
			
			if (flbreak) {
				break;
			}
		}
	}
	
	return result;
}


#pragma mark - initializer
- (id)initWithPollString:(NSString *)pollString {
    self = [super init];
    if(self) {
        pollString_ = [[NSString alloc]initWithFormat:@"%@", pollString];   //retainCount-ja 1 lesz! Szandekos!
        answerReceived_ = NO;
        running_ = NO;
        stopped_ = NO;
        errorCode_ = -99;       //minden OKE
    }
    
    return self;
}

#pragma mark - public methods

- (void)poll {
    if(running_) {
        NSLog(@"This Poller instance %@ already running. You must not run it once again.", self);
        return;
    }
    
    if(stopped_) {
        NSLog(@"This Poller instance %@ has been stopped. You must not run it once again.", self);
        return;
    }
    
    pollerStartingDate_ = [NSDate date];
    [pollerStartingDate_ retain];
    
    running_ = YES;
    
    while (!answerReceived_  || !stopped_) {
        [NSThread sleepForTimeInterval:POLLING_INTERVAL];
        NSString *pollAnswer = [self sendPollRequest];
        
        if([self completed:pollAnswer]) {
#ifndef USE_SIMULATOR
            soapResponse_ = pollAnswer;
#else
            WorkflowRunSequence *wrs = [SimulatorConfig runSequenceFor:@"HB_BEJELENTKEZES"];
            
            //ez szimulator valasz (csak folyamat), NEM SOAP!
            NSString *wfAnswer = [wrs nextAnswer];
            soapResponse_ = [SoapUtil createSoapMessage:@"getWorkflowStateResponse_COMPLETED" withParams:[NSArray arrayWithObjects:wfAnswer, @"HB_BEJELENTKEZES", nil]];
            
#endif
            [soapResponse_ retain];
            
            answerReceived_ = YES;
            stopped_ = YES;
            
            if(delegate != nil) {
                [delegate pollerDidFinishPolling:self];
            }
            
        }
    }
    
    running_ = NO;
    stopped_ = YES;
}

#pragma mark - private methods

- (NSString *) sendPollRequest {
    
    if([[NSDate date] timeIntervalSinceDate:pollerStartingDate_] > POLLING_TIMEOUT) {
        NSLog(@"Poller instance %@ timeout. Poll string: %@", self, pollString_);
        running_ = NO;
        stopped_ = YES;
        
        //ilyenkor a regi Poller megoldas egy elore gyartott xml-t adott vissza valaszkent, amiben figyelmezeteto uzenet volt...
        
        errorCode_ = TIMEOUT;
        
        return nil;
    }
    
    NSString *soapRequest = [SoapUtil createSoapMessage:@"getWorkflowState" withParams:[NSArray arrayWithObject:pollString_]];
    NSString *soapResponse = [SoapUtil sendSoapMessage:soapRequest toUrl:MWACCES_PUBLIC_SERVICE_URL];
    
	return soapResponse;
}

#ifndef USE_SIMULATOR
/*
 
 A poll answerben keresi, hogy elofordul-e a <completed>true</completed> tag
 */
- (BOOL) completed:(NSString *)pollAnswer {
    NSRange r = [pollAnswer rangeOfString:@"<completed xsi:type=\"xsd:boolean\">true</completed>"];
    
    if(r.length > 0) {
        //megvan a valasz
        return YES;
    }
    
    //nincs meg a valasz, majd tovabb kell pollozni...
    return NO;
}

#else
- (BOOL) completed:(NSString *)pollAnswer {
    
    //itt deritjuk ki, hogy kell-e tovabb pollozni...
    
    WorkflowRunSequence *wrs = [SimulatorConfig runSequenceFor:@"HB_BEJELENTKEZES"];
    
    return [wrs workflowAnswerAvailable];
    
}

#endif

#pragma mark - custom getters/setters

- (NSString *)workflowAnswer {
    if(answerReceived_ && soapResponse_ != nil) {
        NSRange r1 = [soapResponse_ rangeOfString:@"<result xsi:type=\"xsd:base64Binary\">"];
		NSRange r2 = [soapResponse_ rangeOfString:@"</result>"];
		NSRange r = NSMakeRange(r1.location + r1.length, r2.location - r1.location-r1.length); 
        
        NSString *wfAnswer = nil;
        
#ifndef USE_SIMULATOR
        //ez fogja tartalmazni a kodolt string-et ("krikszkraksz")
		NSString* base64EncodedString = [soapResponse_ substringWithRange:r];
        
        //ez mar a visszafejtett folyamat valasz, csak NSData wrapper-be van csomagolva
		NSData* dataDecoded = [WorkflowPoller base64DataFromString:base64EncodedString];
        
        wfAnswer = [[NSString alloc] initWithBytes:[dataDecoded bytes] length:[dataDecoded length] encoding:NSUTF8StringEncoding];
#else
        //szimulatoros esetben NINCS base64 enkodolas, igy nincs is mit dekodolni!!!
        wfAnswer = [soapResponse_ substringWithRange:r];
#endif

        return wfAnswer;
    }
    
    return nil;
}

/*
- (NSData *)workflowAnswerAsData {
    NSRange r1 = [soapResponse_ rangeOfString:@"<result xsi:type=\"xsd:base64Binary\">"];
    NSRange r2 = [soapResponse_ rangeOfString:@"</result>"];
    NSRange r = NSMakeRange(r1.location + r1.length, r2.location - r1.location-r1.length); 
    
    //ez fogja tartalmazni a kodolt string-et ("krikszkraksz")
    NSString* base64EncodedString = [soapResponse_ substringWithRange:r];
    
    //ez mar a visszafejtett folyamat valasz, csak NSData wrapper-be van csomagolva
    NSData* dataDecoded = [WorkflowPoller base64DataFromString:base64EncodedString];
    
    return dataDecoded;
}
 */

#pragma mark - dealloc

- (void)dealloc {
    [pollString_ release];
    [pollerStartingDate_ release];
    [soapResponse_ release];
    
    
    [super dealloc];
}




@end
