//
//  SoapResponseProcessor.m
//  SZEPCardApp
//
//  Created by Karesz on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoapResponseSaver.h"

@interface SoapResponseSaver() {
@private
    NSMutableData *soapResponse_;
    BOOL finishedProcessing_;

}
@end

@implementation SoapResponseSaver
@synthesize finishedProcessing = finishedProcessing_, soapResponse = soapResponse_, controller;


#pragma mark - initializer
- (id)init {
    self = [super init];
    
    if(self) {
        soapResponse_ = [NSMutableData data];
        [soapResponse_ retain];
        finishedProcessing_ = NO;
    }
    
    return self;
}

#pragma mark - NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%@ didReceiveResponse called", [self class]);
    [soapResponse_ setLength:0];
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%@ didReceiveData called", [self class]);
    [soapResponse_ appendData:data];
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@ didFailWithError called. ERROR with theConenction.", [self class]);
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"DONE. Received Bytes: %d", [soapResponse_ length]);
    NSString *theXML = [[NSString alloc] initWithBytes: [soapResponse_ mutableBytes] length:[soapResponse_ length] encoding:NSUTF8StringEncoding];
    NSLog(@"SOAP Response: %@", theXML);
    
    finishedProcessing_ = YES;
    
    if([controller respondsToSelector:@selector(soapResponsePostProcess:)]) {
        [controller performSelector:@selector(soapResponsePostProcess:) withObject:self.soapResponse];
    }
    
}


#pragma mark - dealloc
- (void)dealloc {
    [soapResponse_ release];
    
    [super dealloc];
}

@end
