//
//  AppDelegate.h
//  UnityConnector
//
//  Created by Toru Inoue on 2012/11/14.
//  Copyright (c) 2012年 Toru Inoue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessengerSystem.h"

#import "SampleTitleViewController.h"


#define CONNECTOR_MASTER   (@"CONNECTOR_MASTER")
#define CONNECTOR_MASTER_EXEC_SET_VIEW_TO_UNITYWINDOW	(@"CONNECTOR_MASTER_EXEC_SET_VIEW_TO_UNITYWINDOW")



@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    MessengerSystem * messenger;
    UIApplication * m_application;
    NSDictionary * m_launchOptions;
	
	SampleTitleViewController * sampleVCont;
}

@property (strong, nonatomic) UIWindow *window;

@end
