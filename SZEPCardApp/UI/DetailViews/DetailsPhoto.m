//
//  DetailsPhoto.m
//  SZEPCardApp
//
//  Created by EQL_MACMINI_3 on 2012.06.08..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailsPhoto.h"
#import <QuartzCore/QuartzCore.h>

@interface DetailsPhoto ()

@end

@implementation DetailsPhoto
@synthesize imageViewForHeader;
@synthesize imageViewForPhoto, photoImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Sajnos a gombon lévő szöveg mögöttes árnyéka miatt kódból kellett lerakni a gombot, így ez a .xib fájlokban nem szerepelhetett...
    UIImage *buttonImage = [UIImage imageNamed:@"fejlec_gomb.png"];
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(disMiss:) forControlEvents:UIControlEventTouchUpInside];
    bButton.frame = CGRectMake(5.0f, 8.0f, buttonImage.size.width, buttonImage.size.height);
    [bButton.titleLabel setShadowColor:[UIColor blackColor]];
    [bButton.titleLabel setShadowOffset:CGSizeMake(0.0, 0.0)];
    bButton.titleLabel.layer.shadowRadius = 1.0;
    bButton.titleLabel.layer.shadowOpacity = 0.3;
    [bButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [bButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bButton setTitle:NSLocalizedString(@"Back", @"Back") forState:UIControlStateNormal];
    [self.view addSubview:bButton];
        
    self.imageViewForPhoto.image = photoImage;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setImageViewForPhoto:nil];
    [self setImageViewForHeader:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)disMiss:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
    
}


- (void)dealloc {
    [imageViewForPhoto release];
    [imageViewForHeader release];
    [super dealloc];
}

@end
