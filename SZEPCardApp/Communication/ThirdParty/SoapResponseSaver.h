//
//  SoapResponseProcessor.h
//  SZEPCardApp
//
//  Created by Karesz on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
    Web service SOAP response feldolgozosaert felelos osztaly.
    Amire alkalmas: gyujtogeti a http valaszbol az adatokat, es amikor ugy talalja, hogy minden byte beerkezett, akkor beallitja magan a finishedProcessing flag-et YES-re.
 
 */

#import <Foundation/Foundation.h>

@interface SoapResponseSaver : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, readonly) BOOL finishedProcessing;
@property (nonatomic, readonly) NSMutableData *soapResponse;     //ebben lesz a soap xml! a kliensnek meg parse-olnia kell...

@property (nonatomic, assign) id controller;

@end
