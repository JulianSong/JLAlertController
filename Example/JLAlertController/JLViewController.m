//
//  JLViewController.m
//  JLAlertController
//
//  Created by julian.song on 07/23/2016.
//  Copyright (c) 2016 julian.song. All rights reserved.
//

#import "JLViewController.h"
#import <JLAlertController/JLAlertController.h>
@interface JLViewController ()
@property(nonatomic,strong)UIButton *testButton;
@end

@implementation JLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.testButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,200,40)];
    [self.testButton addTarget:self action:@selector(doAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.testButton setTitle:@"Show alert" forState:UIControlStateNormal];
    [self.testButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:self.testButton];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.testButton.center = self.view.center;
}
- (void)doAlert
{
    
    JLAlertController *alert = [[JLAlertController alloc] initAlertControllerWithTitle:@"Ask" andMessage:@"Do you like this picture ?"];
    
    UIImageView *cv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,0,200)];
    [cv setClipsToBounds:YES];
    [cv setImage:[UIImage imageNamed:@"cat"]];
    cv.contentMode = UIViewContentModeScaleAspectFill;
    cv.backgroundColor = [UIColor redColor];
    [alert addCustomView:cv];
    [alert addAction:@"Yes" withStyle:UIAlertActionStyleCancel andHandle:^(NSString *actonName) {
        
    }];
    
    [alert addAction:@"No" withStyle:UIAlertActionStyleDestructive andHandle:^(NSString *actonName) {
        
    }];
    
    [alert addAction:@"Not sure" withStyle:UIAlertActionStyleDefault andHandle:^(NSString *actonName) {
        
    }];

    [self presentViewController:alert animated:YES completion:nil];
    
}
@end
