//
//  BalanceInquiryResult.m
//  SZEPCardApp
//
//  Created by Karesz on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BalanceInquiryResult.h"
#import "Authentication.h"
#import "QuartzCore/QuartzCore.h"


@interface BalanceInquiryResult(){
@private
    NSArray *balanceValues;
}

@end


@implementation BalanceInquiryResult
@synthesize lbHospitalityValue;
@synthesize lbLeisureValue;
@synthesize lbLodgingValue;
@synthesize lbDateOfQuery;
@synthesize tblBackgroundView;
@synthesize outputBalanceQuery;

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
    
    //ezt a hekkelest a neten talaltam: igy lehet egy kepet szinkent definialni
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"hatter.png"]];
    self.view.backgroundColor = background;
    [background release];
        
    [self.navigationItem setHidesBackButton:YES];
    
    //ezt a hekkelest a neten talaltam: igy lehet egy kepet szinkent definialni
    UIColor *backgroundForInView = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"lekerdezes_hattere_egyben.png"]];
    tblBackgroundView.backgroundColor = backgroundForInView;
    
    
    lbHospitalityValue.text = outputBalanceQuery.hospitality;
    lbLeisureValue.text = outputBalanceQuery.leisure;
    lbLodgingValue.text = outputBalanceQuery.lodging;
    
    lbDateOfQuery.adjustsFontSizeToFitWidth = YES;
    lbDateOfQuery.text = outputBalanceQuery.date;

    /*
    NSDictionary *balanceForHospitality = [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"hospitality balance", @"hospitality balance"), @"name",outputBalanceQuery.hospitality, @"value", nil];
    NSDictionary *balanceForLeisure = [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"leisure balance", @"leisure balance"), @"name",outputBalanceQuery.leisure, @"value", nil];
    NSDictionary *balanceForLodging = [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"lodging balance", @"lodging balance"), @"name",outputBalanceQuery.lodging, @"value", nil];
    NSDictionary *currency = [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"currency", @"currency"), @"name",@"HUF", @"value", nil];
    NSDictionary *queryDate = [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"date of query", @"date of query"), @"name",outputBalanceQuery.date, @"value", nil];
    
    
    balanceValues = [[NSArray alloc] initWithObjects:balanceForHospitality, balanceForLeisure, balanceForLodging, currency, queryDate, nil];
    
    [balanceForHospitality release];
    [balanceForLeisure release];
    [balanceForLodging release];
    [currency release];
    [queryDate release];
    
   // NSLog(@"%d, %d, %d", [lbBalanceForHospitality.text length], [lbBalanceForLeisure.text length], [lbBalanceForLodging.text length]);
    */
}

- (void)viewDidUnload
{
    
    [self setLbHospitalityValue:nil];
    [self setLbLeisureValue:nil];
    [self setLbLodgingValue:nil];
    [self setLbDateOfQuery:nil];
    [self setTblBackgroundView:nil];
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

//mivel ez a view modal view-kernt jott fel, kitakarja az osszes lehetseges navigacios gombot a UITabBarController-en. Ezert ha a user megnezte az egyenleget ezt a view-t be kell tudni zarnia!
- (IBAction)dismissModal:(id)sender {

        
    [self.navigationController popViewControllerAnimated:YES];
    
}
/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [balanceValues count];
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Cell";
    
    tableView.backgroundColor = [UIColor grayColor];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIImageView *background = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"egyenlegmezo.png"]] autorelease];
        background.frame = CGRectMake(CGRectGetMinX(cell.frame), CGRectGetMinY(cell.frame), cell.frame.size.width, cell.frame.size.height);
        cell.backgroundView = background;

        
        CGRect nameLabelRect = CGRectMake(5, 0, 150, 40);
        UILabel *lbName = [[UILabel alloc] initWithFrame:nameLabelRect];
        lbName.textAlignment = UITextAlignmentLeft;
        lbName.adjustsFontSizeToFitWidth = YES;
        lbName.tag = 1000;
        lbName.backgroundColor = [UIColor clearColor];
        lbName.font = [UIFont boldSystemFontOfSize:12.0f];
        [cell.contentView addSubview:lbName];
        
        CGRect valueLableRect = CGRectMake(200, 0, 80, 40);
        UILabel *lbValue = [[UILabel alloc] initWithFrame:valueLableRect];
        lbValue.textAlignment = UITextAlignmentLeft;
        lbValue.font = [UIFont systemFontOfSize:12.0f];
        lbValue.adjustsFontSizeToFitWidth = YES;
        lbValue.tag = 2000;
        lbValue.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:lbValue];
        
        [lbName release];
        [lbValue release];
        
    }
    
    NSDictionary *rowData = [balanceValues objectAtIndex:[indexPath row]];
    
    UILabel *name = (UILabel *)[cell.contentView viewWithTag:1000];
    name.text = [rowData objectForKey:@"name"];
    
    UILabel *value = (UILabel *)[cell.contentView viewWithTag:2000];
    value.text = [rowData objectForKey:@"value"];
    if (indexPath.row < 3){
        name.textColor = [UIColor colorWithRed:124.0/255.0 green:189.0/255.0 blue:39.0/255.0 alpha:1.0];
    }
    
    return cell;

}
*/
- (void)dealloc {
    
    [outputBalanceQuery release];
    [lbHospitalityValue release];
    [lbLeisureValue release];
    [lbLodgingValue release];
    [lbDateOfQuery release];
    [tblBackgroundView release];
    [super dealloc];
}

@end
