//
//  HomeViewController.m
//  DailyDessert
//
//  Created by Krishantha Jayathilake on 2014/01/14.
//  Copyright (c) 2014 TechOne. All rights reserved.
//

#import "HomeViewController.h"
#import "ListViewController.h"
#import "Colors.h"

@interface HomeViewController ()

@property (nonatomic) UIDatePicker *picker;
@property (nonatomic) UIBarButtonItem *btnStart;
@property (nonatomic) UIToolbar *toolbar;

@end

@implementation HomeViewController

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
    
    self.navigationItem.title = @"HOME";
	// Do any additional setup after loading the view.
    
    //self.view.backgroundColor = [Colors background];
    
    self.picker = [[UIDatePicker alloc]init];
    self.picker.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview:self.picker];
    
//    self.btnStart = [[UIButton alloc]init];
//    [self.btnStart setTitle:@"Start" forState:UIControlStateNormal];
//    [self.btnStart setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.btnStart addTarget:self action:@selector(startButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.btnStart];
    
    self.btnStart = [[UIBarButtonItem alloc]initWithTitle:@"NEXT" style:UIBarButtonItemStyleDone target:self action:@selector(startButtonClicked)];
    
    self.toolbar = (UIToolbar *)[self.navigationController.view viewWithTag:101];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self.toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, self.btnStart, flexibleSpace, nil]];
}

- (void)startButtonClicked
{
    ListViewController *vc = [[ListViewController alloc]initWithStyle:UITableViewStyleGrouped];
    vc.date = self.picker.date;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillLayoutSubviews
{
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    self.picker.frame = CGRectMake(10, 100, width - 20, 200);
    //self.btnStart.frame = CGRectMake(10, 350, width - 20, 50);
    
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
