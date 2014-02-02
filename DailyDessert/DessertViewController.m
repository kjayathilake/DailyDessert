//
//  DessertViewController.m
//  DailyDessert
//
//  Created by Krishantha Jayathilake on 2014/01/15.
//  Copyright (c) 2014 TechOne. All rights reserved.
//

#import "DessertViewController.h"
#import "AppDelegate.h"

@interface DessertViewController ()<UITextFieldDelegate>

@property (nonatomic) UIBarButtonItem *btnSave;
@property (nonatomic) UIBarButtonItem *btnCancel;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) BOOL edit;

@end

@implementation DessertViewController

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
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.btnSave = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savebuttonClicked)];
    self.navigationItem.rightBarButtonItem = self.btnSave;
    
    self.btnCancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelbuttonClicked)];
    self.navigationItem.leftBarButtonItem = self.btnCancel;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        
    if (self.dessert == nil) {
        self.navigationItem.title = @"ADD DESSERT";
        self.edit = NO;
        self.dessert = [NSEntityDescription insertNewObjectForEntityForName:@"Dessert"
                                                     inManagedObjectContext:self.managedObjectContext];
    }
    else
    {
        self.navigationItem.title = @"EDIT DESSERT";
        self.edit = YES;
    }
    
}

- (void)savebuttonClicked
{
    [self saveDessert];
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
    return @"DESSERT DETAILS";
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
                textField.text = self.dessert.name;
            }
        }
        else {
            textField.placeholder = @"price in Rs.";
            textField.keyboardType = UIKeyboardTypeDecimalPad;
            textField.returnKeyType = UIReturnKeyDone;
            if (self.edit) {
                textField.text = [NSString stringWithFormat:@"%@",self.dessert.price];
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
            cell.textLabel.text = @"Price";
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
        self.dessert.name = textField.text;
    }
    else if (textField.tag == 1) {
        self.dessert.price = [NSNumber numberWithInt:[textField.text integerValue]];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyDone) {
        [self saveDessert];
    }
}

- (void)saveDessert
{
    if ([[self.dessert name] isEqualToString:@""]) {
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
