//
//  SampleTitleViewController.h
//  UnityConnector
//
//  Created by Toru Inoue on 2012/12/03.
//  Copyright (c) 2012年 Toru Inoue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessengerSystem.h"

#define SAMPLE_TITLEVIEWCONT   (@"SAMPLE_TITLEVIEWCONT")
#define SAMPLE_TITLEVIEWCONT_EXEC_UNITY_ON_TAPPED   (@"SAMPLE_TITLEVIEWCONT_EXEC_UNITY_ON_TAPPED")


@interface SampleTitleViewController : UIViewController {
    MessengerSystem * messenger;
}

- (id) initSampleTitleViewControllerWithMasterName:(NSString * )masterName;
- (IBAction)unityOnTapped:(id)sender;
@end
