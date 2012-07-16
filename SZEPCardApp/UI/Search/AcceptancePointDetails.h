//
//  AcceptancePointDetails.h
//  SZEPCardApp
//
//  Created by Karesz on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AcceptancePoint.h"


@interface AcceptancePointDetails : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *scrollViewForImageBar;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollViewForMainView;
@property (retain, nonatomic) IBOutlet UIView *backgroundView;
@property (retain, nonatomic) IBOutlet UIView *littleBackgroundView;
@property (retain, nonatomic) IBOutlet UIView *largeBackgroundView;

@property (retain, nonatomic) IBOutlet UILabel *lbName;
@property (retain, nonatomic) IBOutlet UILabel *lbDistance;
@property (retain, nonatomic) IBOutlet UILabel *lbVouchersAccepted;
@property (retain, nonatomic) IBOutlet UILabel *lbAddress;
@property (retain, nonatomic) IBOutlet UILabel *lbWebsite;
@property (retain, nonatomic) IBOutlet UILabel *lbEmail;
@property (retain, nonatomic) IBOutlet UILabel *lbPhone;
@property (retain, nonatomic) IBOutlet UILabel *lbFax;
@property (retain, nonatomic) IBOutlet UILabel *lbServicesDetails;

@property (retain, nonatomic) IBOutlet UIButton *btnDetails;

/*
 Sajnos az elfogadohely reszletes adatait visszaado webservice a sepcifikacio szerint az elfogadohelyReszletesAdatai metodus a koordinatakat NEM adja vissza!!!
 
 Igy a SearchResult view-rol az AcceptancePointDetails view-ra valo atmenetkor az uj view-nak at kell adni a tavolsagot (mert a SearchResult view-n meg rendelkezesre all)
 
 */
@property (nonatomic, assign) CLLocationDistance distanceInMeters;

@property (nonatomic, assign) NSInteger acceptancePointId;

- (IBAction)clickDetails:(id)sender;

@end
