//
//  AcceptancePointDetails.m
//  SZEPCardApp
//
//  Created by Karesz on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "AcceptancePointDetails.h"
#import "SoapUtil.h"
#import "SoapResponseSaver.h"
#import "AcceptancePointDetailsResponseParserDelegate.h"
#import "LoadingIndicator.h"
#import "DetailsPhoto.h"


@interface AcceptancePointDetails() {
@private
    //UIActivityIndicatorView *loadingIndicator_;
    
    LoadingIndicator *indicator_;
    
    AcceptancePoint *modelObject_;
    
    NSArray *services;
    
    int counter;
    float sumHeight;
    
    NSMutableArray *photos;
    
    UIImageView *myImageView;

}

- (void)callWebService;

- (void)soapResponsePostProcess:(NSString *)soapResponse;

- (void)addIndicator;
- (void)removeIndicator;

- (void)refreshUI;

- (void) clickBack;

- (void) handlepinch:(UITapGestureRecognizer *) tapGestureRecognizer;

@end

@implementation AcceptancePointDetails
@synthesize scrollViewForImageBar;
@synthesize scrollViewForMainView;
@synthesize backgroundView;
@synthesize littleBackgroundView;
@synthesize largeBackgroundView;
@synthesize lbName;
@synthesize lbDistance;
@synthesize lbVouchersAccepted;
@synthesize lbAddress;
@synthesize lbWebsite;
@synthesize lbEmail;
@synthesize lbPhone;
@synthesize lbFax;
@synthesize lbServicesDetails;
@synthesize btnDetails;

@synthesize distanceInMeters, acceptancePointId;



#pragma mark - private methods

- (void)handlepinch:(UITapGestureRecognizer *)tapGestureRecognizer{
    
    UIImageView *img = (UIImageView *) tapGestureRecognizer.view;
    
    DetailsPhoto *photoView = [[DetailsPhoto alloc] init];
    
    photoView.photoImage = img.image;
        
    [self presentModalViewController:photoView animated:YES];
}

- (void)callWebService {
        
    NSArray *params = [NSArray arrayWithObject:[NSString stringWithFormat:@"%d", acceptancePointId]];
     
    //dummy ws eseten a soap template, amit hasznalni kell: elfogadohelyReszletesAdatai.xml
    //NSString *soapMessage = [SoapUtil createSoapMessage:@"elfogadohelyReszletesAdatai" withParams:params];
    
    //FINIT (eles) ws eseten a soap template, amit hasznlani kell: ElfAdatok.xml
    NSString *soapMessage = [SoapUtil createSoapMessage:@"ElfAdatok" withParams:params];
               
    SoapResponseSaver *responseSaver = [[[SoapResponseSaver alloc]init]autorelease];
    [responseSaver setController:self];
        
    [SoapUtil sendSoapMessage:soapMessage toUrl:SZEP_CARD_SERVICE_URL usingHeaders:nil andDelegate:responseSaver];
        
}

/*
 Itt a soap response xml-t feldolgozzuk es csinalunk belole datasource-ot
 */
- (void)soapResponsePostProcess:(NSMutableData *)soapResponse {
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:soapResponse];
    AcceptancePointDetailsResponseParserDelegate *parserDelegate = [[AcceptancePointDetailsResponseParserDelegate alloc]init];
    [xmlParser setDelegate: parserDelegate];
    //[xmlParser setShouldResolveExternalEntities: YES];
    BOOL parseResultOK = [xmlParser parse];
    NSLog(@"parseResultOK: %d", parseResultOK);
    
    if(modelObject_ != nil) {
        [modelObject_ release];
        modelObject_ = nil;
    }
    
    modelObject_ = parserDelegate.acceptancePoint;
    [modelObject_ retain];
    
    NSLog(@"modelObject: %@", modelObject_);
    
    [parserDelegate release];
    [xmlParser release];
    
    [self refreshUI];
    [self removeIndicator];
}


