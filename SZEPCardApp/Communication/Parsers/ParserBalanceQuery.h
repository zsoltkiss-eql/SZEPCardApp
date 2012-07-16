//
//  ParserBalanceQuery.h
//  SZEPCardApp
//
//  Created by EQL_MACMINI_3 on 2012.05.24..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OutputBalanceQuery.h"

@interface ParserBalanceQuery : NSObject <NSXMLParserDelegate>{
	NSMutableString *currentProperty;

}


@property (nonatomic, retain) OutputBalanceQuery *answer;
@property (nonatomic, retain) NSMutableString *currentProperty;


//+ (OutputBalanceQuery *)outputBalanceQueryBySimpleParse:(NSString *)wfAnswer;

- (void) parseData:(NSData*) data;




@end
