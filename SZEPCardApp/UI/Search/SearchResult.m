//
//  SearchResult.m
//  SZEPCardApp
//
//  Created by Karesz on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "SearchResult.h"
#import "AcceptancePointDetails.h"
#import "SearchResultMapView.h"
#import "SoapUtil.h"
#import "SoapResponseSaver.h"
#import "SearchResponseParserDelegate.h"
#import "AcceptancePoint.h"
#import "AcceptancePointCell.h"


@interface SearchResult() {
@private
    
    //a GPS koordinatak lekerese, illetve maga a kereses csak itt, az eredmenyoldalon kezdodik el!
    CLLocationManager *locationManager_;
    
    UIActivityIndicatorView *loadingIndicator_;
    
    BOOL pollingLocationIsOn_;
    
    SearchResultHeader *customHeader_;
    
    
}

- (void)callWebService;

- (void)soapResponsePostProcess:(NSString *)soapResponse;

- (void)addIndicator;
- (void)removeIndicator;

- (void)changeToMapView:(id)sender;
- (void)changeToPreviousView:(id)sender;

- (void)startLocationServiceFrom:(NSString *)methodName;
- (void)stopLocationServiceFrom:(NSString *)methodName;

- (CLLocationDistance)calculateDistanceFrom:(double)latitude longitude:(double)longitude toLatitude:(double)toLatitude toLongitude:(double)toLongitude;

@end

@implementation SearchResult
@synthesize acceptancePoints, criteria;

#pragma mark - private methods
- (void)callWebService {
    //static NSTimeInterval pollDelay = 5;
    
    if(criteria != nil) {
        
        NSString *soapMessage = nil;
        
        
        if([criteria searchType] == GEOLOCATION_BASED) {
            NSArray *params = [NSArray arrayWithObjects:
                               [NSString stringWithFormat:@"%f", criteria.latitude], 
                               [NSString stringWithFormat:@"%f", criteria.longitude],
                               [NSString stringWithFormat:@"%d", criteria.searchRadius],
                               [NSString stringWithFormat:@"%i", criteria.lodgingExpected],
                               [NSString stringWithFormat:@"%i", criteria.hospitalityExpected],
                               [NSString stringWithFormat:@"%i", criteria.leisureExpected],
                               nil];
            
            //dummy ws eseten soap template amit hasznalni kell: elfogadohelyekKoordinataSzerint.xml
            //soapMessage = [SoapUtil createSoapMessage:@"elfogadohelyekKoordinataSzerint" withParams:params];
            
            //FINIT ws eseten (eles) soap template amit hasznalni kell: ElfKeresKoord.xml
            soapMessage = [SoapUtil createSoapMessage:@"ElfKeresKoord" withParams:params];
        } else if([criteria searchType] == SETTLEMENT_BASED) {
            NSArray *params = [NSArray arrayWithObjects:
                               criteria.settlement.zipCode, 
                               criteria.settlement.name,
                               [NSString stringWithFormat:@"%i", criteria.lodgingExpected],
                               [NSString stringWithFormat:@"%i", criteria.hospitalityExpected],
                               [NSString stringWithFormat:@"%i", criteria.leisureExpected],
                               nil];
            
            //dummy ws eseten soap template amit hasznalni kell: elfogadohelyekTelepulesen.xml
            //soapMessage = [SoapUtil createSoapMessage:@"elfogadohelyekTelepulesen" withParams:params];
            
            //FINIT ws eseten (eles) soap template amit hasznalni kell: ElfKeres.xml 
            soapMessage = [SoapUtil createSoapMessage:@"ElfKeres" withParams:params];
        }
        
        SoapResponseSaver *responseSaver = [[[SoapResponseSaver alloc]init]autorelease];
        [responseSaver setController:self];
        
        [SoapUtil sendSoapMessage:soapMessage toUrl:SZEP_CARD_SERVICE_URL usingHeaders:nil andDelegate:responseSaver];
        
    }
}

/*
    Itt a soap response xml-t feldolgozzuk es csinalunk belole datasource-ot
 */
