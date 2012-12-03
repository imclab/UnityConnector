//
//  AppDelegate.m
//  UnityConnector
//
//  Created by Toru Inoue on 2012/11/14.
//  Copyright (c) 2012年 Toru Inoue. All rights reserved.
//

#import "AppDelegate.h"
#import "KSUnityBooter.h"
#import "SampleTitleViewController.h"


@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    
    m_application = application;
    m_launchOptions = [[NSDictionary alloc]init];
    
    
    messenger = [[MessengerSystem alloc] initWithBodyID:self withSelector:@selector(receiver:) withName:CONNECTOR_MASTER];
    KSUnityBooter * unityBoot = [[KSUnityBooter alloc]initKSUnityBooterWithMasterName:CONNECTOR_MASTER];
    
    SampleTitleViewController * sampleVCont = [[SampleTitleViewController alloc]initSampleTitleViewControllerWithMasterName:CONNECTOR_MASTER];
    
    [self.window addSubview:sampleVCont.view];

    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)receiver:(NSNotification * )notif {
    NSString * exec = [messenger getExecFromNotification:notif];
    NSDictionary * dict = [messenger getTagValueDictionaryFromNotification:notif];
    
    if ([exec isEqualToString:SAMPLE_TITLEVIEWCONT_EXEC_UNITY_ON_TAPPED]) {
        [messenger call:KS_UNITYBOOTER withExec:KS_UNITYBOOTER_EXEC_INITIALIZE,
         [messenger tag:@"application" val:m_application],
         [messenger tag:@"launchOptions" val:m_launchOptions],
         nil];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
