//
//  SamplePinViewControler.m
//  UnityConnector
//
//  Created by sassembla on 2012/12/22.
//  Copyright (c) 2012年 Toru Inoue. All rights reserved.
//

#import "SamplePinViewControler.h"
#import "KSMessenger.h"

@interface SamplePinViewControler ()

@end

@implementation SamplePinViewControler
KSMessenger * messenger;


- (id) initSamplePinViewControlerWithMasterName:(NSString * )masterName {
	if (self = [super init]) {
		messenger = [[KSMessenger alloc]initWithBodyID:self withSelector:@selector(receiver:) withName:SAMPLE_PINVIEWCONT];
		[messenger connectParent:masterName];
	}
	return self;
}

- (IBAction)tapped:(id)sender {
	UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"active" message:@"can react UI-something" delegate:self cancelButtonTitle:@"DONE" otherButtonTitles:nil];
	[alertView show];
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
