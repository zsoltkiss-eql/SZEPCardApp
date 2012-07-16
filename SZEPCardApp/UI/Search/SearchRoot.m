//
//  SearchRoot.m
//  SZEPCardApp
//
//  Created by Karesz on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SearchRoot.h"
#import "SearchResult.h"
#import "SettlementSearch.h"
#import "VoucherTypeSelectorCell.h"
#import "Voucher.h"
#import "SubAccountLodging.h"
#import "SubAccountHospitality.h"
#import "SubAccountLeisure.h"
#import "SearchCriteria.h"
#import "About.h"

#define SEARCH_BAR_FRAME CGRectMake(15, 70, 290, 44)
#define SEARCH_SEGMENTED_RADIUS_FRAME CGRectMake(20, 246, 280.0, 44)
#define SEARCH_SEGMENTED_TYPE_FRAME CGRectMake(20, 20, 280.0, 39)

//a UISearchBar-t dinamikusan hol hozzaadjuk, hol remove-oljuk; referenciat nem orzunk ra, de a tag alapjan ki tudjuk keresni a parent view-bol
#define TAG_FOR_SEARCH_BAR 1999  
#define TAG_FOR_SEGMENTED_RADIUS 20015
#define TAG_FOR_BUTTON_SEARCH 107

#define TAG_FOR_INFO_IMAGE_LODGING 101
#define TAG_FOR_INFO_IMAGE_HOSPITALITY 102
#define TAG_FOR_INFO_IMAGE_LEISURE 103

#define TAG_FOR_UI_SWITCH_LODGING 104
#define TAG_FOR_UI_SWITCH_HOSPITALITY 105
#define TAG_FOR_UI_SWITCH_LEISURE 106



@interface SearchRoot() {
@private
    NSInteger searchTypeSelected_;   
    SearchCriteria *criteria_;
    
}

- (void)addGestureRecognizer;

- (void)addSearchBar;
- (void)removeSearchBar;
- (void)moveControls;

- (void) goToTheAboutView;
- (void) segmentControlChangeSelectForRadius:(id) sender;
- (void) segmentControlChangeSelectForType:(id) sender;

@end

@implementation SearchRoot

@synthesize voucherTypeSelectorHolder;


@synthesize scSearchType;
@synthesize scSearchRadius;
@synthesize btnSearch;
@synthesize settlementSelected;

#pragma mark - private methods

- (void)addGestureRecognizer {
    
    UITapGestureRecognizer *rec1 = [[UITapGestureRecognizer alloc] 
                                     initWithTarget:self action:@selector(someGestureRecognized:)];
    
    UITapGestureRecognizer *rec2 = [[UITapGestureRecognizer alloc] 
                                    initWithTarget:self action:@selector(someGestureRecognized:)];
    
    UITapGestureRecognizer *rec3 = [[UITapGestureRecognizer alloc] 
                                    initWithTarget:self action:@selector(someGestureRecognized:)];
    
    UIImageView *imgvLodging = (UIImageView *)[voucherTypeSelectorHolder viewWithTag:TAG_FOR_INFO_IMAGE_LODGING];
   
    UIImageView *imgvLeisure = (UIImageView *)[voucherTypeSelectorHolder viewWithTag:TAG_FOR_INFO_IMAGE_LEISURE];
    
    UIImageView *imgvHospitality = (UIImageView *)[voucherTypeSelectorHolder viewWithTag:TAG_FOR_INFO_IMAGE_HOSPITALITY];
    
    [imgvLodging addGestureRecognizer:rec1];
    [imgvHospitality addGestureRecognizer:rec2];
    [imgvLeisure addGestureRecognizer:rec3];
    
    [rec1 release];
    [rec2 release];
    [rec3 release];
    
}

- (void)addSearchBar {
    
        
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:SEARCH_BAR_FRAME];
    [searchBar setTag:TAG_FOR_SEARCH_BAR];
    [searchBar setDelegate:self];
    //searchBar.backgroundColor = [UIColor clearColor];
    
    //ez azert kell, hogy a halos hatterkep legyen a search bar mogott, ha ez nem lenne, egy acelszurke hatteret rakna oda
    searchBar.backgroundImage = [UIImage imageNamed:@"hatter.png"];
    
    [self.view addSubview:searchBar];
    
    
    [searchBar release];
    
    for (UIView *aSubView in [self.view subviews]){
        if (aSubView.tag == TAG_FOR_SEGMENTED_RADIUS){
            [aSubView setHidden:YES];
        }
    }
    
    [self moveControls];
    
}

