//
//  ViewController.m
//  FourPlayers
//
//  Created by victor lantigua on 5/22/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "MainViewController.h"
#import "SubmitScoreTableViewController.h"
#import "API.h"

@interface MainViewController ()

@end

@implementation MainViewController
{
    IBOutlet UITableView *highScoresTableView;
    IBOutlet UIActivityIndicatorView *activityIndicatorView;
    
    NSMutableArray *highScoresTableViewData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    highScoresTableViewData = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [highScoresTableViewData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

-(void) loadHighScores
{
    //[highScoresTableView setHidden:YES];
    [activityIndicatorView setHidden:NO];
    [activityIndicatorView startAnimating];

    [API getScoresWithCallback:
        ^(NSData *data, NSURLResponse *response, NSError *error)
        {
            if ( ! error)
            {
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSDictionary *resultData = [result objectForKey:@"data"];
    
                [highScoresTableViewData removeAllObjects];
                for (NSDictionary *row in resultData)
                {
                    [highScoresTableViewData addObject:row];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [activityIndicatorView setHidden:YES];
                    [activityIndicatorView stopAnimating];
                    [highScoresTableView reloadData];
                    [highScoresTableView setHidden:NO];
                });
            }
        }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"highScoresTableViewCell";

    NSDictionary *data = [highScoresTableViewData objectAtIndex:indexPath.row];
    
    HighScoresTableViewCell *cell = (HighScoresTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    cell.lblRank.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
    cell.lblName.text = [data objectForKey:@"name"];
    cell.lblScore.text = [data objectForKey:@"score"];
    
    UIImage *imgFlag = [UIImage imageNamed:[data objectForKey:@"country"]];
    [cell.imgFlag setImage:imgFlag];

    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self loadHighScores];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
@end
