//
//  LoginViewController.m
//  DailyDesserts
//
//  Created by Krishantha Jayathilake on 2014/01/13.
//  Copyright (c) 2014 TechOne. All rights reserved.
//

#import "LoginViewController.h"
#import "Colors.h"
#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"
#import "AppScreen.h"

@interface LoginViewController ()

@property (nonatomic) UIView *backgroudView;
@property (nonatomic) UITextField *txtPassword;
@property (nonatomic) UIButton *btnSignIn;
@property (nonatomic) UIToolbar *toolbar;
@property (nonatomic) UIBarButtonItem *btnLogin;
@property (nonatomic, assign) CGFloat kbHeight;

@end

@implementation LoginViewController

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
    
    self.navigationItem.title = @"DAILY DESSERT";
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGesture];
    
    [self registerForKeyboardNotifications];
    
    UIView *paddingPass = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.txtPassword = [[UITextField alloc]init];
    self.txtPassword.placeholder = @"Password";
    self.txtPassword.backgroundColor = [UIColor whiteColor];
    self.txtPassword.secureTextEntry = YES;
    self.txtPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.txtPassword.borderStyle = UITextBorderStyleRoundedRect;
    self.txtPassword.leftView = paddingPass;
    self.txtPassword.leftViewMode = UITextFieldViewModeAlways;
    self.txtPassword.tag = 111;
    [self.view addSubview:self.txtPassword];
    
    self.btnLogin = [[UIBarButtonItem alloc]initWithTitle:@"LOGIN" style:UIBarButtonItemStyleDone target:self action:@selector(loginButtonClicked)];
    
    self.toolbar = [[UIToolbar alloc] init];
    self.toolbar.barStyle = UIBarStyleDefault;
    self.toolbar.tag = 101;
    
    //Add the toolbar as a subview to the navigation controller.
    [self.navigationController.view addSubview:self.toolbar];
    
    
}

#pragma mark - Responding to keyboard events

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    
    NSDictionary* info = [notification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    if ([AppScreen isInLandscapeMode])
        self.kbHeight = kbSize.width;
    else
        self.kbHeight = kbSize.height;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.txtPassword.frame = CGRectMake(width/2- self.txtPassword.frame.size.width/2, (height - self.kbHeight)/2 - self.txtPassword.frame.size.height/2 + 30, self.txtPassword.frame.size.width, self.txtPassword.frame.size.height);
        
    } completion:^(BOOL finished) {
        
    }];
    
    //NSLog(@"%f - %f",self.screenHeight,self.kbHeight);
    
}
- (void)keyboardWillHide:(NSNotification *)notification {
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.txtPassword.frame = CGRectMake(width/2- self.txtPassword.frame.size.width/2, height/2 - self.txtPassword.frame.size.height/2, self.txtPassword.frame.size.width, self.txtPassword.frame.size.height);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    
    if (recognizer.view.tag != 111) {
        
        [self.view endEditing:YES];
        
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self.toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, self.btnLogin, flexibleSpace, nil]];
}

- (void) loginButtonClicked
{
    HomeViewController *vc = [[HomeViewController alloc]initWithNibName:Nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillLayoutSubviews
{
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    self.txtPassword.frame = CGRectMake(20, height/2 - 20, width - 40, 40);
    
    //Set the toolbar to fit the width of the app.
    [self.toolbar sizeToFit];
    
    //Caclulate the height of the toolbar
    CGFloat toolbarHeight = [self.toolbar frame].size.height;
    
    //Get the bounds of the parent view
    CGRect viewBounds = self.parentViewController.view.bounds;
    
    //Get the height of the parent view.
    CGFloat rootViewHeight = CGRectGetHeight(viewBounds);
    
    //Get the width of the parent view,
    CGFloat rootViewWidth = CGRectGetWidth(viewBounds);
    
    //Create a rectangle for the toolbar
    CGRect rectArea = CGRectMake(0, rootViewHeight - toolbarHeight, rootViewWidth, toolbarHeight);
    
    //Reposition and resize the receiver
    [self.toolbar setFrame:rectArea];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
