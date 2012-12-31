//
//  AppDelegate.m
//  UnityConnector
//
//  Created by Toru Inoue on 2012/11/14.
//  Copyright (c) 2012年 Toru Inoue. All rights reserved.
//

#import "AppDelegate.h"
#import "KSUnityConnector.h"

#import "SampleTitleViewController.h"
#import "SamplePinViewControler.h"
#import "BaseViewController.h"

#import "KSMessenger.h"

@implementation AppDelegate


void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    m_application = application;
    m_launchOptions = [[NSDictionary alloc]init];
    
    
    messenger = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(receiver:) withName:CONNECTOR_MASTER];
	
    KSUnityConnector * unityConnect = [[KSUnityConnector alloc]initKSUnityConnectorWithMasterName:CONNECTOR_MASTER];
    
    sampleVCont = [[SampleTitleViewController alloc]initSampleTitleViewControllerWithMasterName:CONNECTOR_MASTER];
    
    [self.window addSubview:sampleVCont.view];

    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)receiver:(NSNotification * )notif {
    NSDictionary * dict = [messenger tagValueDictionaryFromNotification:notif];
	
//	[messenger adoptSelectorsAndExecs,
//	 @selector(method:), SAMPLE_TITLEVIEWCONT_EXEC_UNITY_ON_TAPPED,
// 	 @selector(method:), SAMPLE_TITLEVIEWCONT_EXEC_UNITY_ON_TAPPED,
//	 nil];
	
	switch ([messenger execFrom:SAMPLE_TITLEVIEWCONT viaNotification:notif]) {
		case SAMPLE_TITLEVIEWCONT_EXEC_UNITY_ON_TAPPED:{
			/*
			 ignite Unity
			 */
			[messenger call:KS_UNITYCONNECTOR withExec:KS_UNITYCONNECTOR_EXEC_INITIALIZE,
			 [messenger tag:@"application" val:m_application],
			 [messenger tag:@"launchOptions" val:m_launchOptions],
			 nil];
			break;
		}	
		case NONE:{
			NSLog(@"不明なexec %@", notif);
			break;
		}
			
		default:
			NSAssert(false, @"not match1");
			break;
	}
	
	switch ([messenger execFrom:KS_UNITYCONNECTOR viaNotification:notif]) {
		case KS_UNITYCONNECTOR_EXEC_VIEWCANBEAPPEND:{
			/*
			 generate pinView(back button inside.)
			 */
			SamplePinViewControler * samplePinViewCont = [[SamplePinViewControler alloc]init];
			
			BaseViewController * baseView = [[BaseViewController alloc]init];
			
			[baseView.view addSubview:samplePinViewCont.view];
			[messenger call:KS_UNITYCONNECTOR withExec:KS_UNITYCONNECTOR_EXEC_ADD_VIEW,
			 [messenger tag:@"view" val:baseView.view],
			 nil];
			break;
		}
		case NONE:{
			
			break;
		}
		default:
			NSAssert(false, @"not match2	%d", [messenger execFrom:KS_UNITYCONNECTOR viaNotification:notif]);
			break;
	}
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [messenger call:KS_UNITYCONNECTOR withExec:KS_UNITYCONNECTOR_EXEC_WILLRESIGNACTIVE,
     [messenger tag:@"application" val:application],
     nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [messenger call:KS_UNITYCONNECTOR withExec:KS_UNITYCONNECTOR_EXEC_DIDENTERBACKGROUND,
     [messenger tag:@"application" val:application],
     nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [messenger call:KS_UNITYCONNECTOR withExec:KS_UNITYCONNECTOR_EXEC_WILLENTERFOREGROUND,
     [messenger tag:@"application" val:application],
     nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [messenger call:KS_UNITYCONNECTOR withExec:KS_UNITYCONNECTOR_EXEC_DIDBECOMEACTIVE,
     [messenger tag:@"application" val:application],
     nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [messenger call:KS_UNITYCONNECTOR withExec:KS_UNITYCONNECTOR_EXEC_WILLTERMINATE,
     [messenger tag:@"application" val:application],
     nil];
}

@end
