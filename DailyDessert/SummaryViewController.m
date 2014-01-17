//
//  SummaryViewController.m
//  DailyDessert
//
//  Created by Krishantha Jayathilake on 2014/01/15.
//  Copyright (c) 2014 TechOne. All rights reserved.
//

#import "SummaryViewController.h"
#import "AppDelegate.h"
#import "DessertInfo.h"
#import "User.h"
#import "Dessert.h"

@interface SummaryViewController ()

@property (nonatomic) UIBarButtonItem *btnDone;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSArray *dessertList;
@property (nonatomic) NSMutableArray *infoList;
@property (nonatomic) DessertInfo *info;
@property (nonatomic) CGFloat total;
@property (nonatomic) NSArray *userList;

@end

@implementation SummaryViewController

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
    
    self.navigationItem.title = @"SUMMARY";
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.btnDone = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donebuttonClicked)];
    self.navigationItem.rightBarButtonItem = self.btnDone;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)donebuttonClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.userList = [self getAllUsers];
    
    self.infoList = [[NSMutableArray alloc]init];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    // Convert date object to desired output format
    //[dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
    
    for (User *user in self.userList) {
        for (DessertInfo *info in user.infos) {
            if ([[dateFormat stringFromDate:info.date] isEqualToString:[dateFormat stringFromDate:self.date]]) {
                [self.infoList addObject:info];
                
            }
        }
    }
    
    self.dessertList = [self getAllDesserts];
    [self.tableView reloadData];
    
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.dessertList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    cell.textLabel.text = [(Dessert *)[self.dessertList objectAtIndex:indexPath.row] name];
    NSInteger count = 0;
    for (DessertInfo *info in self.infoList) {
        if ([info.dessert.name isEqualToString:cell.textLabel.text]) {
            count += [info.count integerValue];
        }
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",count];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
