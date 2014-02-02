//
//  UserViewController.m
//  DailyDessert
//
//  Created by Krishantha Jayathilake on 2014/01/14.
//  Copyright (c) 2014 TechOne. All rights reserved.
//

#import "UserViewController.h"
#import "AppDelegate.h"

@interface UserViewController ()<UITextFieldDelegate>


@property (nonatomic) UIBarButtonItem *btnSave;
@property (nonatomic) UIBarButtonItem *btnCancel;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) BOOL edit;


@end

@implementation UserViewController

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
    
    
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.btnSave = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savebuttonClicked)];
    self.navigationItem.rightBarButtonItem = self.btnSave;
    
    self.btnCancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelbuttonClicked)];
    self.navigationItem.leftBarButtonItem = self.btnCancel;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    if (self.user == nil) {
        self.navigationItem.title = @"ADD USER";
        self.edit = NO;
        self.user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                  inManagedObjectContext:self.managedObjectContext];
    }
    else
    {
        self.navigationItem.title = @"EDIT USER";
        self.edit = YES;
    }
}

- (void)savebuttonClicked
{
    [self saveUser];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelbuttonClicked
{
    [self.managedObjectContext rollback];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"USER DETAILS";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    [cell setSelected:YES];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ([indexPath section] == 0) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 150, 30)];
       // textField.adjustsFontSizeToFitWidth = YES;
        
        if ([indexPath row] == 0) {
            textField.placeholder = @"required";
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.returnKeyType = UIReturnKeyNext;
            if (self.edit) {
                textField.text = self.user.name;
            }
        }
        else {
            textField.placeholder = @"abc@gmail.com";
            textField.keyboardType = UIKeyboardTypeEmailAddress;
            textField.returnKeyType = UIReturnKeyDone;
            if (self.edit) {
                textField.text = self.user.email;
            }
        }
        textField.backgroundColor = [UIColor whiteColor];
        textField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
        //textField.textAlignment = UITextAlignmentLeft;
        textField.tag = indexPath.row;
        textField.delegate = self;
        
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        textField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
        [textField setEnabled: YES];
        textField.textColor = [UIColor blackColor];
        //[cell.contentView addSubview:textField];
        cell.accessoryView = textField;
        
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Name";
            break;
            
        case 1:
            cell.textLabel.text = @"E-Mail";
            break;
            
        default:
            break;
    }

    return cell;
}

- (void)textFieldDidChange:(id)sender
{
    UITextField *textField = (UITextField *)sender;
    
    if (textField.tag == 0) {
        self.user.name = textField.text;
    }
    else if (textField.tag == 1) {
        self.user.email = textField.text;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyDone) {
        //[self saveUser];
    }
}

- (void)saveUser
{
    
    if ([[self.user name] isEqualToString:@""]) {
        NSLog(@"Name is required");
    }
    else
    {
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }    
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
