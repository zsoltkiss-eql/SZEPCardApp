//
//  SearchRoot_iPad.m
//  SZEPCardApp
//
//  Created by Karesz on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchRoot_iPad.h"
#import "SearchCriteria.h"
#import "SubAccountLodging.h"
#import "SubAccountHospitality.h"
#import "SubAccountLeisure.h"

#define TAG_FOR_INFO_IMAGE_LODGING 101
#define TAG_FOR_INFO_IMAGE_HOSPITALITY 102
#define TAG_FOR_INFO_IMAGE_LEISURE 103

#define TAG_FOR_UI_SWITCH_LODGING 104
#define TAG_FOR_UI_SWITCH_HOSPITALITY 105
#define TAG_FOR_UI_SWITCH_LEISURE 106


@interface SearchRoot_iPad() {
@private
    
    //taroljuk az allapotukat, hogy egy elforgatas utan initelni tudjuk a search panel-en a kontrolokat
    //BOOL lodgingSwithOn_;
    //BOOL leisureSwitchOn_;
    //BOOL hospitalitySwitchOn_;
    
    SearchCriteria *criteria_;
    
}

//ezt forgatas utan meg kell hivni, hogy a search panelen a UISwitch-ek allapotat initeljuk
- (void)initSearchPanelState;

@end

@implementation SearchRoot_iPad
@synthesize searchPanel;
@synthesize swLodging;
@synthesize swHospitality;
@synthesize swLeisure;

#pragma mark - private methods

- (void)initSearchPanelState {
    
    UISwitch *lodgingSwitch = (UISwitch *)[searchPanel viewWithTag:TAG_FOR_UI_SWITCH_LODGING];
    UISwitch *hospitalitySwitch = (UISwitch *)[searchPanel viewWithTag:TAG_FOR_UI_SWITCH_HOSPITALITY];
    UISwitch *leisureSwitch = (UISwitch *)[searchPanel viewWithTag:TAG_FOR_UI_SWITCH_LEISURE];
    
    if(criteria_.lodgingExpected) {
        [lodgingSwitch setOn:YES];
    } else {
        [lodgingSwitch setOn:NO];
    }
    
    if(criteria_.hospitalityExpected) {
        [hospitalitySwitch setOn:YES];
    } else {
        [hospitalitySwitch setOn:NO];
    }
    
    if(criteria_.leisureExpected) {
        [leisureSwitch setOn:YES];
    } else {
        [leisureSwitch setOn:NO];
    }
    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    criteria_ = [[SearchCriteria alloc]init];
    criteria_.lodgingExpected = YES;
    criteria_.hospitalityExpected = YES;
    criteria_.leisureExpected = YES;
    
    self.navigationController.title = @"Some title";
    
    if(UIDeviceOrientationIsPortrait([[UIDevice currentDevice]orientation])) {
        [[NSBundle mainBundle] loadNibNamed:@"SearchPanel_Portrait" owner:self options:nil];
    } else {
        [[NSBundle mainBundle] loadNibNamed:@"SearchPanel_Landscape" owner:self options:nil];
    }
    
    [self.view addSubview:searchPanel];
    
}

- (void)viewDidUnload
{
    [self setSearchPanel:nil];
    [self setSwLodging:nil];
    [self setSwHospitality:nil];
    [self setSwLeisure:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}



- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [searchPanel removeFromSuperview];
    
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft: {
            
            [[NSBundle mainBundle] loadNibNamed:@"SearchPanel_Landscape" owner:self options:nil];
            break;
        }
            
        case UIInterfaceOrientationLandscapeRight: {
            
            [[NSBundle mainBundle] loadNibNamed:@"SearchPanel_Landscape" owner:self options:nil];
            break;
        }
            
        case UIInterfaceOrientationPortrait: {
            
            [[NSBundle mainBundle] loadNibNamed:@"SearchPanel_Portrait" owner:self options:nil];
            break;
        }
            
        case UIInterfaceOrientationPortraitUpsideDown: {
            
            [[NSBundle mainBundle] loadNibNamed:@"SearchPanel_Portrait" owner:self options:nil];
            break;
        }
            
        default:
            break;
    }
    
    [self initSearchPanelState];
    
    [self.view addSubview:searchPanel];
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


#pragma mark - dealloc
- (void)dealloc {
    [searchPanel release];
    [swLodging release];
    [swHospitality release];
    [swLeisure release];
    [super dealloc];
}

@end
