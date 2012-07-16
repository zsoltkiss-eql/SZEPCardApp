//
//  SettlementSearchResponseParserDelegate.h
//  SZEPCardApp
//
//  Created by Karesz on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettlementSearchResponseParserDelegate : NSObject <NSXMLParserDelegate>

@property (nonatomic, readonly) NSArray *listOfSettlements;

@end
