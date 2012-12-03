//
//  KSUnityBooter.mm
//  Unity-iPhone
//
//  Created by Toru Inoue on 2012/12/02.
//
//

#import "KSUnityBooter.h"

//#import "AppController.h"
//#import "RegisterClasses.h"
//#import "RegisterMonoModules.h"

static const int constsection = 0;
bool UnityParseCommandLine(int argc, char *argv[]);

@implementation KSUnityBooter

- (id)initKSUnityBooterWithMasterName:(NSString * )masterName {
    if (self = [super init]) {
        messenger = [[MessengerSystem alloc] initWithBodyID:self withSelector:@selector(receiver:) withName:KS_UNITYBOOTER];
        [messenger inputParent:masterName];
    }
    return self;
}

- (void) receiver:(NSNotification * )notif {
    NSString * exec = [messenger getExecFromNortification:notif];
    NSDictionary * dict = [messenger getTagValueDictionaryFromNotification:notif];
    
    
    if ([exec isEqualToString:KS_UNITYBOOTER_EXEC_INITIALIZE]) {
        NSAssert([dict valueForKey:@"application"],@"application required");
        NSAssert([dict valueForKey:@"launchOptions"], @"launchOptions required");
        
        UIApplication * application = [dict valueForKey:@"application"];
        NSDictionary * launchOptions = [dict valueForKey:@"launchOptions"];
        
//        RegisterMonoModules();
//        
//        AppController * unityApp = [[AppController alloc]init];
//        [unityApp application:application didFinishLaunchingWithOptions:launchOptions];
    }
}



@end
