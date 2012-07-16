//
//  SoapUtil.m
//  SZEPCardApp
//
//  Created by Karesz on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoapUtil.h"
#import "SimulatorConfig.h"
#import "WorkflowRunSequence.h"
#import "WorkflowPoller.h"
#import "Base64Impl.h"

/*
    Regi WSUtil-bol lettek idemasolva az alabbiak. Majd a middleware hivashoz ilyesmi URL kell.
 
 //#define WSURL @"http://192.168.214.65:17001/"
 // #define WSURL @"http://10.56.5.238:17001/"
 #define WSURL @"http://192.168.214.31:63001/"
 
 // eles szerver
 // #define WSURL @"https://www.otpbankdirekt.hu/"
 
 */

/*
    Middleware hivasok:
 
    mwaccespublic webservice-en a startWorkflow metodust kell hivni, ez default-kent ASZINKRON hivast csinal.
 
    (Ha szinkron hivast akarunk, akkor a startWorkflowSynch-et kell hivni.)
 
    Az aszinkron valaszban a %IP_CIM%;%TR_ID%;%WF_NAME% harmas jon vissza, ezzel kell pollozni! 
 
    Pollozas: az mwaccespublic web service-re kivezetett getWorkflowState metodust kell hivogatni. A pollozas maga adott idokozonkent ennek a WS metodusnak a meghivasat jelenti. Egeszen addig kell hivogatni, amig  FINISHED-et nem ad vissza. Ilyenkor a visszakapott SOAP valaszban benne lesz a konkret folyamatra kapott folyamat valasz is!!! 
 
    A SOAP valaszban mindig Base64 encoded tartalom van, ezeket a Poller.m-ben levo + (NSData *)base64DataFromString: (NSString *)string metodussal lehet dekodolni.
 
 
 */

@implementation SoapUtil


+ (NSString *)createSoapMessage:(NSString *)soapTemplateName withParams:(NSArray *)params {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:soapTemplateName ofType:@"xml"];
    
    NSError *err;
    
    NSString *soapMessage = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
    
    NSString *soapWithParams = (params == nil || [params count] == 0) ? soapMessage : nil;
    
    if(soapWithParams == nil) {
        switch ([params count]) {
                //Gagyi megoldas, tudom :). De a mi jelenlegi osszes esetunkhoz eleg.
            case 1: {
                soapWithParams = [NSString stringWithFormat:soapMessage, [params objectAtIndex:0]];
                break;
            }
                
            case 2: {
                soapWithParams = [NSString stringWithFormat:soapMessage, [params objectAtIndex:0], [params objectAtIndex:1]];
                break;
            }
                
            case 3: {
                soapWithParams = [NSString stringWithFormat:soapMessage, [params objectAtIndex:0], [params objectAtIndex:1], [params objectAtIndex:2]];
                break;
            }
                
            case 4: {
                soapWithParams = [NSString stringWithFormat:soapMessage, [params objectAtIndex:0], [params objectAtIndex:1], [params objectAtIndex:2], [params objectAtIndex:3]];
                break;
            }
                
            case 5: {
                soapWithParams = [NSString stringWithFormat:soapMessage, [params objectAtIndex:0], [params objectAtIndex:1], [params objectAtIndex:2], [params objectAtIndex:3], [params objectAtIndex:4]];
                break;
            }

            case 6: {
                soapWithParams = [NSString stringWithFormat:soapMessage, [params objectAtIndex:0], [params objectAtIndex:1], [params objectAtIndex:2], [params objectAtIndex:3], [params objectAtIndex:4], [params objectAtIndex:5]];
                break;
            }
                
            default:
                break;
        }
    }
    
    NSLog(@"SOAP message created: %@", soapWithParams);
    
    return soapWithParams;
    
}


#ifndef USE_SIMULATOR
/*
    Elvarjuk, hogy mar egy KESZ soap message-et kapjon a metodus, amibe be vannak helyettesitve a szukseges parameterek.
    A http valaszt itt delegate pattern alapjan szerezzuk meg, azaz az atvett delegate parameteren lesznek majd callback hivasok. Ezzel a labdat visszapasszoltuk a kliensnek, akinek szinten kell hogy referenciaja legyen a delgate-ra, vagy esetleg o maga az!
 
 */
