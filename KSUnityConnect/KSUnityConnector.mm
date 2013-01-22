//
//  KSUnityConnector.mm
//  Unity-iPhone
//
//  Created by Toru Inoue on 2012/12/02.
//
//

/*
 Connect between Unity to iOS, from iOS-side-messaging.

 extends the messaging function of the Unity,
 also add some iOS-User-interface generating functions.
 
 ・Boot the UnityApp from iOS
 ・Add the UIView-series onto the top view of UnityApp, from iOS
 ・Generate iOS-native GUI using xib from Unity.(experimental)
 ・Set "triggers and params" from the UnitApp-side, to iOS-generated UI.(experimental)
 */

#import "KSUnityConnector.h"

#import "AppController.h"
#import "RegisterClasses.h"
#import "RegisterMonoModules.h"

#import "KSMessenger.h"

static const int constsection = 0;
bool UnityParseCommandLine(int argc, char *argv[]);

@interface KSUnityConnector () {
	KSMessenger * messenger;
	AppController * unityApp;
}

@end

@implementation KSUnityConnector

- (id)initKSUnityConnectorWithMasterName:(NSString * )masterName {
    if (self = [super init]) {
        messenger = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(receiver:) withName:KS_UNITYCONNECTOR];
        [messenger connectParent:masterName];
    }
    return self;
}
- (void) info:(NSNotification * )notif {
	//remove observe
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[messenger callParent:KS_UNITYCONNECTOR_EXEC_VIEWCANBEAPPEND, nil];
}

- (void) receiver:(NSNotification * )notif {
    NSDictionary * dict = [messenger tagValueDictionaryFromNotification:notif];
    
	
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
    switch ([messenger execFrom:[messenger myParentName] viaNotification:notif]) {
		case KS_UNITYCONNECTOR_EXEC_INITIALIZE:{
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
			break;
		}
		    
		case KS_UNITYCONNECTOR_EXEC_DIDBECOMEACTIVE:{
			NSAssert([dict valueForKey:@"application"],@"application required");
			[unityApp applicationDidBecomeActive:[dict valueForKey:@"application"]];
			break;
		}
		case KS_UNITYCONNECTOR_EXEC_WILLRESIGNACTIVE:{
			NSAssert([dict valueForKey:@"application"],@"application required");
			[unityApp applicationWillResignActive:[dict valueForKey:@"application"]];
			break;
		}
    
		case KS_UNITYCONNECTOR_EXEC_WILLTERMINATE:{
			[unityApp applicationWillTerminate:[dict valueForKey:@"application"]];
			break;
		}
    
    
		case KS_UNITYCONNECTOR_EXEC_DIDRECEIVEMEMORYWARNING:{
			NSAssert([dict valueForKey:@"application"],@"application required");
			[unityApp applicationDidReceiveMemoryWarning:[dict valueForKey:@"application"]];
			break;
		}
			
		/*
		 notification
		 */
		case KS_UNITYCONNECTOR_EXEC_DIDREGISTERFORREMOTENOTIFICATIONSWITHDEVICETOKEN:{
			NSAssert([dict valueForKey:@"application"],@"application required");
			NSAssert([dict valueForKey:@"deviceToken"],@"deviceToken required");
			[unityApp application:[dict valueForKey:@"application"] didRegisterForRemoteNotificationsWithDeviceToken:[dict valueForKey:@"deviceToken"]];
			break;
		}
			
		case KS_UNITYCONNECTOR_EXEC_DIDFAILTOREGISTERFORREMOTENOTIFICATIONWITHERROR:{
			NSAssert([dict valueForKey:@"application"],@"application required");
			NSAssert([dict valueForKey:@"error"],@"error required");
			[unityApp application:[dict valueForKey:@"application"] didFailToRegisterForRemoteNotificationsWithError:[dict valueForKey:@"error"]];
			break;
		}
    
		case KS_UNITYCONNECTOR_EXEC_DIDRECEIVEREMOTENOTIFICATION:{
			NSAssert([dict valueForKey:@"application"],@"application required");
			NSAssert([dict valueForKey:@"userInfo"],@"userInfo required");
			[unityApp application:[dict valueForKey:@"application"] didReceiveRemoteNotification:[dict valueForKey:@"userInfo"]];
			break;
		}
    
		case KS_UNITYCONNECTOR_EXEC_DIDRECEIVELOCALNOTIFICATION:{
			NSAssert([dict valueForKey:@"application"],@"application required");
			NSAssert([dict valueForKey:@"notification"],@"notification required");
			[unityApp application:[dict valueForKey:@"application"] didReceiveLocalNotification:[dict valueForKey:@"notification"]];
			break;
		}
			
		/*
		 entering
		 */
		case KS_UNITYCONNECTOR_EXEC_DIDENTERBACKGROUND:{
			NSAssert([dict valueForKey:@"application"],@"application required");
			[unityApp applicationDidEnterBackground:[dict valueForKey:@"application"]];
			break;
		}
			
		case KS_UNITYCONNECTOR_EXEC_WILLENTERFOREGROUND:{
			NSAssert([dict valueForKey:@"application"],@"application required");
			[unityApp applicationWillEnterForeground:[dict valueForKey:@"application"]];
			break;
		}
		
		/*
		 rotation
		 */
		case KS_UNITYCONNECTOR_EXEC_SUPPORTEDINTERFACEORIENTATIONFORWINDOW:{
			NSAssert([dict valueForKey:@"application"],@"application required");
			NSAssert([dict valueForKey:@"window"],@"window required");
			[unityApp application:[dict valueForKey:@"application"] supportedInterfaceOrientationsForWindow:[dict valueForKey:@"window"]];
			break;
		}
			
        
	
		/*
		 adding:view control
		 */
		case KS_UNITYCONNECTOR_EXEC_ADD_VIEW:{
			NSAssert([dict valueForKey:@"view"], @"view required");
			
			//add subview to Unity-Window
			[m_unityWindow addSubview:[dict valueForKey:@"view"]];
			break;
		}
			
		case KS_UNITYCONNECTOR_EXEC_REMOVE_ALL_VIEW:{
			NSAssert(false, @"not yet implemented");
			break;
		}
	
		/*
		 adding:receive message from UnityApp
		 */
	
			
		//実験
		case KS_UNITYCONNECTOR_EXEC_CONNECT:{
			UnitySendMessage("AppController", "flag", "");
			break;
		}
			
		case KS_UNITYCONNECTOR_EXEC_CONNECT_2:{
			NSAssert([dict valueForKey:@"value"], @"value required");
			const char * data = "NativeInterfaceReceiver";
			UnitySendMessage("AppController", "flagWithData", data);
			break;
		}
	}
	
}

/*
 実験
 */
char * MakeStringCopy (const char * string) {
	if (string == NULL)
		return NULL;
	
	char * res = (char * )malloc(strlen(string) + 1);
	strcpy(res, string);
	return res;
}

extern "C" {
	void toFlag() {
		NSLog(@"flag!!");
	}
	
	void toFlagWithData(char * data) {
		NSLog(@"flagWithData %s", data);
	}
	
	char * toFlagWithDataThenReturn (char * data) {
		NSLog(@"toFlagWithDataThenReturn %s", data);
		NSArray * languages = [NSLocale preferredLanguages];
		NSString * currentLanguage = [languages objectAtIndex:0];
		return MakeStringCopy([currentLanguage UTF8String]);
	}
}





- (void) dealloc {
    [messenger closeConnection];
}



@end
