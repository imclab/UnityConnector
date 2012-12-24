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
#import "SamplePinViewControler.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    
    m_application = application;
    m_launchOptions = [[NSDictionary alloc]init];
    
    
    messenger = [[MessengerSystem alloc] initWithBodyID:self withSelector:@selector(receiver:) withName:CONNECTOR_MASTER];
    KSUnityBooter * unityBoot = [[KSUnityBooter alloc]initKSUnityBooterWithMasterName:CONNECTOR_MASTER];
    
    sampleVCont = [[SampleTitleViewController alloc]initSampleTitleViewControllerWithMasterName:CONNECTOR_MASTER];
    
    [self.window addSubview:sampleVCont.view];

    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)receiver:(NSNotification * )notif {
    NSString * exec = [messenger getExecFromNotification:notif];
    NSDictionary * dict = [messenger getTagValueDictionaryFromNotification:notif];
    
    if ([exec isEqualToString:SAMPLE_TITLEVIEWCONT_EXEC_UNITY_ON_TAPPED]) {
		
		/*
		 ignite Unity
		 */
        [messenger call:KS_UNITYBOOTER withExec:KS_UNITYBOOTER_EXEC_INITIALIZE,
         [messenger tag:@"application" val:m_application],
         [messenger tag:@"launchOptions" val:m_launchOptions],
         nil];
	}
	
	if ([exec isEqualToString:KS_UNITYBOOTER_EXEC_VIEWCANBEAPPEND]) {
		/*
		 generate pinView(back button inside.)
		 */
		SamplePinViewControler * samplePinViewCont = [[SamplePinViewControler alloc]init];
		[messenger call:KS_UNITYBOOTER withExec:KS_UNITYBOOTER_EXEC_ADD_VIEW,
		 [messenger tag:@"view" val:samplePinViewCont.view],
		 nil];
	}

}

- (void)applicationWillResignActive:(UIApplication *)application {
    [messenger call:KS_UNITYBOOTER withExec:KS_UNITYBOOTER_EXEC_WILLRESIGNACTIVE,
     [messenger tag:@"application" val:application],
     nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [messenger call:KS_UNITYBOOTER withExec:KS_UNITYBOOTER_EXEC_DIDENTERBACKGROUND,
     [messenger tag:@"application" val:application],
     nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [messenger call:KS_UNITYBOOTER withExec:KS_UNITYBOOTER_EXEC_WILLENTERFOREGROUND,
     [messenger tag:@"application" val:application],
     nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [messenger call:KS_UNITYBOOTER withExec:KS_UNITYBOOTER_EXEC_DIDBECOMEACTIVE,
     [messenger tag:@"application" val:application],
     nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [messenger call:KS_UNITYBOOTER withExec:KS_UNITYBOOTER_EXEC_WILLTERMINATE,
     [messenger tag:@"application" val:application],
     nil];
}

@end
