//
//  SubmitScoreTableViewController.h
//  FourPlayers
//
//  Created by victor lantigua on 5/23/14.
//  Copyright (c) 2014 victor lantigua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitScoreTableViewController : UITableViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
/*{
    IBOutlet UITextField *txtName;
    IBOutlet UITextField *txtCountry;
    IBOutlet UIImageView *imgCountry;
    IBOutlet UILabel *lblScore;
    
    UIPickerView *countryPickerView;
    UIAlertView *alertView;
    
    NSMutableArray *countryPickerData;
    NSCharacterSet *charactersToBlock;
}*/

@property(nonatomic) int score;
/*
-(IBAction)btnCancel:(id)sender;
-(IBAction)btnOK:(id)sender;
-(BOOL)textFieldShouldReturn:(UITextField *)textField;
*/
@end
