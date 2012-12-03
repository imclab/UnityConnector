//
//  AppDelegate.h
//  UnityConnector
//
//  Created by Toru Inoue on 2012/11/14.
//  Copyright (c) 2012年 Toru Inoue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessengerSystem.h"

#define CONNECTOR_MASTER   (@"CONNECTOR_MASTER")


@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    MessengerSystem * messenger;
    UIApplication * m_application;
    NSDictionary * m_launchOptions;
}

@property (strong, nonatomic) UIWindow *window;

@end
