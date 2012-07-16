//
//  LoadingIndicator.h
//  SZEPCardApp
//
//  Created by EQL_MACMINI_3 on 2012.06.05..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define INDICATOR_SIZE 25.0f
#define INDICATOR_MARGIN 25.0f
#define INDICATOR_CORNER_RADIOUS 7.0f

@interface LoadingIndicator : UIView {
    UIView *loadingIndicator_;
}

- (id)initWithViewController:(UIViewController *) currentVC;
- (void) showLoadingIndicator:(UIViewController *) vc;
- (void) hideLoadingIndicator;

@end
