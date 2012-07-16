//
//  ParserBalanceQuery.m
//  SZEPCardApp
//
//  Created by EQL_MACMINI_3 on 2012.05.24..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParserBalanceQuery.h"

@implementation ParserBalanceQuery

@synthesize currentProperty;
@synthesize answer;

#pragma mark - very simple "parsing"


/*
+ (OutputBalanceQuery *)outputBalanceQueryBySimpleParse:(NSString *)wfAnswer {
    
    
    //    <osszeg1>, <osszeg2>, <osszeg3> keresese substring-gel...
     
    
    NSString *osszeg1 = nil, *osszeg2 = nil, *osszeg3 = nil;
    
    NSRange r1 = [wfAnswer rangeOfString:@"<osszeg1>"];
    NSRange r2 = [wfAnswer rangeOfString:@"</osszeg1>"];
    
    if(r1.location != NSNotFound && r2.location != NSNotFound) {
        osszeg1 = [wfAnswer substringWithRange:NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length)];
    }
    
    r1 = [wfAnswer rangeOfString:@"<osszeg2>"];
    r2 = [wfAnswer rangeOfString:@"</osszeg2>"];
    
    if(r1.location != NSNotFound && r2.location != NSNotFound) {
        osszeg2 = [wfAnswer substringWithRange:NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length)];
    }
    
    r1 = [wfAnswer rangeOfString:@"<osszeg3>"];
    r2 = [wfAnswer rangeOfString:@"</osszeg3>"];
    
    if(r1.location != NSNotFound && r2.location != NSNotFound) {
        osszeg3 = [wfAnswer substringWithRange:NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length)];
    }
    
    OutputBalanceQuery *obq = [[OutputBalanceQuery alloc]init];
    [obq setHospitality:osszeg1];
    [obq setLeisure:osszeg2];
    [obq setLodging:osszeg3];
    
    return [obq autorelease];
}

*/

#pragma mark - initializer
- (id) init
{
	if(self = [super init]) 
	{

		currentProperty = [[NSMutableString alloc]init];
		
	}
	return (self);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{

    self.currentProperty = nil;
	NSMutableString* s = [[NSMutableString alloc] init];
	self.currentProperty = s;
    [s release];
    
    if ([elementName isEqualToString:@"answer"]){
        answer = [[OutputBalanceQuery alloc] init];
    }

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

    if ([elementName isEqualToString:@"osszeg1"]){
        answer.hospitality =  currentProperty;
    }
    if ([elementName isEqualToString:@"osszeg2"]){
        answer.leisure = currentProperty;
    }
    if ([elementName isEqualToString:@"osszeg3"]){
        answer.lodging = currentProperty;
    }
    if ([elementName isEqualToString:@"egyenleg_datum"]){
        answer.date = currentProperty;
    }
    if ([elementName isEqualToString:@"message"]){
        answer.message = currentProperty;
    }    
	self.currentProperty = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if (self.currentProperty) {
        [currentProperty appendString:string];
    }
    
}

- (void) parseData:(NSData*) data
{
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    
	[parser setDelegate:self]; // The parser calls methods in this class
    [parser setShouldProcessNamespaces:NO]; // We don't care about namespaces
    [parser setShouldReportNamespacePrefixes:NO]; //
    [parser setShouldResolveExternalEntities:NO]; // We just want data, no other stuff
    [parser parse]; // Parse that data..
    
    if (parser.parserError != nil){
    
        NSLog(@"ERROR: %@", parser.parserError);
        
    }
    
    [parser release];
    
    
}

@end
