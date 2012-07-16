//
//  SearchResponseParser.h
//  SZEPCardApp
//
//  Created by Karesz on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResponseParserDelegate : NSObject <NSXMLParserDelegate>



@property (nonatomic, readonly) NSArray *listOfAcceptancePoints;

@end



/*
 
 
 
 
 <S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">
 <S:Body>
 <ns2:elfogadohelyekTelepulesenResponse xmlns:ns2="http://service.szepcard.otp.eqlsoft.hu/">
 <return>
 <item xsi:type="ns4:anyTypeArray" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns4="http://jaxb.dev.java.net/array">
 <item xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema">Joó Panzió</item>
 <item xsi:type="xs:int" xmlns:xs="http://www.w3.org/2001/XMLSchema">1</item>
 <item xsi:type="xs:int" xmlns:xs="http://www.w3.org/2001/XMLSchema">0</item>
 <item xsi:type="xs:int" xmlns:xs="http://www.w3.org/2001/XMLSchema">0</item>
 <item xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema">6722</item>
 <item xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema">Szeged</item>
 <item xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema">Londoni krt. 27</item>
 <item xsi:type="xs:double" xmlns:xs="http://www.w3.org/2001/XMLSchema">22.1234</item>
 <item xsi:type="xs:double" xmlns:xs="http://www.w3.org/2001/XMLSchema">129.9987</item>
 <item xsi:type="xs:int" xmlns:xs="http://www.w3.org/2001/XMLSchema">7795</item>
 </item>
 <item xsi:type="ns4:anyTypeArray" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns4="http://jaxb.dev.java.net/array">
 <item xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema">Kata Luxus Panzió</item>
 <item xsi:type="xs:int" xmlns:xs="http://www.w3.org/2001/XMLSchema">1</item>
 <item xsi:type="xs:int" xmlns:xs="http://www.w3.org/2001/XMLSchema">1</item>
 <item xsi:type="xs:int" xmlns:xs="http://www.w3.org/2001/XMLSchema">1</item>
 <item xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema">6722</item>
 <item xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema">Szeged</item>
 <item xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema">Bólyai út 20</item>
 <item xsi:type="xs:double" xmlns:xs="http://www.w3.org/2001/XMLSchema">22.5796</item>
 <item xsi:type="xs:double" xmlns:xs="http://www.w3.org/2001/XMLSchema">129.0012</item>
 <item xsi:type="xs:int" xmlns:xs="http://www.w3.org/2001/XMLSchema">6840</item>
 </item>
 </return>
 </ns2:elfogadohelyekTelepulesenResponse>
 </S:Body>
 </S:Envelope>
 
 
 
 */
