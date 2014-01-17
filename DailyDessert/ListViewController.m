//
//  ListViewController.m
//  DailyDessert
//
//  Created by Krishantha Jayathilake on 2014/01/14.
//  Copyright (c) 2014 TechOne. All rights reserved.
//

#import "ListViewController.h"
#import "UserViewController.h"
#import "DessertListViewController.h"
#import "SummaryViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "DessertInfo.h"
#import "Dessert.h"

@interface ListViewController ()

@property (nonatomic) UIBarButtonItem *btnAdd;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSArray *userList;
@property (nonatomic) UIToolbar *toolbar;
@property (nonatomic) UIView *fakeFooterView;
@property (nonatomic) UIBarButtonItem *totalButton;
@property (nonatomic) UIBarButtonItem *summaryButton;
@property (nonatomic) CGFloat total;


@end

@implementation ListViewController

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
    
    self.navigationItem.title = @"USER";
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.btnAdd = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClicked)];
    self.navigationItem.rightBarButtonItem = self.btnAdd;
    
    self.totalButton = [[UIBarButtonItem alloc]initWithTitle:@"Total : " style:UIBarButtonItemStyleDone target:self action:nil];
    self.summaryButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(summaryButtonClicked)];

    self.toolbar = (UIToolbar *)[self.navigationController.view viewWithTag:101];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    self.userList = [self getAllUsers];
    [self.tableView reloadData];
    
    self.total = 0;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    for (User *user in self.userList) {
        for (DessertInfo *info in user.infos) {
            if ([[dateFormat stringFromDate:info.date] isEqualToString:[dateFormat stringFromDate:self.date]]) {
                
                self.total += ([info.count integerValue] * [info.dessert.price floatValue]);
            }
        }
    }    
    
    [self.totalButton setTitle:[NSString stringWithFormat:@"Total : %f",self.total]];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self.toolbar setItems:[NSArray arrayWithObjects:self.summaryButton, flexibleSpace, self.totalButton, nil]];
}

- (void) addButtonClicked
{
    UserViewController *vc = [[UserViewController alloc]initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navcont = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navcont animated:YES completion:nil];
}

- (void)summaryButtonClicked
{
    SummaryViewController *vc = [[SummaryViewController alloc]initWithStyle:UITableViewStyleGrouped];
    vc.date = self.date;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    DessertListViewController *vc = [[DessertListViewController alloc]initWithStyle:UITableViewStyleGrouped];
    vc.date = self.date;
    vc.user = [self.userList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    // Convert date object to desired output format
    //[dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
    
    return [dateFormat stringFromDate:self.date];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.userList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.detailTextLabel.text = @"0";
    cell.textLabel.text = [(User *)[self.userList objectAtIndex:indexPath.row] name];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    int count = 0;
    
    for (DessertInfo *info in [(User *)[self.userList objectAtIndex:indexPath.row] infos]) {
        if ([[dateFormat stringFromDate:info.date] isEqualToString:[dateFormat stringFromDate:self.date]]) {
            
            count += [info.count integerValue];
        }
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",count];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	if(section == 0)
	{
		return 60.0f;
	}
	else {
		return 10.0f;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	if(section == 0)
	{
		return self.fakeFooterView;
	}
	else {
		return nil;
	}
}

- (void)deleteUser:(User *)user
{
    [self.managedObjectContext deleteObject:user];
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (NSArray *)getAllUsers
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    return fetchedRecords;
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
        [self deleteUser:[self.userList objectAtIndex:indexPath.row]];
        self.userList = [self getAllUsers];
        
        
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
