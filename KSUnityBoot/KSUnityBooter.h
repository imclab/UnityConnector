//
//  KSUnityBooter.h
//  Unity-iPhone
//
//  Created by Toru Inoue on 2012/12/02.
//
//

#import <Foundation/Foundation.h>
#import "MessengerSystem.h"

#define KS_UNITYBOOTER  (@"KS_UNITYBOOTER")

#define KS_UNITYBOOTER_EXEC_INITIALIZE  (@"KS_UNITYBOOTER_EXEC_INITIALIZE")


@interface KSUnityBooter : NSObject {
    MessengerSystem * messenger;
}
- (id)initKSUnityBooterWithMasterName:(NSString * )masterName;
@end
