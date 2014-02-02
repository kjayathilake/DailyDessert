//
//  DessertListViewController.m
//  DailyDessert
//
//  Created by Krishantha Jayathilake on 2014/01/15.
//  Copyright (c) 2014 TechOne. All rights reserved.
//

#import "DessertListViewController.h"
#import "DessertViewController.h"
#import "AppDelegate.h"
#import "Dessert.h"
#import "DessertInfo.h"
#import "PaidInfo.h"

@interface DessertListViewController ()

@property (nonatomic) UIBarButtonItem *btnAdd;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSArray *dessertList;
@property (nonatomic) NSMutableArray *infoList;
@property (nonatomic) DessertInfo *info;
@property (nonatomic) UIToolbar *toolbar;
@property (nonatomic) UIBarButtonItem *totalButton;
@property (nonatomic) UIBarButtonItem *paidButton;
@property (nonatomic) UIBarButtonItem *balanceButton;
@property (nonatomic) CGFloat total;
@property (nonatomic) CGFloat paid;

@end

@implementation DessertListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"DESSERT";
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.btnAdd = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClicked)];
    self.navigationItem.rightBarButtonItem = self.btnAdd;
    
    self.totalButton = [[UIBarButtonItem alloc]initWithTitle:@"T : " style:UIBarButtonItemStyleDone target:self action:nil];
    
    self.paidButton = [[UIBarButtonItem alloc]initWithTitle:@"P :" style:UIBarButtonItemStyleDone target:self action:@selector(paidButtonClicked)];
    
    self.balanceButton = [[UIBarButtonItem alloc]initWithTitle:@"B : " style:UIBarButtonItemStyleDone target:self action:nil];
    
    self.toolbar = (UIToolbar *)[self.navigationController.view viewWithTag:101];
    
}

- (void)paidButtonClicked
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Set Payment" message:[NSString stringWithFormat:@"Amount to be paid is %.02f",self.total] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"OK"]) {
        NSString *payment = [alertView textFieldAtIndex:0].text;
        
        PaidInfo *pInfo;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        
        for (PaidInfo *info in self.user.pInfos) {
            if ([[dateFormat stringFromDate:info.date] isEqualToString:[dateFormat stringFromDate:self.date]]) {
                pInfo  = info;
            }
        }
        
        if (pInfo == nil) {
            pInfo = [NSEntityDescription insertNewObjectForEntityForName:@"PaidInfo"
                                                  inManagedObjectContext:self.managedObjectContext];
            [self.user addPInfosObject:pInfo];
            pInfo.date = self.date;
        }
        
        pInfo.paid = [NSNumber numberWithFloat:[payment floatValue]];
        self.paid = [payment floatValue];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        
        [self.paidButton setTitle:[NSString stringWithFormat:@"P : %.02f",self.paid]];
        [self.balanceButton setTitle:[NSString stringWithFormat:@"B : %.02f",self.paid - self.total]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.infoList = [[NSMutableArray alloc]init];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    // Convert date object to desired output format
    //[dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
    
    int count = 0;
    self.total = 0;
    self.paid = 0;
    
    for (DessertInfo *info in self.user.infos) {
        if ([[dateFormat stringFromDate:info.date] isEqualToString:[dateFormat stringFromDate:self.date]]) {
            [self.infoList addObject:info];
            
            //NSLog(@"price = %f qty = %d total = %f",[info.dessert.price floatValue],[info.count integerValue],([info.count integerValue] * [info.dessert.price floatValue]));
            
            self.total += ([info.count integerValue] * [info.dessert.price floatValue]);
            
            count ++;
        }
    }
    
    [self.totalButton setTitle:[NSString stringWithFormat:@"T : %.02f",self.total]];
    
    for (PaidInfo *info in self.user.pInfos) {
        if ([[dateFormat stringFromDate:info.date] isEqualToString:[dateFormat stringFromDate:self.date]]) {
            self.paid = [info.paid floatValue];
            [self.paidButton setTitle:[NSString stringWithFormat:@"P : %.02f",self.paid]];
            [self.balanceButton setTitle:[NSString stringWithFormat:@"B : %.02f",self.paid - self.total]];
        }
    }
    
    
    
    
    
    self.dessertList = [self getAllDesserts];
    [self.tableView reloadData];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self.toolbar setItems:[NSArray arrayWithObjects:self.paidButton, flexibleSpace, self.totalButton, flexibleSpace, self.balanceButton, nil]];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    //[self.managedObjectContext rollback];
}