- (void)addIndicator {
    indicator_ = [[LoadingIndicator alloc]initWithViewController:self];
    [indicator_ showLoadingIndicator:self];
    
    /*
    loadingIndicator_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    float centerX, centerY;
    
    centerX = self.view.frame.size.width / 2;
    centerY = self.view.frame.size.height / 2;
    
	loadingIndicator_.center = CGPointMake(centerX, centerY);
	loadingIndicator_.hidesWhenStopped = YES;
    
    [self.view addSubview:loadingIndicator_];
    
    [loadingIndicator_ startAnimating];
     */
}

- (void)removeIndicator {
    [indicator_ hideLoadingIndicator];
    
    /*
    [loadingIndicator_ stopAnimating];
    
    [loadingIndicator_ removeFromSuperview];
    
    [loadingIndicator_ release];
    loadingIndicator_ = nil;
     */
    
}

- (void)refreshUI {
    lbName.text = modelObject_.name;
    
    //Tavolsag kiszamitasa
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setMinimumFractionDigits:0];
    
    NSString *distanceFormatted = [formatter stringFromNumber:[NSNumber numberWithDouble:(distanceInMeters / 1000)]];
    NSLog(@"formatted distance %@", distanceFormatted);
    
    lbDistance.text = [NSString stringWithFormat:@"%@ km", distanceFormatted];
    
    //Utalvany tipusok formazasa 
    NSMutableString *ms1 = [[[NSMutableString alloc]init]autorelease];
    
    //ez segit eldonteni, hogy kell-e vesszot appendelni
    BOOL chainAlreadyHasElement = NO;
    
    if(modelObject_.lodgingAccepted ) {
        [ms1 appendString:NSLocalizedString(@"Lodging", nil)];
        chainAlreadyHasElement = YES;
    }
    
    if(modelObject_.hospitalityAccepted) {
        if(chainAlreadyHasElement) {
            [ms1 appendString:@", "];
        }
        
        [ms1 appendString:NSLocalizedString(@"Hospitality", nil)];
        chainAlreadyHasElement = YES;
    }
    
    if(modelObject_.leisureAccepted) {
        if(chainAlreadyHasElement) {
            [ms1 appendString:@", "];
        }
        
        [ms1 appendString:NSLocalizedString(@"Leisure", nil)];
        chainAlreadyHasElement = YES;
    }
    
    lbVouchersAccepted.text = ms1;
    
    
    //Teljes cim osszeallitasa
    NSMutableString *ms2 = [[[NSMutableString alloc]init]autorelease];
    [ms2 appendString:modelObject_.settlementZipCode];
    [ms2 appendString:@", "];
    [ms2 appendString:modelObject_.settlementName];
    [ms2 appendString:@" "];
    [ms2 appendString:modelObject_.address];
    
    lbAddress.text = ms2;
    
    
    lbWebsite.text = modelObject_.website;
    
    lbEmail.text = modelObject_.email;
    
    lbPhone.text = modelObject_.phone;
    
    //a latvanyterven szerepel csak a FAX, amugy a webservice ilyen property-t nem ad vissza...
    lbFax.text = @"";
    
    
    NSArray *arrayForUrls = [NSArray arrayWithObjects:
                          @"http://static.neckermann.hu/cumulus/S/xxl/11832_1.jpg", 
                          @"http://static.neckermann.hu/cumulus/S/xxl/11515_1.jpg", 
                          @"http://static.neckermann.hu/cumulus/S/xxl/11624_1.jpg", 
                          @"http://static.neckermann.hu/cumulus/S/xxl/11122_1.jpg", 
                          @"http://static.neckermann.hu/cumulus/S/xxl/11980_1.jpg", 
                          nil];
    
    /*
    NSArray *arrayForUrls = [NSArray arrayWithObjects:
                             modelObject_.imageUrl1,
                             modelObject_.imageUrl2,
                             modelObject_.imageUrl3,
                             modelObject_.imageUrl4,
                             modelObject_.imageUrl5,
                             nil];
     */
    
    
    float gap = 10.0f;          //kis kepek kozotti tavolsag
    float leftMargin = 10.0f;   
    float rightMargin = 10.0f;
    float w = 100.0f;           //egyetlen kis kep szelessege
    float h = 100.0f;           //egyetlen kis kep magassaga
    
    [scrollViewForImageBar setContentSize:CGSizeMake(([arrayForUrls count] * w) + (([arrayForUrls count] - 1) * 10) + leftMargin + rightMargin, scrollViewForImageBar.frame.size.height)];
    
    photos = [[NSMutableArray alloc] init] ;
    
    //kep letoltese URL-rol
    
    for(int i=0; i<[arrayForUrls count]; i++) {
        NSString *theURLString = [arrayForUrls objectAtIndex:i];
        NSString* mapURL = [theURLString stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:mapURL]];
        
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
        
        
        float posY = 10.0f;
        
        float posX = leftMargin + (i * w) + (i * gap);
        
        imgView.frame = CGRectMake(posX, posY, w, h);
        imgView.layer.cornerRadius = 10.0f;
        imgView.layer.masksToBounds = YES;
        
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *pgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlepinch:)];
        pgr.delegate = self;
        [imgView addGestureRecognizer:pgr];
        [scrollViewForImageBar addSubview:imgView];
        
        //UIImageWriteToSavedPhotosAlbum([imgView image], nil, nil, nil);
        
        
        [pgr release];
        [imageData release];
        [image release];
        [imgView release];
        
    }
    
    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *buttonImage = [UIImage imageNamed:@"fejlec_gomb.png"];
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
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
    
    //ezt a hekkelest a neten talaltam: igy lehet egy kepet szinkent definialni
    UIColor *backgroundForScrollView = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"adatlap_hattere.png"]];
    scrollViewForMainView.backgroundColor = backgroundForScrollView;
    [backgroundForScrollView release];
    
    // Sajnos a háttér egy buborék, amiben 2 féle háttérszín szerepel + egy árnyékolás is. Implementálás során egy külső keret view-ra(backgroundView) állítom be a shadow-t és a lekerekítést, aminek a tartalma egy ugyanakkora view lesz (largeBackgroundView). Ha csak a keret view-ba raknék egy kisebb view-t, aminek a háttérszine a szürkés szín és beállítom a maskToBounds property-t YES-re, nem fog a shadow látszani. Ezért van szükség egy köztes view-ra(largeBackgroundView), amibe be tudom rakni a kisebb view-t(littleBackgroundView) így a kereten is látszódni fog a shadow.
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.layer.cornerRadius = 10.0f;
    backgroundView.layer.shadowColor = [[UIColor blackColor] CGColor];
    backgroundView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    backgroundView.layer.shadowRadius = 2.0;
    backgroundView.layer.shadowOpacity = 0.8;
    
    largeBackgroundView.layer.cornerRadius = 10.0f;
    largeBackgroundView.layer.masksToBounds = YES;
    
    services = [[NSArray alloc] initWithObjects:@"szauna", @"klima", @"éjszakai fürdőzéa",@"koteltanc",@"wc", @"free park", @"masszázs", @"álamnő", nil];
    
    scrollViewForMainView.contentSize = CGSizeMake(320.0, CGRectGetMaxY(backgroundView.frame) );
    
    // kezdő értékek inicializálása a részletek gomb eseményhez...
    sumHeight = 0.0;
    counter = 0;
    
    [self addIndicator];
    [self callWebService];

    
}

