//
//  SearchResultMapView.m
//  SZEPCardApp
//
//  Created by Karesz on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchResultMapView.h"
#import "AcceptancePoint.h"
#import "AcceptancePointDetails.h"
#import "PinAnnotationForAP.h"
#import <QuartzCore/QuartzCore.h>


@interface SearchResultMapView(){
}

- (void)changeToPreviousView:(id)sender;

//az elfogadohely reszletes oldalara kell navigalnia a callout buborekban levo disclosure button-nak
- (void)showDetailsFor:(NSInteger)acceptancePointID distanceInfo:(CLLocationDistance)dist;

- (CLLocationDistance)calculateDistanceFrom:(CLLocation *)from toLocation:(CLLocation *)to;

@end

@implementation SearchResultMapView
@synthesize mapView, annotations, deviceLocation;

#pragma mark - private methods
- (void)changeToPreviousView:(id)sender {
    NSLog(@"Itt kell kezdő nezetre valtani");
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)showDetailsFor:(NSInteger)acceptancePointID distanceInfo:(CLLocationDistance)dist {
    NSLog(@"showDetailsFor called with this acceptance point id: %d, %f", acceptancePointID, dist);
    
    AcceptancePointDetails *nextView = [[AcceptancePointDetails alloc]initWithNibName:@"AcceptancePointDetails" bundle:[NSBundle mainBundle]];
    
    [nextView setAcceptancePointId:acceptancePointID];
    [nextView setDistanceInMeters:dist];

    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
    
}

- (CLLocationDistance)calculateDistanceFrom:(CLLocation *)from toLocation:(CLLocation *)to {
    CLLocationDistance dist = [to distanceFromLocation:from];
    
    return dist;

}


#pragma mark - initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.title = @"Map view";
    
    
    UIImage *buttonImage = [UIImage imageNamed:@"fejlec_gomb.png"];
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [bButton setTitle:NSLocalizedString(@"Back", @"back") forState:UIControlStateNormal];
    [bButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(changeToPreviousView:) forControlEvents:UIControlEventTouchUpInside];
    bButton.frame = CGRectMake(0.0f, 0.0f, buttonImage.size.width, buttonImage.size.height);
    [bButton.titleLabel setShadowColor:[UIColor blackColor]];
    [bButton.titleLabel setShadowOffset:CGSizeMake(0.0, 0.0)];
    bButton.titleLabel.layer.shadowRadius = 1.0;
    bButton.titleLabel.layer.shadowOpacity = 0.3;
    [bButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    //bButton.frame = CGRectMake(5.0, 5.0, 50.0, 40.0);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:bButton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    UIButton *rButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [rButton setTitle:NSLocalizedString(@"List", @"list") forState:UIControlStateNormal];
    [rButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rButton addTarget:self action:@selector(changeToPreviousView:) forControlEvents:UIControlEventTouchUpInside];
    rButton.frame = CGRectMake(0.0f, 0.0f, buttonImage.size.width, buttonImage.size.height);
    //rButton.frame = CGRectMake(260.0, 5.0, 50.0, 40.0);
    [rButton.titleLabel setShadowColor:[UIColor blackColor]];
    [rButton.titleLabel setShadowOffset:CGSizeMake(0.0, 0.0)];
    rButton.titleLabel.layer.shadowRadius = 1.0;
    rButton.titleLabel.layer.shadowOpacity = 0.3;
    [rButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //ez csak egy kek gömböt tesz le arra a pontra, ahol a felhasznalo tartozkodik
    //valoszinuleg nem is kell hozza a CLLOcationManager-rel irt kod sem (?), hanem automatikusan a Map Kit lekerdezi az aktualis koordinatat
    self.mapView.showsUserLocation = YES;
    
    //amennyiben van megadva delegate, akkor attol keri el a map view az annotaion view-kat!
    self.mapView.delegate = self;
    
    //itt tesszul le a markereket a terkepre
    for (AcceptancePoint *ap in annotations) {
        [self.mapView addAnnotation:ap];
    }
    
    //a terkep kozeppontjat a AcceptancePoint-okat tartalmazo lista elso (0. indexu) elemehez tartozo kooordinatara allitjuk be
    AcceptancePoint *anAP = [annotations objectAtIndex:0];
    
    //CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(37.423617, -122.220154);
    //CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(46.255209, 20.153561);
    
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake([anAP latitude], [anAP longitude]);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);       //ettol fugg, hogy mennyire zoom-ol bele a terkepbe! minel kisebb az ertek, annal jobban belenagyit.
    MKCoordinateRegion region = {centerCoordinate, span};
    [self.mapView setRegion:region];

    [self.mapView setCenterCoordinate:centerCoordinate];
    
    
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - MKMapViewDelegate protocol
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    AcceptancePoint *ap = (AcceptancePoint *)annotation;
    static NSString *AnnotationIdentifier = @"SZEPCardPinAnnotation";
    
    //cache-elve vannak az annotation-ok
    //MKPinAnnotationView *pinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    PinAnnotationForAP *pinView = (PinAnnotationForAP *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    if(pinView == nil) {
        //pinView = [[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier]autorelease];
        
        pinView = [[[PinAnnotationForAP alloc]initWithAcceptancePoint:ap andReuseIdentifier:AnnotationIdentifier]autorelease];
    }
    
    pinView.animatesDrop = YES;
    pinView.canShowCallout = YES;
    
    /* 
    UIView *leftView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 130)]autorelease];
    
    UILabel *lbTitle = [[[UILabel alloc]init]autorelease];
    lbTitle.text = ap.title;
    [lbTitle sizeToFit];
    lbTitle.frame = CGRectMake(5, 5, 240, 20);
    
    [leftView addSubview:lbTitle];
    
    UILabel *lbSubtitle = [[[UILabel alloc]init]autorelease];
    lbSubtitle.text = ap.subtitle;
    [lbSubtitle sizeToFit];
    lbSubtitle.frame = CGRectMake(5, CGRectGetMaxY(lbTitle.frame) + 5, 240, 20);
    
    [leftView addSubview:lbSubtitle];
    
    UILabel *lbDistance = [[[UILabel alloc]init]autorelease];
    lbDistance.text = @"125 km";
    [lbDistance sizeToFit];
    lbDistance.frame = CGRectMake(5, CGRectGetMaxY(lbSubtitle.frame) + 5, 240, 20);
    
    [leftView addSubview:lbDistance];
    
    pinView.leftCalloutAccessoryView = leftView;
    */
    
    
    //csinalunk egy disclosure button-t
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pinView.rightCalloutAccessoryView = rightButton;
    
    return pinView;
    
    
}

/*
    Ez a delegate metodus hivodik meg mint callback, amikor a user megerinti a callout-on a disclosure buttont.
 
 */
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"calloutAccessoryControlTapped");
    
    if([view isKindOfClass:[PinAnnotationForAP class]]) {
        PinAnnotationForAP *myPinAnnotation = (PinAnnotationForAP *)view;
        CLLocationDistance inMeters = [self calculateDistanceFrom:[myPinAnnotation apLocation] toLocation:deviceLocation];
        
        [self showDetailsFor:[myPinAnnotation apId] distanceInfo:inMeters];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"didDeselectAnnotationView");
}



#pragma mark - dealloc
- (void)dealloc {
    [mapView release];
    [annotations release];
    [super dealloc];
}
@end