- (void)viewWillLayoutSubviews
{
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

- (void) addButtonClicked
{
    DessertViewController *vc = [[DessertViewController alloc]initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navcont = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navcont animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.user.name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.dessertList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    UIStepper *stepper = [[UIStepper alloc]init];
    stepper.tag = indexPath.row;
    [stepper sizeToFit];
    [stepper addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = stepper;
    
    cell.tag = indexPath.row;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressed:)];
    longPress.minimumPressDuration = 1.0;
    [cell addGestureRecognizer:longPress];
    
    // Configure the cell...
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.detailTextLabel.text = @"0";
    cell.textLabel.text = [(Dessert *)[self.dessertList objectAtIndex:indexPath.row] name];
    NSInteger count = 0;
    for (DessertInfo *info in self.infoList) {
        if ([info.dessert.name isEqualToString:cell.textLabel.text]) {
            count = [info.count integerValue];
        }
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d     :",(int)count];
    cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    stepper.value = count;
    
    return cell;
}

- (void) longPressed:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        UITableViewCell *cell = (UITableViewCell *)[sender view];
        NSManagedObjectID *moid = [(NSManagedObject *)[self.dessertList objectAtIndex:cell.tag] objectID];
        NSError *error;
        Dessert * dessert = (Dessert *)[self.managedObjectContext existingObjectWithID:moid error:&error];
        
        DessertViewController *vc = [[DessertViewController alloc]initWithStyle:UITableViewStyleGrouped];
        vc.dessert = dessert;
        UINavigationController *navcont = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navcont animated:YES completion:nil];
        
        
        //NSLog(@"long Pressed %@",user.name);
    }
    
}

- (void)stepperValueChanged:(id)sender
{
    UIStepper *stepper = (UIStepper *)sender;
    
    //NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:[[[event touchesForView:stepper]anyObject] locationInView:self.tableView]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:stepper.tag inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    //NSInteger count = [cell.detailTextLabel.text integerValue];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d     :",(int)stepper.value];
    cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    DessertInfo *mInfo;
    
    for (DessertInfo *info in self.infoList) {
        if ([info.dessert.name isEqualToString:cell.textLabel.text]) {
            mInfo = info;
        }
    }
    
    if (mInfo == nil) {
        mInfo = [NSEntityDescription insertNewObjectForEntityForName:@"DessertInfo"
                                              inManagedObjectContext:self.managedObjectContext];
        [self.user addInfosObject:mInfo];
        mInfo.date = self.date;
        mInfo.count = 0;
        mInfo.dessert = [self.dessertList objectAtIndex:indexPath.row];
        [self.infoList addObject:mInfo];
    }
      
    mInfo.count = [NSNumber numberWithInt:(int)stepper.value];
    
    self.total = [mInfo.dessert.price floatValue] * [mInfo.count integerValue];
    
    [self.totalButton setTitle:[NSString stringWithFormat:@"T : %.02f",self.total]];
    
    [self.balanceButton setTitle:[NSString stringWithFormat:@"B : %.02f",self.paid - self.total]];
    
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
}

- (NSArray *)getAllDesserts
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Dessert"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    return fetchedRecords;
}

- (void)deleteDessert:(Dessert *)dessert
{
    [self.managedObjectContext deleteObject:dessert];
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self deleteDessert:[self.dessertList objectAtIndex:indexPath.row]];
        self.dessertList = [self getAllDesserts];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