+ (void)sendSoapMessage:(NSString *)soapMessage toUrl:(NSString *)url usingHeaders:(NSDictionary *)headers andDelegate:(id<NSURLConnectionDelegate>)delegate {
    
    NSURL *nsUrl = [NSURL URLWithString:url];
    
    
    
    
    //FINIT ws authentication
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", SZEP_CARD_SERVICE_AUTH_USER, SZEP_CARD_SERVICE_AUTH_PW];
    //NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    
    //NSString *content = [[[NSString alloc] initWithData:authData encoding:NSASCIIStringEncoding] autorelease];
                                               
    
    //NSString *authValue = [NSString stringWithFormat:@"Basic %@", [WorkflowPoller base64DataFromString:authStr]];
    
    NSString *encodedLoginData = [Base64Impl encode:[authStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *authHeader = [@"Basic " stringByAppendingFormat:@"%@", encodedLoginData]; 
    
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:nsUrl];
    //NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue:@"text/xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:url forHTTPHeaderField:@"SOAPAction"];
    //[theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    
    //[theRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    [theRequest addValue:authHeader forHTTPHeaderField:@"Authorization"];
    
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    //a magyaron volt timeout header is beallitva...
    [theRequest setTimeoutInterval:60];
    
    
    //NSLog(@"Message Length..%@", msgLength);
    
    //MEGOLDAS #1
    /*
    NSHTTPURLResponse* response = nil;
	NSError *error = [[NSError alloc] init];
	NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
     */
	
    
    
    //MEGOLDAS #2
    /**/
    NSURLConnection *theConnection = [[NSURLConnection alloc]initWithRequest:theRequest delegate:delegate];
    
    //[SoapUtil connectionTest:delegate];
    
    if(theConnection) {
        //NSLog(@"SOAP request was send to %@", url);
    } else {
        NSLog(@"!!! NSURLConnection is NULL !!! Url: %@", url);
    }
     
    
    
}
#else
+ (void)sendSoapMessage:(NSString *)soapMessage toUrl:(NSString *)url usingHeaders:(NSDictionary *)headers andDelegate:(id)delegate {
    
    NSLog(@"SIMULATOR »» %@ sendSoapMessage", [SoapUtil class]);
    NSLog(@"SOAP REQUEST:");
    NSLog(@"%@", soapMessage);
    
}
#endif

#ifndef USE_SIMULATOR
/*szinkron http keressel SOAP uzenet kuldese. Tipikusan a middleware pollozashoz irodott*/
+ (NSString *)sendSoapMessage:(NSString *)soapMessage toUrl:(NSString *)url {
    
    NSURL *nsUrl = [NSURL URLWithString:url];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:nsUrl];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:url forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    //a magyaron volt timeout header is beallitve...
    [theRequest setTimeoutInterval:60];
    
    NSHTTPURLResponse* response = nil;
    NSError *error = [[NSError alloc] init];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    NSString *theXML = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
    
    return [theXML autorelease];
}

#else

+ (NSString *)sendSoapMessage:(NSString *)soapMessage toUrl:(NSString *)url {
    
    NSLog(@"SIMULATOR »» %@ sendSoapMessage", [SoapUtil class]);
    //NSLog(@"SOAP REQUEST:");
    //NSLog(@"%@", soapMessage);
    
    //<arg0 xsi:type="xsd:string">%@</arg0>
    
    //A soap request-bol kivesszuk az inditando folyamat nevet
    //FONTOS: a folyamat nev kinyerese eltero algoritmust kivan meg a startWorkflow es a getWorkflowState eseteben!
    
    NSRange r1 = [soapMessage rangeOfString:@"<arg0 xsi:type=\"xsd:string\">"];
    NSRange r2 = [soapMessage rangeOfString:@"</arg0>"];
    
    NSRange r3 = NSMakeRange(r1.location + r1.length, r2.location - (r1.location + r1.length));
    
    //ha a startWorkflow hivas van akkor ennyi eleg, itt mar valoban a helyes folyamat nev lesz a wfName-ben. De ha a getWorkflowState hivasban vagyunk, akkor meg tovabbi string muveletek kellenek!
    NSString *wfName = [soapMessage substringWithRange:r3];
    
    if([soapMessage rangeOfString:@"getWorkflowState"].location != NSNotFound) {
        //ha egy getWorkflowState SOAP message-dzsel van dolgunk, akkor a regexp is kell, ui. a wfName string-ben a %wf name%;%tr id%;%ip cim% harmas van ilyenkor
        
        NSRange r4 = [wfName rangeOfString:@";"];
        if(r4.location != NSNotFound) {
            wfName = [wfName substringToIndex:r4.location];
        }
    }
    
    
    WorkflowRunSequence *wrs = [SimulatorConfig runSequenceFor:wfName];
    NSLog(@"SIMULATOR »» wrs for %@ (BEFORE popping): %@", wfName, wrs);
    
    return [wrs nextAnswer];
    

}



#endif

////////////////////////////////
+ (void)connectionTest:(id<NSURLConnectionDelegate>)delegate {
    
    NSURL *szepCardUrl = [NSURL URLWithString:SZEP_CARD_SERVICE_URL];
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:SZEP_CARD_SERVICE_AUTH_USER password:SZEP_CARD_SERVICE_AUTH_PW persistence:NSURLCredentialPersistenceForSession];
    NSString *host = [szepCardUrl host];
    NSNumber *port = [szepCardUrl port];
    NSString *protocol = [szepCardUrl scheme];
    NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:host port:[port integerValue] protocol:protocol realm:nil authenticationMethod:NSURLAuthenticationMethodHTTPBasic];
    [[NSURLCredentialStorage sharedCredentialStorage] setDefaultCredential:credential forProtectionSpace:protectionSpace];
    
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", SZEP_CARD_SERVICE_AUTH_USER, SZEP_CARD_SERVICE_AUTH_PW];
    NSString *encodedLoginData = [Base64Impl encode:[authStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *authHeader = [@"Basic " stringByAppendingFormat:@"%@", encodedLoginData]; 
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:szepCardUrl];
    BOOL manuallyAddAuthorizationHeader = NO;
    if (manuallyAddAuthorizationHeader)
    {
        //NSData *authoritazion = [[NSString stringWithFormat:@"%@:%@", user, password] dataUsingEncoding:NSUTF8StringEncoding];
        //NSString *basic = [NSString stringWithFormat:@"Basic %@", [authoritazion performSelector:@selector(base64Encoding)]];
        [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
    }
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
    [connection start];
}



@end
