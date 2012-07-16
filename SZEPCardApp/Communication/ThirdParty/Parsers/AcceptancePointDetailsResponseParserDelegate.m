//
//  AcceptancePointDetailsResponseParserDelegate.m
//  SZEPCardApp
//
//  Created by Karesz on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AcceptancePointDetailsResponseParserDelegate.h"

#import "AcceptancePoint.h"

typedef enum {
    OUT_OF_SCOPE,
    IN_RECORD,
    IN_PROPERTY
} ParsePosition;

@interface  AcceptancePointDetailsResponseParserDelegate() {
@private
    NSMutableString *currentProperty_;
    
    ParsePosition parsePos_;
    
    //mivel az adatstruktura tomb, ezert szerepe van a sorrendnek! Az index-bol tudjuk, melyik property-jerol van szo az AcceptancePoint objektumnak.
    int currentPropertyIndex_;
    
    //az elfogadohelyReszletesAdatai WS egyetlen rekordot ad vissza
    AcceptancePoint *acceptancePoint_;
}
@end

@implementation AcceptancePointDetailsResponseParserDelegate
@synthesize acceptancePoint = acceptancePoint_;

#pragma mark - initializer
- (id)init {
    self = [super init];
    
    if(self) {
        
        //mivel 2-szeresen egymasba agyazott <item> elemek vannak, a legkulso <item> elerese jelenti egy record-nak a hatarat
        parsePos_ = OUT_OF_SCOPE;
        currentProperty_ = [[NSMutableString alloc]init];
        
        currentPropertyIndex_ = -1;
    }
    
    return self;
}


#pragma mark - NSXMLParserDelegate protocol

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if([elementName isEqualToString:@"return"]) {
        parsePos_ = IN_RECORD;
        acceptancePoint_ = [[AcceptancePoint alloc]init];
        
    } else if([elementName isEqualToString:@"item"]) {
        if(parsePos_ == IN_RECORD) {
            
            currentPropertyIndex_++;
            
            [currentProperty_ release];
            currentProperty_ = nil;
            
            currentProperty_ = [[NSMutableString alloc]init];
            
            parsePos_ = IN_PROPERTY;
        }
    }
    
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    
    if([elementName isEqualToString:@"item"]) {
        
        if(parsePos_ == IN_PROPERTY) {
            
            //elertuk egy beagyazott </item> reszt, azaz egy property hatarat...
            
            switch (currentPropertyIndex_) {
                case 0: {
                    [acceptancePoint_ setImageUrl1:currentProperty_];
                    break;
                }
                    
                case 1: {
                    [acceptancePoint_ setImageUrl2:currentProperty_];
                    break;
                }
                    
                case 2: {
                    [acceptancePoint_ setImageUrl3:currentProperty_];
                    break;
                }
                    
                case 3: {
                    [acceptancePoint_ setImageUrl4:currentProperty_];
                    break;
                }
                    
                case 4: {
                    [acceptancePoint_ setImageUrl5:currentProperty_];
                    break;
                }
                    
                case 5: {
                    [acceptancePoint_ setName:currentProperty_];
                    break;
                }
                    
                case 6: {
                    [acceptancePoint_ setCategory:currentProperty_];
                    break;
                }
                    
                case 7: {
                    [acceptancePoint_ setSettlementZipCode:currentProperty_];
                    break;
                }
                    
                case 8: {
                    [acceptancePoint_ setSettlementName:currentProperty_];
                    break;
                }
                    
                case 9: {
                    [acceptancePoint_ setAddress:currentProperty_];
                    break;
                }
                    
                case 10: {
                    [acceptancePoint_ setPhone:currentProperty_];
                    break;
                }
                    
                case 11: {
                    [acceptancePoint_ setEmail:currentProperty_];
                    break;
                }
                    
                case 12: {
                    [acceptancePoint_ setWebsite:currentProperty_];
                    break;
                }
                    
                case 13: {
                    [acceptancePoint_ setPaymentInAdvance:[currentProperty_ integerValue]];
                    break;
                }
                    
                case 14: {
                    [acceptancePoint_ setLodgingAccepted:[currentProperty_ integerValue]];
                    break;
                }
                    
                case 15: {
                    [acceptancePoint_ setHospitalityAccepted:[currentProperty_ integerValue]];
                    break;
                }
                    
                case 16: {
                    [acceptancePoint_ setLeisureAccepted:[currentProperty_ integerValue]];
                    break;
                }
                    
                case 17: {
                    [acceptancePoint_ setDesc:currentProperty_];
                    break;
                }  
                    
                default:
                    break;
                    
            }
            
            parsePos_ = IN_RECORD;
            
        }
        
    }
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [currentProperty_ appendString:string];
}

#pragma mark - dealloc
- (void)dealloc {
    
    [currentProperty_ release];
    [acceptancePoint_ release];
    
    [super dealloc];
}

@end
