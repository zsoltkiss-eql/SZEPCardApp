//
//  LoadingIndicator.m
//  SZEPCardApp
//
//  Created by EQL_MACMINI_3 on 2012.06.05..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadingIndicator.h"
#import "QuartzCore/QuartzCore.h"

@implementation LoadingIndicator

- (id)initWithViewController:(UIViewController *) currentVC
{
    self = [super init];
    if (self) {
        if(loadingIndicator_ == nil)
        {
            // creating a nearly transparent bg view
            loadingIndicator_ = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 200, 200)];
            loadingIndicator_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            [currentVC.view addSubview:loadingIndicator_];
            UIColor *loadingIndicator_BG = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:80.0/255];
            [loadingIndicator_ setBackgroundColor:loadingIndicator_BG];
            
            UIView* inview = [[UIView alloc] initWithFrame:CGRectZero];
            UIColor *loadingIndicator_mid_BG = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:170.0/255];
            [inview setBackgroundColor:loadingIndicator_mid_BG];
            inview.layer.cornerRadius = INDICATOR_CORNER_RADIOUS;
            [loadingIndicator_ addSubview:inview];
            inview.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            
            UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [indicator startAnimating];
            [inview addSubview:indicator];
            [indicator release];
            [inview release];
            
            // adding the indicator spinner
            float x = loadingIndicator_.frame.size.width / 2 - INDICATOR_SIZE / 2;
            float y = loadingIndicator_.frame.size.height / 2 - INDICATOR_SIZE / 2;
            
            float plus = INDICATOR_MARGIN;
            
            inview.frame = CGRectMake(x-plus, y-plus, 25 + 2*plus, 25 + 2*plus);
            indicator.frame = CGRectMake(plus, plus, INDICATOR_SIZE, INDICATOR_SIZE);
        }
        
            loadingIndicator_.frame = CGRectMake(0, 0, currentVC.view.frame.size.width, currentVC.view.frame.size.height);
        
    }
    return self;
}

- (void)showLoadingIndicator:(UIViewController *) vc{
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.type = kCATransitionFade;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [vc.view.layer addAnimation:animation forKey:@"showMainIndicator"];
    
    [vc.view addSubview:loadingIndicator_];

}

- (void)hideLoadingIndicator{

    [loadingIndicator_ removeFromSuperview];
    
    [loadingIndicator_ release];
    loadingIndicator_ = nil;
}

@end