- (void)soapResponsePostProcess:(NSMutableData *)soapResponse {
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:soapResponse];
    SearchResponseParserDelegate *parserDelegate = [[SearchResponseParserDelegate alloc]init];
    [xmlParser setDelegate: parserDelegate];
    //[xmlParser setShouldResolveExternalEntities: YES];
    BOOL parseResultOK = [xmlParser parse];
    NSLog(@"parseResultOK: %d", parseResultOK);
    
    NSLog(@"acceptanice points: %@", parserDelegate.listOfAcceptancePoints);
    self.acceptancePoints = parserDelegate.listOfAcceptancePoints;
    
    //a header-nek is ismernie kell a datsource-ot, hiszen onala van a rendezesi algoritmus implementalva. Plusz ismernie kell a device location-t, hogy tudjon tavolsagok szerint is sorbarendezni
    CLLocation *devLoc = [[[CLLocation alloc]initWithLatitude:criteria.latitude longitude:criteria.longitude]autorelease];
    [customHeader_ setDatasource:acceptancePoints];
    [customHeader_ setDeviceLocation:devLoc];
    
    
    [parserDelegate release];
    [xmlParser release];
    
    [self removeIndicator];
    
    [self.tableView reloadData];
}



- (void)addIndicator {
    loadingIndicator_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    float centerX, centerY;
    
    centerX = self.tableView.frame.size.width / 2;
    centerY = self.tableView.frame.size.height / 2;
    
	loadingIndicator_.center = CGPointMake(centerX, centerY);
	loadingIndicator_.hidesWhenStopped = YES;
    
    [self.view addSubview:loadingIndicator_];
    
    [loadingIndicator_ startAnimating];
}

- (void)removeIndicator {
    
    [loadingIndicator_ stopAnimating];
    
    [loadingIndicator_ removeFromSuperview];
    
    [loadingIndicator_ release];
    loadingIndicator_ = nil;
    
}

//right bar button item esemenykezelo
- (void)changeToMapView:(id)sender {
    NSLog(@"Itt kell terkep nezetre valtani");
    
    SearchResultMapView *srmv = [[SearchResultMapView alloc]initWithNibName:@"SearchResultMapView" bundle:[NSBundle mainBundle]];
    [srmv setAnnotations:acceptancePoints];
    
    CLLocation *whereWeAre = [[[CLLocation alloc]initWithLatitude:criteria.latitude longitude:criteria.longitude]autorelease];
    [srmv setDeviceLocation:whereWeAre];
    
    [self.navigationController pushViewController:srmv animated:YES];
    
    [srmv release];
}

//left bar button item esemenykezelo
- (void)changeToPreviousView:(id)sender {
    NSLog(@"Itt kell kezdő nezetre valtani");
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)startLocationServiceFrom:(NSString *)methodName {
    if(locationManager_ != nil && pollingLocationIsOn_ == NO) {
        [locationManager_ startUpdatingLocation];
        pollingLocationIsOn_ = YES;
        NSLog(@"%@: location service STARTED...", methodName);
    }
}

- (void)stopLocationServiceFrom:(NSString *)methodName {
    if(pollingLocationIsOn_ == YES) {
        [locationManager_ stopUpdatingLocation];
        pollingLocationIsOn_ = NO;
        NSLog(@"%@: location service STOPPED...", methodName);
    }
}