- (void)removeSearchBar {
    
    UIView *someView = [self.view viewWithTag:TAG_FOR_SEARCH_BAR];
    if([someView isKindOfClass:[UISearchBar class]]) {
        [someView removeFromSuperview];
    }
    
    for (UIView *aSubView in [self.view subviews]){
        if (aSubView.tag == TAG_FOR_SEGMENTED_RADIUS){
            [aSubView setHidden:NO];
        }
    }
    [self moveControls];
}

/*
    A search bar hozzaadasa/eltavolitasa magaval vonja nehany UI komponens ide-oda tologatasat
 
 */
- (void)moveControls {
    //a SEARCH_BAR_FRAME magassaga plusz egy kis gap. Minden lentebbi komponenst ennyivel kell lejjebb tolni
    static float offset = 44.0 + 10.0;
    
    float offsetToUse = (searchTypeSelected_ == GEOLOCATION_BASED) ? (-1) * offset : offset;
        
    CGFloat centerX = voucherTypeSelectorHolder.center.x;
    CGFloat centerY = voucherTypeSelectorHolder.center.y;
    CGPoint newCenter = CGPointMake(centerX, centerY + offsetToUse);
    voucherTypeSelectorHolder.center = newCenter; 
    
    /*
    centerX = scSearchRadius.center.x;
    centerY = scSearchRadius.center.y;
    newCenter = CGPointMake(centerX, centerY + offsetToUse);
    scSearchRadius.center = newCenter;
    */
    
    if ([scSearchRadius isHidden] == YES){
        btnSearch.frame = CGRectMake(btnSearch.frame.origin.x, CGRectGetMaxY(voucherTypeSelectorHolder.frame) + 10.0, btnSearch.frame.size.width, btnSearch.frame.size.height);
    }
    else {
        btnSearch.frame = CGRectMake(btnSearch.frame.origin.x, CGRectGetMaxY(scSearchRadius.frame) + 10.0, btnSearch.frame.size.width, btnSearch.frame.size.height);
    }
    
    
}



- (void)goToTheAboutView{
    
    About *about = [[About alloc] init];
    
    [self.navigationController pushViewController:about animated:YES];
    
    [about release];
    
}

- (void)segmentControlChangeSelectForRadius:(id)sender{

    for (int i=0; i < [[sender subviews] count]; i++) {
        if ([[[sender subviews] objectAtIndex:i] isSelected]){
        
            UIColor *tintColor = [UIColor colorWithRed:242./255.0 green:163.0/255.0 blue:12.0/255.0 alpha:1.0];
            [[[sender subviews] objectAtIndex:i] setTintColor:tintColor];
            UIView *segment = (UIView *) [[sender subviews] objectAtIndex:i];
            
            for (UIView *view in [segment subviews]){
                if ([view isKindOfClass:[UILabel class]]){
                    UILabel *lb = (UILabel *) view;
                    lb.font = [UIFont systemFontOfSize:15.0];
                    [lb sizeToFit];
                }
            }    
        
        }
        else {
            UIColor *tintColor = [UIColor colorWithRed:240.0/255.0 green:243.0/255.0 blue:246.0/255.0 alpha:1.0];
            [[[sender subviews] objectAtIndex:i] setTintColor:tintColor];
            UIView *segment = (UIView *) [[sender subviews] objectAtIndex:i];
            for (UIView *view in [segment subviews]){
                if ([view isKindOfClass:[UILabel class]]){
                    UILabel *lb = (UILabel *) view;
                    lb.font = [UIFont systemFontOfSize:15.0];
                    lb.textColor = [UIColor blackColor];
                    [lb sizeToFit];
                }
            }
        
        }
    }

}

