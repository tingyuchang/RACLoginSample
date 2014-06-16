//
//  TTLoginViewController.m
//  RACLoginSample
//
//  Created by Matt Chang on 2014/6/16.
//  Copyright (c) 2014年 Accuvally Inc. All rights reserved.
//

#import "TTLoginViewController.h"
#import "TTLoginViewModel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "NSString+Extension.h"

@interface TTLoginViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) TTLoginViewModel *viewModel;
@property (strong, nonatomic) NSArray *candidates;

@property (strong, nonatomic) RACCommand *disappearCommand;


- (void)decorateView;

@end

@implementation TTLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _viewModel = [TTLoginViewModel new];
        
        _disappearCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal*(id input){
            NSLog(@"disappear");
            [self.view endEditing:YES];
            return [RACSignal empty];
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self decorateView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 2;
    [tap.rac_gestureSignal subscribeNext:^(id x){
        [self.disappearCommand execute:nil];
    }];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)decorateView {
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, 100, 30)];
    accountLabel.text = @"Account";
    [self.view addSubview:accountLabel];
    
    UITextField *accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 64, 200, 30)];
    accountTextField.delegate = self;
    accountTextField.keyboardType = UIKeyboardTypeEmailAddress;
    accountTextField.returnKeyType = UIReturnKeyDone;
    accountTextField.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:accountTextField];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 94, 100, 30)];
    passwordLabel.text = @"Password";
    [self.view addSubview:passwordLabel];
    
    UITextField *passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 94, 200, 30)];
    passwordTextField.returnKeyType = UIReturnKeyDone;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.delegate = self;
    [self.view addSubview:passwordTextField];
    
    @weakify(self);
    [[accountTextField.rac_textSignal distinctUntilChanged]
     subscribeNext:^(NSString *x){
         @strongify(self);
         self.viewModel.account = x;
     }];
    [[passwordTextField.rac_textSignal distinctUntilChanged]
     subscribeNext:^(NSString *x){
         @strongify(self);
         self.viewModel.password = x;
     }];
    
    
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 124, 300, 200)];
    statusLabel.numberOfLines = 0;
    [self.view addSubview:statusLabel];
    
    RAC(statusLabel, text) = RACObserve(self.viewModel, statusMessage);
    
    UIButton *racLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    racLoginButton.frame = CGRectMake(10, 324, 300, 30);
    [racLoginButton setTitle:@"RAC Login" forState:UIControlStateNormal];
    [self.view addSubview:racLoginButton];
    
    
    racLoginButton.rac_command = [[RACCommand alloc] initWithEnabled:[RACSignal combineLatest:@[[accountTextField.rac_textSignal distinctUntilChanged], [passwordTextField.rac_textSignal distinctUntilChanged]] reduce:^id(NSString *account, NSString *password) {
        return @(!([NSString isEmpty:account] || [NSString isEmpty:password]));
    }] signalBlock:^(id input) {
        [self.viewModel racLogin];
        return [RACSignal empty];
    }];
    
    [[racLoginButton.rac_command execute:nil] subscribeCompleted:^(){
        TTLog(@"command completed");
    }];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

@end
