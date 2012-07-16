//
//  SearchResponseParser.m
//  SZEPCardApp
//
//  Created by Karesz on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchResponseParserDelegate.h"
#import "AcceptancePoint.h"

typedef enum {
    OUT_OF_SCOPE,
    IN_COLLECTION,
    IN_RECORD,
    IN_PROPERTY
} ParsePosition;

@interface SearchResponseParserDelegate() {
@private
    
    NSMutableString *currentProperty_;
    
    ParsePosition parsePos_;
    
    //mivel az adatstruktura tomb, ezert szerepe van a sorrendnek! Az index-bol tudjuk, melyik property-jerol van szo az AcceptancePoint objektumnak.
    int currentPropertyIndex_;
    
    //ebben gyujtjuk az AcceptancePoint objektumokat
    NSMutableArray *result_;
    
    AcceptancePoint *currentAcceptancePoint_;
}
@end

@implementation SearchResponseParserDelegate
@dynamic listOfAcceptancePoints;

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
        parsePos_ = IN_COLLECTION;
        result_ = [[NSMutableArray alloc]init];
        
    } else if([elementName isEqualToString:@"item"]) {
        if(parsePos_ == IN_COLLECTION) {
            
            //elertunk egy kulsoszintu <item> elemet 
            parsePos_ = IN_RECORD;
            
            if(currentAcceptancePoint_ != nil) {
                [currentAcceptancePoint_ release];
                currentAcceptancePoint_ = nil;
            }
            
            currentAcceptancePoint_ = [[AcceptancePoint alloc]init];
        } else if(parsePos_ == IN_RECORD) {
            parsePos_ = IN_PROPERTY;
            
            currentPropertyIndex_++;
            
            [currentProperty_ release];
            currentProperty_ = nil;
            
            currentProperty_ = [[NSMutableString alloc]init];
        }
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if([elementName isEqualToString:@"item"]) {
        
        if(parsePos_ == IN_PROPERTY) {
            
            //elertuk egy beagyazott </item> reszt, azaz egy property hatarat...
            
            switch (currentPropertyIndex_) {
                case 0: {
                    [currentAcceptancePoint_ setName:currentProperty_];
                    break;
                }
                    
                case 1: {
                    [currentAcceptancePoint_ setLodgingAccepted:[currentProperty_ integerValue]];
                    break;
                }
                    
                case 2: {
                    [currentAcceptancePoint_ setHospitalityAccepted:[currentProperty_ integerValue]];
                    break;
                }
                    
                case 3: {
                    [currentAcceptancePoint_ setLeisureAccepted:[currentProperty_ integerValue]];
                    break;
                }
                    
                case 4: {
                    [currentAcceptancePoint_ setSettlementZipCode:currentProperty_];
                    break;
                }
                    
                case 5: {
                    [currentAcceptancePoint_ setSettlementName:currentProperty_];
                    break;
                }
                    
                case 6: {
                    [currentAcceptancePoint_ setAddress:currentProperty_];
                    break;
                }
                    
                case 7: {
                    [currentAcceptancePoint_ setLatitude:[currentProperty_ doubleValue]];
                    break;
                }
                    
                case 8: {
                    [currentAcceptancePoint_ setLongitude:[currentProperty_ doubleValue]];
                    break;
                }
                    
                case 9: {
                    [currentAcceptancePoint_ setAcceptancePointID:[currentProperty_ integerValue]];
                    break;
                }
                    
                default:
                    break;
            }
            
            parsePos_ = IN_RECORD;
        } else if(parsePos_ == IN_RECORD) {
            [result_ addObject:currentAcceptancePoint_];
            parsePos_ = IN_COLLECTION;
            currentPropertyIndex_ = -1;
            
        } else if(parsePos_ == IN_COLLECTION) {
            //elhagyjuk az utolso bezaro </item> elemet is...
        }
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [currentProperty_ appendString:string];
}

#pragma mark - custom getters/setters

- (NSArray *)listOfAcceptancePoints {
    return [NSArray arrayWithArray:result_];
}

#pragma mark - dealloc
- (void)dealloc {
    
    
    [currentProperty_ release];
    
    [result_ release];
    
    [super dealloc];
}

@end