- (void) segmentControlChangeSelectForType:(id) sender{
    
    for (int i=0; i < [[sender subviews] count]; i++) {
        if ([[[sender subviews] objectAtIndex:i] isSelected]){
            UIColor *tintColor = [UIColor colorWithRed:242.0/255.0 green:163.0/255.0 blue:12.0/255.0 alpha:1.0];
            [[[sender subviews] objectAtIndex:i] setTintColor:tintColor];
            UIView *segment = (UIView *) [[sender subviews] objectAtIndex:i];
            
            for (UIView *view in [segment subviews]){
                if ([view isKindOfClass:[UILabel class]]){
                    UILabel *lb = (UILabel *) view;
                    lb.font = [UIFont boldSystemFontOfSize:17.0];
                    [lb sizeToFit];
                }
            }    

        }
        else {
            UIColor *tintColor = [UIColor colorWithRed:240.0/255.0 green:243.0/255.0 blue:246.0/255.0 alpha:1.0];
            [[[sender subviews] objectAtIndex:i] setTintColor:tintColor];
            UIView *segment = (UIView *) [[sender subviews] objectAtIndex:i];
            for (UIView *view in [segment subviews]){
                if ([view isKindOfClass:[UILabel class]]){
                    UILabel *lb = (UILabel *) view;
                    lb.font = [UIFont boldSystemFontOfSize:17.0];
                    lb.textColor = [UIColor lightGrayColor];
                    [lb sizeToFit];
                }
            }
            
        }

    }

}



#pragma mark - memory warning

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/**/
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // jobb oldalon található információs gomb felrakása a navigationBar-ra
    UIButton *rButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    rButton.frame = CGRectMake(280, 0, 25, 25);
    [rButton addTarget:self action:@selector(goToTheAboutView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    // sajnos za interface builder nem engedi a segmentedController magasságát 30px-nél nagyobbra állítani, ezért programozottan kell megtennünk...
    scSearchType.frame = SEARCH_SEGMENTED_TYPE_FRAME;
    scSearchRadius.frame = SEARCH_SEGMENTED_RADIUS_FRAME;
    
    // a felső segmentedcontroller inicializálása
    [self segmentControlChangeSelectForType:scSearchType];
    
    // az alsó segmentedcontroller inicializálása
    scSearchRadius.tag = TAG_FOR_SEGMENTED_RADIUS;
    [self segmentControlChangeSelectForRadius:scSearchRadius];
    
    //amikor megjelenik a segmented control, akkor a "Kozelben" opcio a kivalasztott
    searchTypeSelected_ = GEOLOCATION_BASED;
    
    //az alabbi ket property magadasa szukseges ahhoz, hogy a tablazat lekerekitett sarkakkal jelenjen meg (plusz a QuartzCore import)
    voucherTypeSelectorHolder.layer.cornerRadius = 10.0f;
    voucherTypeSelectorHolder.layer.masksToBounds = YES;
    
    //ezt a hekkelest a neten talaltam: igy lehet egy kepet szinkent definialni
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"kereso_oldali_panel_hatter.png"]];
    voucherTypeSelectorHolder.backgroundColor = background;
    [background release];
    
    criteria_ = [[SearchCriteria alloc]init];
    criteria_.lodgingExpected = YES;
    criteria_.hospitalityExpected = YES;
    criteria_.leisureExpected = YES;
    
    [self addGestureRecognizer];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    if(self.settlementSelected != nil ) {
        UIView *aView = [self.view viewWithTag:TAG_FOR_SEARCH_BAR];
        if(aView != nil && [aView isKindOfClass:[UISearchBar class]]) {
            UISearchBar *searchBar = (UISearchBar *)aView;
            
            searchBar.text = [NSString stringWithFormat:@"%@, %@", settlementSelected.zipCode, settlementSelected.name];
        }
    }
    
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    
    
}

