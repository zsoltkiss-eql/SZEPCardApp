//
//  SearchResultHeader.m
//  SZEPCardApp
//
//  Created by Karesz on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchResultHeader.h"
#import "AcceptancePoint.h"

#define BUTTON_BGCOLOR_FOR_INACTIVE_ORDERING [UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:0.0]

#define BUTTON_BGCOLOR_FOR_ACTIVE_ORDERING [UIColor colorWithRed:221.0/255.0 green:99.0/255.0 blue:0.0/255.0 alpha:0.0]

@interface SearchResultHeader() {
@private
    
}

- (void)orderByNames;
- (void)orderByDistances;

@end


@implementation SearchResultHeader
@synthesize btn1;
@synthesize btn2;
@synthesize datasource, delegate, deviceLocation;


#pragma mark - private methods

- (void)orderByNames {
    
    NSArray *result = [datasource sortedArrayUsingComparator:^(id obj1, id obj2) {
        
        AcceptancePoint *ap1 = (AcceptancePoint *)obj1;
        AcceptancePoint *ap2 = (AcceptancePoint *)obj2;
        
        return (NSComparisonResult)[ap1.name compare:ap2.name];
        
    }];
    
    [delegate reorderController:self didResultIn:result];
    
    
}

- (void)orderByDistances {
    NSArray *result = [datasource sortedArrayUsingComparator:^(id obj1, id obj2) {
        
        AcceptancePoint *ap1 = (AcceptancePoint *)obj1;
        AcceptancePoint *ap2 = (AcceptancePoint *)obj2;
        
        CLLocationDistance dist1 = [ap1 calculateDistanceFrom:deviceLocation];
        CLLocationDistance dist2 = [ap2 calculateDistanceFrom:deviceLocation];
        
        NSNumber *n1 = [NSNumber numberWithDouble:dist1];
        NSNumber *n2 = [NSNumber numberWithDouble:dist2];
        
        return (NSComparisonResult)[n1 compare:n2];
        
    }];
    
    [delegate reorderController:self didResultIn:result];

}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setBtn1:nil];
    [self setBtn2:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - event handler methods
- (IBAction)orderResults:(id)sender {
    
    if(sender == self.btn1) {
        btn1.tintColor = BUTTON_BGCOLOR_FOR_ACTIVE_ORDERING;
        btn2.tintColor = BUTTON_BGCOLOR_FOR_INACTIVE_ORDERING;
        [self orderByNames];
    } else if(sender == self.btn2) {
        btn2.tintColor = BUTTON_BGCOLOR_FOR_ACTIVE_ORDERING;
        btn1.tintColor = BUTTON_BGCOLOR_FOR_INACTIVE_ORDERING;
        [self orderByDistances];
    }
       
}


#pragma mark - dealloc
- (void)dealloc {
    
    
    [btn1 release];
    [btn2 release];
    [super dealloc];
}



@end
