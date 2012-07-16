//
//  SoapUtil.h
//  SZEPCardApp
//
//  Created by Karesz on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define SZEP_CARD_SERVICE_URL @"http://127.0.0.1:9876/szep"       //dummy ws

#define SZEP_CARD_SERVICE_URL @"https://otpszepkartya.hu/wsm"         //FINIT ws

// #define MWACCES_PUBLIC_SERVICE_URL @"http://192.168.214.31:63001/mwaccesspublic/mwaccess"
#define MWACCES_PUBLIC_SERVICE_URL @"http://192.168.214.63:17001/mwaccesspublic/mwaccess" 

#define SZEP_CARD_SERVICE_AUTH_USER @"wsm_user"
#define SZEP_CARD_SERVICE_AUTH_PW @"TeJFbb9A3ANqFU6C"

@interface SoapUtil : NSObject


+ (NSString *)createSoapMessage:(NSString *)soapTemplateName withParams:(NSArray *)params;

+ (void)sendSoapMessage:(NSString *)soapMessage toUrl:(NSString *)url usingHeaders:(NSDictionary *)headers andDelegate:(id<NSURLConnectionDelegate>)delegate;

+ (NSString *)sendSoapMessage:(NSString *)soapMessage toUrl:(NSString *)url;

+ (void)connectionTest:(id<NSURLConnectionDelegate>)delegate;

@end