- (CLLocationDistance)calculateDistanceFrom:(double)latitude longitude:(double)longitude toLatitude:(double)toLatitude toLongitude:(double)toLongitude {
    
    CLLocation *from = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    CLLocation *to = [[CLLocation alloc]initWithLatitude:toLatitude longitude:toLongitude];
    
    CLLocationDistance dist = [to distanceFromLocation:from];
    
    return dist;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    
    locationManager_ = [[CLLocationManager alloc]init];
    locationManager_.delegate = self;
    locationManager_.desiredAccuracy = kCLLocationAccuracyBest;

    UIImage *buttonImage = [UIImage imageNamed:@"fejlec_gomb.png"];
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(changeToPreviousView:) forControlEvents:UIControlEventTouchUpInside];
    bButton.frame = CGRectMake(0.0f, 0.0f, buttonImage.size.width, buttonImage.size.height);
    //bButton.frame = CGRectMake(5.0, 5.0, 50.0, 40.0);
    [bButton.titleLabel setShadowColor:[UIColor blackColor]];
    [bButton.titleLabel setShadowOffset:CGSizeMake(0.0, 0.0)];
    bButton.titleLabel.layer.shadowRadius = 1.0;
    bButton.titleLabel.layer.shadowOpacity = 0.3;
    [bButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [bButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bButton setTitle:NSLocalizedString(@"Back", @"Back") forState:UIControlStateNormal];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:bButton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIButton *rButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [rButton addTarget:self action:@selector(changeToMapView:) forControlEvents:UIControlEventTouchUpInside];
    rButton.frame = CGRectMake(0.0f, 0.0f, buttonImage.size.width, buttonImage.size.height);
    //rButton.frame = CGRectMake(260.0, 5.0, 50.0, 40.0);
    [rButton.titleLabel setShadowColor:[UIColor blackColor]];
    [rButton.titleLabel setShadowOffset:CGSizeMake(0.0, 0.0)];
    rButton.titleLabel.layer.shadowRadius = 1.0;
    rButton.titleLabel.layer.shadowOpacity = 0.3;
    [rButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [rButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rButton setTitle:NSLocalizedString(@"Map", @"Map") forState:UIControlStateNormal];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    [backButton release];
    [rightButton release];
    
    [self addIndicator];
    
    if(criteria.searchType == GEOLOCATION_BASED) {
        //ha geolokacio szerinti kereses van, akkor elobb le kell kerdezni a device aktualis poziciojat es CSAK UTANA lehet web service-t hivni!!!
        [self startLocationServiceFrom:@"viewDidLoad"];
    } else {
        [self callWebService];
    }
    
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [self stopLocationServiceFrom:@"viewDidUnload"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(customHeader_ == nil) {
        customHeader_ = [[SearchResultHeader alloc]initWithNibName:@"SearchResultHeader" bundle:[NSBundle mainBundle]];
        [customHeader_ setDelegate:self];
        
    }
    
    return customHeader_.view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [acceptancePoints count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AcceptancePointCell";
    
    AcceptancePointCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        UINib *cellNib = [UINib nibWithNibName:@"AcceptancePointCell" bundle:[NSBundle mainBundle]];
        cell = [[cellNib instantiateWithOwner:self options:nil]objectAtIndex:0];
    }
    
    AcceptancePoint *modelObject = [acceptancePoints objectAtIndex:indexPath.row];
    
    if([cell isKindOfClass:[AcceptancePointCell class]]) {
        cell.lbName.text = modelObject.name;
        
        CLLocationDistance distanceInMeters = [self calculateDistanceFrom:criteria.latitude longitude:criteria.longitude toLatitude:modelObject.latitude toLongitude:modelObject.longitude];
        
        double distanceInKilometers = distanceInMeters / 1000;
        //NSLog(@"distance in kms: %f", distanceInKilometers);
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        //[formatter setPositiveFormat:@"#,##0.0000000"];   
        //[formatter setNegativeFormat:@"-#,##0.0000000"];
        [formatter setMaximumFractionDigits:2];
        [formatter setMinimumFractionDigits:0];
        //[formatter setRoundingMode: NSNumberFormatterRoundHalfDown];
        
        NSString *distanceFormatted = [formatter stringFromNumber:[NSNumber numberWithDouble:distanceInKilometers]];
        NSLog(@"formatted distance %@", distanceFormatted);
        
        cell.lbDistance.text = [NSString stringWithFormat:@"%@ km", distanceFormatted];
        
        NSMutableString *ms = [[[NSMutableString alloc]init]autorelease];
        
        //ez segit eldonteni, hogy kell-e kotojelet appendelni
        BOOL chainAlreadyHasElement = NO;
        
        if(modelObject.lodgingAccepted ) {
            [ms appendString:NSLocalizedString(@"Lodging", nil)];
            chainAlreadyHasElement = YES;
        }
        
        if(modelObject.hospitalityAccepted) {
            if(chainAlreadyHasElement) {
                [ms appendString:@" - "];
            }
            
            [ms appendString:NSLocalizedString(@"Hospitality", nil)];
            chainAlreadyHasElement = YES;
        }
        
        if(modelObject.leisureAccepted) {
            if(chainAlreadyHasElement) {
                [ms appendString:@" - "];
            }
            
            [ms appendString:NSLocalizedString(@"Leisure", nil)];
            chainAlreadyHasElement = YES;
        }
        
        cell.lbVouchers.text = ms;
        
    }
    
    //cell.accessoryView.backgroundColor = [UIColor colorWithRed:255.0 green:249.0 blue:229.0 alpha:1.0];
    
    //ezt a hekkelest a neten talaltam: igy lehet egy kepet szinkent definialni
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"listaelembg.png"]];
    cell.backgroundColor = background;
    [background release];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AcceptancePointDetails *apd = [[AcceptancePointDetails alloc]initWithNibName:@"AcceptancePointDetails" bundle:[NSBundle mainBundle]];
    
    AcceptancePoint *modelObject = [acceptancePoints objectAtIndex:indexPath.row];
    CLLocationDistance distanceInMeters = [self calculateDistanceFrom:criteria.latitude longitude:criteria.longitude toLatitude:modelObject.latitude toLongitude:modelObject.longitude];
    
    [apd setDistanceInMeters:distanceInMeters];
    
    [self.navigationController pushViewController:apd animated:YES];
    [apd release];
}





