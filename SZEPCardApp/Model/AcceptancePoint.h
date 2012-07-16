//
//  AcceptancePoint.h
//  SZEPCardApp
//
//  Created by Karesz on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*
 Elfogado hely uzleti objektum reprezentacioja.
 
 */

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

/*
 A www.otpszepkartya.hu oldalon lekertem talalomra nehany elfogadohelyet, de egyelore meg csak olyat talaltam, ahol a fizetesi mod a "Helyben" szoveg volt. Ha kesobb kiderul, mik lehetnek meg akkor ide fel kell venni az enumba.
 */
typedef enum {
    HELYBEN
} PaymentMethod;

@interface AcceptancePoint : NSObject <MKAnnotation>

@property (nonatomic, assign) NSInteger acceptancePointID;

@property (nonatomic, retain) NSString *name;

@property (nonatomic, assign) NSInteger lodgingAccepted;
@property (nonatomic, assign) NSInteger hospitalityAccepted;
@property (nonatomic, assign) NSInteger leisureAccepted;
           

@property (nonatomic, retain) NSString *imageUrl1;
@property (nonatomic, retain) NSString *imageUrl2;
@property (nonatomic, retain) NSString *imageUrl3;
@property (nonatomic, retain) NSString *imageUrl4;
@property (nonatomic, retain) NSString *imageUrl5;

@property (nonatomic, retain) NSString *settlementName;
@property (nonatomic, retain) NSString *settlementZipCode;

//utca, hazszam
@property (nonatomic, retain) NSString *address;

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@property (nonatomic, retain) NSString *category;

@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *website;

//elore fizetes (YES/NO) ill. 0 vagy 1
@property (nonatomic, assign) NSInteger paymentInAdvance;

//leiras; nem lehet "description" a property neve, mert akkor osszekeveredik a "toString" implementacioval
@property (nonatomic, retain) NSString *desc;


//kenyelmi metodus, ennek az elfogadohelynek a tavolsgat szamitja ki az atvett pontetol (from)
- (CLLocationDistance)calculateDistanceFrom:(CLLocation *)there;



@end
