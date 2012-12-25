//
//  KSUnityConnector.mm
//  Unity-iPhone
//
//  Created by Toru Inoue on 2012/12/02.
//
//

#import "KSUnityConnector.h"

#import "AppController.h"
#import "RegisterClasses.h"
#import "RegisterMonoModules.h"


static const int constsection = 0;
bool UnityParseCommandLine(int argc, char *argv[]);

@implementation KSUnityConnector

AppController * unityApp;

- (id)initKSUnityConnectorWithMasterName:(NSString * )masterName {
    if (self = [super init]) {
        messenger = [[MessengerSystem alloc] initWithBodyID:self withSelector:@selector(receiver:) withName:KS_UNITYCONNECTOR];
        [messenger inputParent:masterName];
    }
    return self;
}
- (void) info:(NSNotification * )notif {
	//remove observe
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[messenger callParent:KS_UNITYCONNECTOR_EXEC_VIEWCANBEAPPEND, nil];
}

- (void) receiver:(NSNotification * )notif {
    NSString * exec = [messenger getExecFromNotification:notif];
    NSDictionary * dict = [messenger getTagValueDictionaryFromNotification:notif];
    
    
    //unity-app wrapper with UIApplicationDelegate
    /*
     o     - (void)applicationDidFinishLaunching:(UIApplication *)application;
     o     - (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions NS_AVAILABLE_IOS(6_0);
     o     - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions NS_AVAILABLE_IOS(3_0);
     
     o     - (void)applicationDidBecomeActive:(UIApplication *)application;
     o     - (void)applicationWillResignActive:(UIApplication *)application;
     
     - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;  // Will be deprecated at some point, please replace with application:openURL:sourceApplication:annotation:
     - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation NS_AVAILABLE_IOS(4_2); // no equiv. notification. return NO if the application can't open for some reason
     
     o     - (void)applicationDidReceiveMemoryWarning:(UIApplication *)application;      // try to clean up as much memory as possible. next step is to terminate app
     o     - (void)applicationWillTerminate:(UIApplication *)application;
     - (void)applicationSignificantTimeChange:(UIApplication *)application;        // midnight, carrier time update, daylight savings time change
     
     - (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration;
     - (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation;
     
     - (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame;   // in screen coordinates
     - (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame;
     
     // one of these will be called after calling -registerForRemoteNotifications
     o     - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken NS_AVAILABLE_IOS(3_0);
     o     - (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error NS_AVAILABLE_IOS(3_0);
     
     o     - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo NS_AVAILABLE_IOS(3_0);
     o     - (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification NS_AVAILABLE_IOS(4_0);
     
     o     - (void)applicationDidEnterBackground:(UIApplication *)application NS_AVAILABLE_IOS(4_0);
     o     - (void)applicationWillEnterForeground:(UIApplication *)application NS_AVAILABLE_IOS(4_0);
     
     - (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application NS_AVAILABLE_IOS(4_0);
     - (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application    NS_AVAILABLE_IOS(4_0);
     
     o     - (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window  NS_AVAILABLE_IOS(6_0);
     */
    
    if ([exec isEqualToString:KS_UNITYCONNECTOR_EXEC_INITIALIZE]) {
        NSAssert([dict valueForKey:@"application"],@"application required");
        NSAssert([dict valueForKey:@"launchOptions"], @"launchOptions required");
        
		
        UIApplication * application = [dict valueForKey:@"application"];
        NSDictionary * launchOptions = [dict valueForKey:@"launchOptions"];
		
		/*
		 set notification-hook when the Unity-App's setup over.
		 */
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(info:) name:KS_UNITYCONNECTOR_DEFINE_OBSERVE_WHENUNITYBOOTED object:nil];
		
		
        RegisterMonoModules();
        
        unityApp = [[AppController alloc]init];
        [unityApp application:application didFinishLaunchingWithOptions:launchOptions];

		//get the Unity-Window
		NSAssert(1 < [[application windows] count], @"there is no additional Unity-Window, maybe the Unity's spec had been changed.");
		
		m_unityWindow = [[application windows] objectAtIndex:1];
    }
    
    if ([exec isEqualToString:KS_UNITYCONNECTOR_EXEC_DIDBECOMEACTIVE]) {
        NSAssert([dict valueForKey:@"application"],@"application required");
        [unityApp applicationDidBecomeActive:[dict valueForKey:@"application"]];
    }
    
    if ([exec isEqualToString:KS_UNITYCONNECTOR_EXEC_WILLRESIGNACTIVE]) {
        NSAssert([dict valueForKey:@"application"],@"application required");
        [unityApp applicationWillResignActive:[dict valueForKey:@"application"]];
    }
    
    if ([exec isEqualToString:KS_UNITYCONNECTOR_EXEC_WILLTERMINATE]) {
        [unityApp applicationWillTerminate:[dict valueForKey:@"application"]];
    }
    
    
    if ([exec isEqualToString:KS_UNITYCONNECTOR_EXEC_DIDRECEIVEMEMORYWARNING]) {
        NSAssert([dict valueForKey:@"application"],@"application required");
        [unityApp applicationDidReceiveMemoryWarning:[dict valueForKey:@"application"]];
    }
    
    /*
     notification
     */
    
    if ([exec isEqualToString:KS_UNITYCONNECTOR_EXEC_DIDREGISTERFORREMOTENOTIFICATIONSWITHDEVICETOKEN]) {
        NSAssert([dict valueForKey:@"application"],@"application required");
        NSAssert([dict valueForKey:@"deviceToken"],@"deviceToken required");
        [unityApp application:[dict valueForKey:@"application"] didRegisterForRemoteNotificationsWithDeviceToken:[dict valueForKey:@"deviceToken"]];
    }
    
    if ([exec isEqualToString:KS_UNITYCONNECTOR_EXEC_DIDFAILTOREGISTERFORREMOTENOTIFICATIONWITHERROR]) {
        NSAssert([dict valueForKey:@"application"],@"application required");
        NSAssert([dict valueForKey:@"error"],@"error required");
        [unityApp application:[dict valueForKey:@"application"] didFailToRegisterForRemoteNotificationsWithError:[dict valueForKey:@"error"]];
    }
    
    if ([exec isEqualToString:KS_UNITYCONNECTOR_EXEC_DIDRECEIVEREMOTENOTIFICATION]) {
        NSAssert([dict valueForKey:@"application"],@"application required");
        NSAssert([dict valueForKey:@"userInfo"],@"userInfo required");
        [unityApp application:[dict valueForKey:@"application"] didReceiveRemoteNotification:[dict valueForKey:@"userInfo"]];
    }
    
    if ([exec isEqualToString:KS_UNITYCONNECTOR_EXEC_DIDRECEIVELOCALNOTIFICATION]) {
        NSAssert([dict valueForKey:@"application"],@"application required");
        NSAssert([dict valueForKey:@"notification"],@"notification required");
        [unityApp application:[dict valueForKey:@"application"] didReceiveLocalNotification:[dict valueForKey:@"notification"]];
    }
    
    /*
     entering
     */
    if ([exec isEqualToString:KS_UNITYCONNECTOR_EXEC_DIDENTERBACKGROUND]) {
        NSAssert([dict valueForKey:@"application"],@"application required");
        [unityApp applicationDidEnterBackground:[dict valueForKey:@"application"]];
    }
    
    if ([exec isEqualToString:KS_UNITYCONNECTOR_EXEC_WILLENTERFOREGROUND]) {
        NSAssert([dict valueForKey:@"application"],@"application required");
        [unityApp applicationWillEnterForeground:[dict valueForKey:@"application"]];
    }
    
    /*
     rotation
     */
    if ([exec isEqualToString:KS_UNITYCONNECTOR_EXEC_SUPPORTEDINTERFACEORIENTATIONFORWINDOW]) {
        NSAssert([dict valueForKey:@"application"],@"application required");
        NSAssert([dict valueForKey:@"window"],@"window required");
        [unityApp application:[dict valueForKey:@"application"] supportedInterfaceOrientationsForWindow:[dict valueForKey:@"window"]];
    }
	
	
	/*
	 adding:view control
	 */
	if ([exec isEqualToString:KS_UNITYCONNECTOR_EXEC_ADD_VIEW]) {
		NSAssert([dict valueForKey:@"view"], @"view required");
		
		//add subview to Unity-Window
		[m_unityWindow addSubview:[dict valueForKey:@"view"]];
	}
	
	if ([exec isEqualToString:KS_UNITYCONNECTOR_EXEC_REMOVE_ALL_VIEW]) {
		
	}
}

- (void) dealloc {
    [messenger release];
    [super dealloc];
}



@end
