//
//  About.m
//  SZEPCardApp
//
//  Created by Karesz on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "About.h"

@interface About() {
    
}

-(void) clickBack;

@end

@implementation About

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
    
    UIImage *buttonImage = [UIImage imageNamed:@"fejlec_gomb.png"];
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    bButton.frame = CGRectMake(0.0f, 0.0f, buttonImage.size.width, buttonImage.size.height);
    [bButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bButton setTitle:NSLocalizedString(@"Back", @"Back") forState:UIControlStateNormal];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:bButton];
    self.navigationItem.leftBarButtonItem = backButton;
    [backButton release];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private methods

- (void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