- (void)viewDidUnload
{
    [self setScrollViewForImageBar:nil];
    [self setLbName:nil];
    [self setLbDistance:nil];
    [self setLbVouchersAccepted:nil];
    [self setLbAddress:nil];
    [self setLbWebsite:nil];
    [self setLbEmail:nil];
    [self setLbPhone:nil];
    [self setLbFax:nil];
    [self setScrollViewForMainView:nil];
    [self setBackgroundView:nil];
    [self setLittleBackgroundView:nil];
    [self setLargeBackgroundView:nil];
    [self setBtnDetails:nil];
    [self setLbServicesDetails:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

#pragma mark - event handlers
- (void) clickBack {

    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)clickDetails:(id)sender {

    
    float offset = 10.0;
    
    if (counter % 2 == 0){
    
        sumHeight = 0.0;
        
        [lbServicesDetails setHidden:YES];
        
    for (int i=0; i < [services count]; i++){
        
        UILabel *label = [[UILabel alloc] init];
        
        if (i%2 == 0){
        label.frame = CGRectMake(20.0, offset, 100.0, 20.0);
        }
        else {
        label.frame = CGRectMake(180.0, offset, 200.0, 20.0);
        offset += 20.0;
        }
        label.font = [UIFont systemFontOfSize:12.0];
        NSString *subtitle = [[NSString alloc] initWithFormat:@"- %@", [services objectAtIndex:i]];
        label.text = subtitle;
        label.backgroundColor = [UIColor clearColor];
        
        [littleBackgroundView addSubview:label];
        
        sumHeight = CGRectGetMaxY(label.frame);
        
        [subtitle release];
        [label release];
        
    }
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:1.0];
    
    
    btnDetails.frame = CGRectMake(btnDetails.frame.origin.x, btnDetails.frame.origin.y + sumHeight, btnDetails.frame.size.width, btnDetails.frame.size.height);      
      
        backgroundView.frame = CGRectMake(10.0, 14.0, backgroundView.frame.size.width, CGRectGetMaxY(btnDetails.frame) -10.0);
        littleBackgroundView.frame = CGRectMake(0.0, 309.0, littleBackgroundView.frame.size.width, littleBackgroundView.frame.size.height + sumHeight);
        
        
    /*
    backgroundView.frame = CGRectMake(10.0, 14.0, backgroundView.frame.size.width, backgroundView.frame.size.height + sumHeight -self.navigationController.navigationBar.frame.size.height + 10.0);
    
    littleBackgroundView.frame = CGRectMake(0.0, 309.0 , littleBackgroundView.frame.size.width,  sumHeight + 10.0);
    */
    scrollViewForMainView.contentSize = CGSizeMake(320.0, CGRectGetMaxY(backgroundView.frame));
    scrollViewForMainView.contentOffset = CGPointMake(0, 0 + sumHeight);
   
    
    [UIView commitAnimations];
        counter++;
    }
    
    else {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:1.0];
        
        for (UILabel *lbServices in littleBackgroundView.subviews) {
            [lbServices removeFromSuperview];
        }
        
        [lbServicesDetails setHidden:NO];
        
        btnDetails.frame = CGRectMake(btnDetails.frame.origin.x, btnDetails.frame.origin.y - sumHeight, btnDetails.frame.size.width, btnDetails.frame.size.height);      
        
        backgroundView.frame = CGRectMake(10.0, 14.0, backgroundView.frame.size.width, CGRectGetMaxY(btnDetails.frame) - 10.0);
        littleBackgroundView.frame = CGRectMake(0.0, 309.0, littleBackgroundView.frame.size.width, littleBackgroundView.frame.size.height - sumHeight);
        
        /*
        backgroundView.frame = CGRectMake(10.0, 14.0, backgroundView.frame.size.width, backgroundView.frame.size.height - sumHeight + self.navigationController.navigationBar.frame.size.height - 10.0);
                
        littleBackgroundView.frame = CGRectMake(0.0, 309.0 , littleBackgroundView.frame.size.width, littleBackgroundView.frame.size.height);
        */
        scrollViewForMainView.contentSize = CGSizeMake(320.0, CGRectGetMaxY(backgroundView.frame));
        scrollViewForMainView.contentOffset = CGPointMake(0, 0);
        
        [UIView commitAnimations];
        counter++;
    }

}


- (void)dealloc {
    
    [scrollViewForImageBar release];
    [lbName release];
    [lbDistance release];
    [lbVouchersAccepted release];
    [lbAddress release];
    [lbWebsite release];
    [lbEmail release];
    [lbPhone release];
    [lbFax release];
    
    [modelObject_ release];
    
    [indicator_ release];
    
    [scrollViewForMainView release];
    [backgroundView release];
    [littleBackgroundView release];
    [largeBackgroundView release];
    [btnDetails release];
    [lbServicesDetails release];
    [super dealloc];
}


@end
