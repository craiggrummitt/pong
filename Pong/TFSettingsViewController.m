//
//  TFSettingsViewController.m
//  Pong
//
//  Created by CraigGrummitt on 11/02/2014.
//  Copyright (c) 2014 Thinkful. All rights reserved.
//

#import "TFSettingsViewController.h"

@interface TFSettingsViewController ()

@end

@implementation TFSettingsViewController

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
    self.navigationItem.title = @"Settings";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(didTapDoneButton)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemCancel target:self action:@selector(didTapCancelButton)];
    [self renderView];
}
- (void)renderView
{
    [self renderColorPicker];
}
- (void) renderColorPicker {
}
- (void)didTapDoneButton {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)didTapCancelButton {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