#pragma mark - CLLocationManagerDelegate protocol
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    NSLog(@"New location received: %@", newLocation);
    
    
    
    //TODO: valodi geolocation adatot kuldeni!!! Ez a Bozsik stadion kezdokore :)
    //[criteria_ setLatitude:47.442515];
    //[criteria_ setLongitude:19.155124];
    
    //egy masik valid Mo-i koordinata, teszteleshez: 47.6, 17.1
    //tovabbiak: 46.260357,20.144291   46.255209,20.153561  46.261648,20.1459  47.194714,20.174439  47.527098,21.629012    47.662497,19.108872
    
    
    /*
     Az alabbi a helyes!!!
     */
    /*
     [criteria_ setLatitude:locationManager.location.coordinate.latitude];
     [criteria_ setLongitude:locationManager.location.coordinate.longitude];
     
     [criteria setLatitude:newLocation.coordinate.latitude];
     [criteria setLongitude:newLocation.coordinate.longitude];
     */
    
    
    
    //CSAK TESZTHEZ!!!
    //Bp., XIII., Duna Plaze: 47.551912,19.074025
    [criteria setLatitude:47.551912];
    [criteria setLongitude:19.074025];
    
    //ha megvan a current location, akkor le lehet allitani a pollozast es meg lehet hivni a web service-t
    [self stopLocationServiceFrom:@"locationManager:didUpdateToLocation:fromLocation:"];
    
    [self callWebService];

}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSString *errorType = (error.code == kCLErrorDenied) ? NSLocalizedString(@"Acces to Location service is denied", @"Error message displayed when location service is not enabled on the device.") : NSLocalizedString(@"Current location could not be determined.", @"Generic location service error.");
    
    NSString *title = NSLocalizedString(@"Error getting location", @"Title for alert view in case of location error.");
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:errorType delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertView show];
    
    [alertView release];
}

#pragma mark - ModelReorderDelegate
- (void)reorderController:(UIViewController *)viewController didResultIn:(NSArray *)reorderedResult {
    self.acceptancePoints = reorderedResult;
    
    [self.tableView reloadData];
}

#pragma mark - dealloc
- (void)dealloc {
    
    [loadingIndicator_ release];
    [criteria release];
    [acceptancePoints release];
    
    [super dealloc];
}

@end
