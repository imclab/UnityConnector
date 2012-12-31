//
//  SampleTitleViewController.h
//  UnityConnector
//
//  Created by Toru Inoue on 2012/12/03.
//  Copyright (c) 2012年 Toru Inoue. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SAMPLE_TITLEVIEWCONT	(@"SAMPLE_TITLEVIEWCONT")

typedef enum{
	SAMPLE_TITLEVIEWCONT_EXEC_UNITY_ON_TAPPED,
	SAMPLE_TITLEVIEWCONT_EXEC_GET_VIEW
} SampleTitleViewControllerEnum;


@interface SampleTitleViewController : UIViewController

- (id) initSampleTitleViewControllerWithMasterName:(NSString * )masterName;
- (IBAction)unityOnTapped:(id)sender;
@end
