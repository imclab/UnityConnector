//
//  SampleTitleViewController.m
//  UnityConnector
//
//  Created by Toru Inoue on 2012/12/03.
//  Copyright (c) 2012年 Toru Inoue. All rights reserved.
//

#import "SampleTitleViewController.h"

@interface SampleTitleViewController ()

@end

@implementation SampleTitleViewController
- (id) initSampleTitleViewControllerWithMasterName:(NSString * )masterName {
    if (self = [super init]) {
        messenger = [[MessengerSystem alloc]initWithBodyID:self withSelector:@selector(receiver:) withName:SAMPLE_TITLEVIEWCONT];
        [messenger inputParent:masterName];
    }
    return self;
}

- (IBAction)unityOnTapped:(id)sender {
    [messenger callParent:SAMPLE_TITLEVIEWCONT_EXEC_UNITY_ON_TAPPED, nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
