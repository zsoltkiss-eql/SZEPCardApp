//
//  AppDelegate.m
//  SZEPCardApp
//
//  Created by Karesz on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "AppNavigator.h"
#import "SearchRoot.h"
#import "DCIntrospect.h"
#import "Authentication.h"
#import "AcceptancePointDetails.h"
#import "Authentication_iPad.h"
#import "SearchRoot_iPad.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize rootController, navContollerForSearchScene, navControllerForAuthentication;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    if(IPHONE) {
        [[NSBundle mainBundle]loadNibNamed:@"AppNavigator" owner:self options:nil];
        
        
        // sajnos nem sikerült az interface builderben működésre bírni a local alapján a .xib-et, ezért így adtam feliratot az ikon alá...
        UITabBarItem *item = [[[rootController tabBar] items] objectAtIndex:0];
        [item setTitle:NSLocalizedString(@"Balance", @"Balance")];
        
        SearchRoot *searchRoot = [[[SearchRoot alloc]initWithNibName:@"SearchRoot" bundle:[NSBundle mainBundle]]autorelease];
        
        //ezt a hekkelest a neten talaltam: igy lehet egy kepet szinkent definialni
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"hatter.png"]];
        searchRoot.view.backgroundColor = background;
        
        
        [navContollerForSearchScene.navigationBar setBackgroundImage:[UIImage imageNamed:@"fejlec.png"] forBarMetrics:UIBarMetricsDefault];
        [navContollerForSearchScene pushViewController:searchRoot animated:YES];
        
        Authentication *auth = [[[Authentication alloc]initWithNibName:@"Authentication" bundle:[NSBundle mainBundle]]autorelease];
        auth.view.backgroundColor = background;
        [navControllerForAuthentication.navigationBar setBackgroundImage:[UIImage imageNamed:@"fejlec.png"] forBarMetrics:UIBarMetricsDefault];
        [navControllerForAuthentication pushViewController:auth animated:YES];
        
        [background release];
        [self.window addSubview:rootController.view];
        
        self.window.backgroundColor = [UIColor whiteColor];
    
    } else {
        [[NSBundle mainBundle]loadNibNamed:@"AppNavigator_iPad" owner:self options:nil];
        
        
        SearchRoot_iPad *searchRoot = [[[SearchRoot_iPad alloc]initWithNibName:@"SearchRoot_iPad" bundle:[NSBundle mainBundle]]autorelease];
        
       // [navContollerForSearchScene.navigationBar setBackgroundImage:[UIImage imageNamed:@"ipad_allo.png"] forBarMetrics:UIBarMetricsDefault];
        [navContollerForSearchScene pushViewController:searchRoot animated:YES];
        
        Authentication_iPad *auth = [[[Authentication_iPad alloc]initWithNibName:@"Authentication_iPad" bundle:[NSBundle mainBundle]]autorelease];
        
       // [navControllerForAuthentication.navigationBar setBackgroundImage:[UIImage imageNamed:@"ipad_allo.png"] forBarMetrics:UIBarMetricsDefault];
        [navControllerForAuthentication pushViewController:auth animated:YES];
        
        [self.window addSubview:rootController.view];
    }
    
    [self.window makeKeyAndVisible];
    
    
#if TARGET_IPHONE_SIMULATOR
    [[DCIntrospect sharedIntrospector] start];
#endif
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
