//
//  AppDelegate.h
//  SZEPCardApp
//
//  Created by Karesz on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> 
    

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *rootController;
@property (nonatomic, retain) IBOutlet UINavigationController *navContollerForSearchScene;
@property (retain, nonatomic) IBOutlet UINavigationController *navControllerForAuthentication;

@end