- (void)viewDidUnload {
    
    [self setScSearchRadius:nil];
    [self setBtnSearch:nil];
    [self setScSearchType:nil];
    [self setVoucherTypeSelectorHolder:nil];
     
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - event handlers
- (IBAction)doSearch:(id)sender {
    NSLog(@"%@ doSearch called", [self class]);
    
    
    UIViewController *nextView = [[SearchResult alloc]initWithNibName:@"SearchResult" bundle:[NSBundle mainBundle]];
    
    //az osszes tobbi criteria property-t a kulonbozo esemenykezelo callback-ekben azonnal beallitotjuk, amint a UI elemen az esemeny megtortenik
    [criteria_ setSettlement:settlementSelected];
    
        
    NSLog(@"criteria will be send to search: %@", criteria_);
    
    [(SearchResult *)nextView setCriteria:criteria_];
    
    [self.navigationController pushViewController:nextView animated:YES];
    
    [nextView release];
}

- (IBAction)toggleSearchType:(id)sender {
    if([sender isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl *sc = (UISegmentedControl *)sender;
        
        if([sc selectedSegmentIndex] == GEOLOCATION_BASED) {
            searchTypeSelected_ = GEOLOCATION_BASED;
            [self removeSearchBar];
            
        } else if([sc selectedSegmentIndex] == SETTLEMENT_BASED) {
            searchTypeSelected_ = SETTLEMENT_BASED;
            [self addSearchBar];
            
        } else {
            searchTypeSelected_ = NOT_SELECTED;
        }
        
        criteria_.searchType = searchTypeSelected_;
        
        NSLog(@"selected search type now: %d", criteria_.searchType);
        
    }
    [self segmentControlChangeSelectForType:scSearchType];
    
}

- (IBAction)toggleSearchRadius:(id)sender {
    
    if([sender isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl *sc = (UISegmentedControl *)sender;
        
        if([sc selectedSegmentIndex] == 0) {
            criteria_.searchRadius = 200;
        } else if([sc selectedSegmentIndex] == 1) {
            criteria_.searchRadius = 1000;
        } else if([sc selectedSegmentIndex] == 2) {
            criteria_.searchRadius = 5000;
        }
        
        NSLog(@"selected search radius now: %d", criteria_.searchRadius);
        
    }
    [self segmentControlChangeSelectForRadius:scSearchRadius];
}


#pragma mark - UITableViewDatasource protocol


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //mivel itt egy statikus tablazatrol van szo, konstans 3-at adunk vissza
    
    return 3;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"VoucherTypeCell";
    
    VoucherTypeSelectorCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        UINib *cellNib = [UINib nibWithNibName:@"VoucherTypeSelectorCell" bundle:[NSBundle mainBundle]];
        cell = [[cellNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    }
    
    if(cell != nil && [cell isKindOfClass:[VoucherTypeSelectorCell class]]) {
        if(indexPath.row == LODGING) {
            [cell setVoucherTypeForThisCell:LODGING];
            cell.lbVoucherType.text = NSLocalizedString(@"Lodging", @"Title for table cell on search root view for LODGING voucher type.");
        } else if(indexPath.row == HOSPITALITY) {
            [cell setVoucherTypeForThisCell:HOSPITALITY];
            cell.lbVoucherType.text = NSLocalizedString(@"Hospitality", @"Title for table cell on search root view for HOSPITALITY voucher type.");;
        } else if(indexPath.row == LEISURE) {
            [cell setVoucherTypeForThisCell:LEISURE];
            cell.lbVoucherType.text = NSLocalizedString(@"Leisure", @"Title for table cell on search root view for LEISURE voucher type.");
        }
    }
    
    [cell setDelegate:self];
    
    //cell.swTypeSelection.tintColor = [UIColor yellowColor];
    //cell.swTypeSelection.onTintColor = [UIColor colorWithRed:245.0/255.0 green:185.0/255.0 blue:20.0/255.0 alpha:1.0f];
    
    //self.scSearchType.tintColor = [UIColor colorWithRed:245.0/255.0 green:185.0/255.0 blue:20.0/255.0 alpha:1.0f];
    //self.scSearchRadius.tintColor = [UIColor colorWithRed:245.0/255.0 green:185.0/255.0 blue:20.0/255.0 alpha:1.0f];
    
    //self.login_bg_top3 = [UIColor colorWithRed:255.0/255.0 green:247.0/255.0 blue:207.0/255.0 alpha:255.0/255];
    
    return cell;
}


   
#pragma mark - VoucherTypeSelecting protocol

- (void)addVoucherTypeToSearchCriteria:(NSInteger)voucherType {
    NSLog(@"%@ addVoucherTypeToSearchCriteria called with %d", [self class], voucherType);
    
    switch (voucherType) {
        case HOSPITALITY: {
            criteria_.hospitalityExpected = YES;
            break;
        }
            
        case LODGING: {
            criteria_.lodgingExpected = YES;
            break;
        }
            
        case LEISURE: {
            criteria_.leisureExpected = YES;
            break;
        }
            
        default:
            break;
    }
}

- (void)removeVoucherTypeFromSearchCriteria:(NSInteger)voucherType {
    NSLog(@"%@ removeVoucherTypeFromSearchCriteria called with %d", [self class], voucherType);
    
    switch (voucherType) {
        case HOSPITALITY: {
            criteria_.hospitalityExpected = NO;
            break;
        }
            
        case LODGING: {
            criteria_.lodgingExpected = NO;
            break;
        }
            
        case LEISURE: {
            criteria_.leisureExpected = NO;
            break;
        }
            
        default:
            break;
    }

}

- (void)showInfoPageForVoucherType:(NSInteger)voucherType {
    NSLog(@"%@ showInfoPageForVoucherType called with %d", [self class], voucherType);
    
    UIViewController *detailsView = nil;
    
    switch (voucherType) {
        case LODGING: {
            detailsView = [[SubAccountLodging alloc]initWithNibName:@"SubAccountLodging" bundle:[NSBundle mainBundle]];
            break;
        }
            
        case HOSPITALITY: {
            detailsView = [[SubAccountHospitality alloc]initWithNibName:@"SubAccountHospitality" bundle:[NSBundle mainBundle]];
            break;
        }
            
        case LEISURE: {
            detailsView = [[SubAccountLeisure alloc]initWithNibName:@"SubAccountLeisure" bundle:[NSBundle mainBundle]];
            break;
        }
            
        default:
            break;
    }
    
    [self presentModalViewController:detailsView animated:YES];
    
}

#pragma mark - UISearchBarDelegate protocol

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarTextDidEndEditing called...");
    [searchBar resignFirstResponder];
}

/*
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"searchBarSearchButtonClicked called");
    [searchBar resignFirstResponder];
}
 */


/*
 Amikor a keresobe klikkel a user, azonnal atdobjuk a telepuleslista keresobe, ami egy masik view!
 */
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    SettlementSearch *nextView = [[SettlementSearch alloc]initWithNibName:@"SettlementSearch" bundle:[NSBundle mainBundle]];

    [self.navigationController pushViewController:nextView animated:YES];
    
    [nextView release];
    
    return NO;
}

#pragma mark - event handlers
- (IBAction)switchValueChanged:(id)sender {
    UISwitch *aSwitch = (UISwitch *)sender;
    NSInteger tag = aSwitch.tag;
    
    VoucherType voucherTypeSelected;
    
    if(tag == TAG_FOR_UI_SWITCH_LODGING) {
        voucherTypeSelected = LODGING;
    } else if(tag == TAG_FOR_UI_SWITCH_HOSPITALITY) {
        voucherTypeSelected = HOSPITALITY;
    } else if(tag == TAG_FOR_UI_SWITCH_LEISURE) {
        voucherTypeSelected = LEISURE;
    }
    
    if(aSwitch.isOn) {
        NSLog(@"this switch %@ is ON", aSwitch);
        [self addVoucherTypeToSearchCriteria:voucherTypeSelected];
    } else {
        NSLog(@"this switch %@ is OFF", aSwitch);
        [self removeVoucherTypeFromSearchCriteria:voucherTypeSelected];
    }
    
    
    
}

- (IBAction)someGestureRecognized:(UITapGestureRecognizer *)gestureRecognizer {
    
    UIView *eventSource = gestureRecognizer.view;
    
    NSLog(@"info button tapped? %@", eventSource);
    
    NSInteger tag = eventSource.tag;
    
    VoucherType voucherTypeSelected;
    
    if(tag == TAG_FOR_INFO_IMAGE_LODGING) {
        voucherTypeSelected = LODGING;
    } else if(tag == TAG_FOR_INFO_IMAGE_HOSPITALITY) {
        voucherTypeSelected = HOSPITALITY;
    } else if(tag == TAG_FOR_INFO_IMAGE_LEISURE) {
        voucherTypeSelected = LEISURE;
    }
    
    [self showInfoPageForVoucherType:voucherTypeSelected];
    
}





#pragma mark - dealloc
- (void)dealloc {
    [scSearchRadius release];
    [btnSearch release];
    
    [settlementSelected release];
    [criteria_ release];
       
    [scSearchType release];
    [voucherTypeSelectorHolder release];
    
    [super dealloc];
}
@end
