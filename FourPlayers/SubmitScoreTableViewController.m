//
//  SubmitScoreTableViewController.m
//  FourPlayers
//
//  Created by victor lantigua on 5/23/14.
//  Copyright (c) 2014 victor lantigua. All rights reserved.
//

#import "SubmitScoreTableViewController.h"
#import "GameUtility.h"
#import "API.h"
#import "MainViewController.h"

@interface SubmitScoreTableViewController ()

@end

UIButton *btnOK = nil;

@implementation SubmitScoreTableViewController
{
    IBOutlet UITextField *txtName;
    IBOutlet UITextField *txtCountry;
    IBOutlet UIImageView *imgCountry;
    IBOutlet UILabel *lblScore;
    
    UIPickerView *countryPickerView;
    UIAlertView *alertView;
    
    NSMutableArray *countryPickerData;
    NSCharacterSet *charactersToBlock;
}

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self loadPlayerData];

    alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                    message:@"Please enter your name"
                                    delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
    
    NSMutableCharacterSet *allowedCharacters = [NSMutableCharacterSet alphanumericCharacterSet];
    [allowedCharacters addCharactersInString:@"_- "];
    charactersToBlock = [allowedCharacters invertedSet];
    
    countryPickerData = [NSMutableArray arrayWithArray:[GameUtility getTeams]];
    [countryPickerData insertObject:@"dom" atIndex:1];
    [countryPickerData insertObject:@"cub" atIndex:2];
    [countryPickerData insertObject:@"can" atIndex:3];

    countryPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 43, 320, 200)];
    countryPickerView.delegate = self;
    countryPickerView.dataSource = self;
    [countryPickerView setShowsSelectionIndicator:YES];
    
    txtCountry.inputView = countryPickerView;

    txtName.delegate = self;
    
    lblScore.text = [NSString stringWithFormat:@"%07d", self.score];
    if (self.score > 0)
    {
        lblScore.text = [@"+" stringByAppendingString:lblScore.text];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return countryPickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return countryPickerData[row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    txtCountry.text = [[countryPickerData objectAtIndex:row] uppercaseString];
    [imgCountry setImage:[UIImage imageNamed:[countryPickerData objectAtIndex:row]]];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIImage *img = [UIImage imageNamed:[countryPickerData objectAtIndex:row]];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.frame = CGRectMake(-70, 10, 60, 40);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, -5, 80, 60)];
    label.font = [UIFont systemFontOfSize:26];
    label.text = [[countryPickerData objectAtIndex:row] uppercaseString];
    label.backgroundColor = [UIColor clearColor];
    
    UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 60)];
    [newView insertSubview:imgView atIndex:0];
    [newView insertSubview:label atIndex:1];
    
    return newView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == txtName)
    {
        [textField resignFirstResponder];
        [txtCountry becomeFirstResponder];
    }
    return YES;
}

-(IBAction)btnCancel:(id)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(IBAction)btnOK:(id)sender
{
    if (btnOK == nil)
    {
        btnOK = (UIButton *)sender;
    }
    
    if (txtName.text.length == 0)
    {
        [alertView setTitle:@"Oops!"];
        [alertView setMessage:@"Please enter your name."];
        [alertView show];
    }
    else
    {
        [btnOK setEnabled:NO];
        [self savePlayerData];
        [self submitScore];
    }
}

-(void)submitScore
{
    [API submitScore:self.score playerName:txtName.text country:txtCountry.text callback:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ( ! error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:true completion:^() {
                    [alertView setTitle:@"Thanks"];
                    [alertView setMessage:@"Your score was submitted."];
                    [alertView show];
                }];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [alertView setTitle:@"Oops!"];
                [alertView setMessage:@"An error occurred, please try again."];
                [alertView show];
                [btnOK setEnabled:YES];
            });
    
        }
    }];
}

-(void)savePlayerData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:txtName.text forKey:@"player_name"];
    [defaults setObject:[txtCountry.text lowercaseString] forKey:@"player_country"];
    [defaults synchronize];
}

-(void)loadPlayerData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *country = [defaults objectForKey:@"player_country"];
    if (country == nil)
    {
        country = @"usa";
    }
    
    txtCountry.text = [country uppercaseString];
    txtName.text = [defaults objectForKey:@"player_name"];
    [imgCountry setImage:[UIImage imageNamed:country]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)characters
{
    return ([characters rangeOfCharacterFromSet:charactersToBlock].location == NSNotFound);
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
    return 3;
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
