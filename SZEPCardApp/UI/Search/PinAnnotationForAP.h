//
//  PinAnnotationForAP.h
//  SZEPCardApp
//
//  Created by Karesz on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
 
    Olyan pin view annotation implementacio, amely oriz egy referenciat az AcceptancePoint model objektumra. Igy a callout buborekon levo disclosure button megerintesekor a model objektumbol ki tudjuk olvasni az acceptancePointID-t, amit tovabb tudunk adni a detail view-nak. A detail view (AcceptancePointDetails) eezel az ID-val hivja majd meg a web service-t.
 
 */

#import <MapKit/MapKit.h>

#import "AcceptancePoint.h"


@interface PinAnnotationForAP : MKPinAnnotationView

- (id)initWithAcceptancePoint:(AcceptancePoint *)ap andReuseIdentifier:(NSString *)reuseId;

@property (nonatomic, readonly) NSInteger apId;
@property (nonatomic, readonly) CLLocation *apLocation;

@end
