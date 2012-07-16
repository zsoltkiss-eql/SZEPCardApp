//
//  SearchResultMapView.h
//  SZEPCardApp
//
//  Created by Karesz on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

@interface SearchResultMapView : UIViewController <MKMapViewDelegate>

@property (retain, nonatomic) IBOutlet MKMapView *mapView;

//a tombben AcceptancePoint objektumokat varunk el (akik mellesleg implementaljak az MKAnnotation protokollt)
@property (nonatomic, retain) NSArray *annotations;

//ez a felhasznalo aktualis helyzete. ahhoz kell, hogy az egyes elfogadohelyek callout-jain ki tudjuk szamolni es megjelniteni a tavolsagot
@property (nonatomic, retain) CLLocation *deviceLocation;

@end
