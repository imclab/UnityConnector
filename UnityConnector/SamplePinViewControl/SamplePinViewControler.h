//
//  SamplePinViewControler.h
//  UnityConnector
//
//  Created by sassembla on 2012/12/22.
//  Copyright (c) 2012年 Toru Inoue. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SAMPLE_PINVIEWCONT	(@"SAMPLE_PINVIEWCONT")

@interface SamplePinViewControler : UIViewController

- (id) initSamplePinViewControlerWithMasterName:(NSString * )masterName;
- (IBAction)tapped:(id)sender;

@end
