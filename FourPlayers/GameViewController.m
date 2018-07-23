//
//  GameViewController.m
//  FourPlayers
//
//  Created by victor lantigua on 5/22/14.
//  Copyright (c) 2014 victor lantigua. All rights reserved.
//

#import "GameViewController.h"
#import "GameUtility.h"
#import "SubmitScoreTableViewController.h"
#import "UIView+Toast.h"

@interface GameViewController ()

@end

@implementation GameViewController
{
    int score;
    NSArray *levels;
    NSArray *bonusLevels;
    BOOL bonusAchieved;
    
    int currentLevelNumber;
    int currentLevelNumberOfTries;
    int currentLevelRevealedCount;
    NSString *currentLevelTeam;
    NSArray *currentLevelPossibleTeams;
    NSArray *currentLevelPlayers;
    
    NSDate *timeLevelStarted;
    
    IBOutlet UILabel *lblScore;
    IBOutlet UILabel *lblTeam1;
    IBOutlet UILabel *lblTeam2;
    IBOutlet UILabel *lblTeam3;
    IBOutlet UILabel *lblTeam4;
    IBOutlet UILabel *lblTeam5;
    IBOutlet UILabel *lblTeam6;
    IBOutlet UILabel *lblTeam7;
    IBOutlet UILabel *lblTeam8;
    
    IBOutlet UIButton *btnPlayer1;
    IBOutlet UIButton *btnPlayer2;
    IBOutlet UIButton *btnPlayer3;
    IBOutlet UIButton *btnPlayer4;
    
    IBOutlet UIButton *btnTeam1;
    IBOutlet UIButton *btnTeam2;
    IBOutlet UIButton *btnTeam3;
    IBOutlet UIButton *btnTeam4;
    IBOutlet UIButton *btnTeam5;
    IBOutlet UIButton *btnTeam6;
    IBOutlet UIButton *btnTeam7;
    IBOutlet UIButton *btnTeam8;
}

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
    // Do any additional setup after loading the view.
    [self startGame];
}

-(IBAction)btnPlayer2:(id)sender
{
    if (currentLevelRevealedCount == 1)
    {
        currentLevelRevealedCount = 2;
        
        UIImage *img = [UIImage imageNamed:[currentLevelPlayers objectAtIndex:1]];
        [btnPlayer2 setImage:img forState:UIControlStateNormal];
        
        img = [UIImage imageNamed:@"avatar"];
        [btnPlayer3 setImage:img forState:UIControlStateNormal];
    }
}

-(IBAction)btnPlayer3:(id)sender
{
    if (currentLevelRevealedCount == 2)
    {
        currentLevelRevealedCount = 3;
        
        UIImage *img = [UIImage imageNamed:[currentLevelPlayers objectAtIndex:2]];
        [btnPlayer3 setImage:img forState:UIControlStateNormal];
        
        img = [UIImage imageNamed:@"avatar"];
        [btnPlayer4 setImage:img forState:UIControlStateNormal];
    }
}

-(IBAction)btnPlayer4:(id)sender
{
    if (currentLevelRevealedCount == 3)
    {
        currentLevelRevealedCount = 4;
        UIImage *img = [UIImage imageNamed:[currentLevelPlayers objectAtIndex:3]];
        [btnPlayer4 setImage:img forState:UIControlStateNormal];
    }
}

-(IBAction)btnTeam:(id)sender
{
    UIButton *clickedButton = (UIButton *)sender;
    
    NSString *clickedTeam = [[clickedButton.imageView image] accessibilityIdentifier];
    
    currentLevelNumberOfTries++;
    
    if ([clickedTeam isEqualToString:currentLevelTeam])
    {
        int pointsEarned = [self calculatePointsForCorrectAnswer];
        NSLog(@"Score: %d", score);
        NSLog(@"Points Earned: %d", pointsEarned);
        [self updateScore:pointsEarned];
        [self nextLevel];
        NSLog(@"New Score: %d", score);
        
        NSString *toastMessage = [NSString stringWithFormat:@"+%d", pointsEarned];
        
        if (bonusAchieved == YES)
        {
            bonusAchieved = NO;
            toastMessage = [toastMessage stringByAppendingString:@" BONUS"];
        }
        
        [self showToastWithMessage:toastMessage];
    }
    else
    {
        switch (currentLevelNumberOfTries)
        {
            case 1:
                [self showToastWithMessage:@"sorry, try again"];
                break;
            case 2:
                [self showToastWithMessage:@"last chance"];
                break;
            default:
                NSLog(@"Score: %d", score);
                NSLog(@"Points Earned: %d", -300);
                [self showToastWithMessage:@"-300"];
                [self updateScore:-300];
                [self nextLevel];
                NSLog(@"New Score: %d", score);
                break;
        }
    }
}

-(void)showToastWithMessage:(NSString *)message
{
    [self.view makeCustomToast:message
                      duration:.6
                         image:nil
                      position:[NSValue valueWithCGPoint:CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2)]];
}

-(void)startGame
{
    currentLevelNumber = 1;
    score = 0;
    levels = [GameUtility getShuffledTeams];
    bonusLevels = [[GameUtility getShuffledTeams] subarrayWithRange:NSMakeRange(0, 8)];
    [lblScore setText:@"0000000"];
    [self initLevelWithNumber:1];
}

-(void)endGame
{
    SubmitScoreTableViewController *submitScoreViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"submitScoreTableViewController"];
    submitScoreViewController.score = score;
    
    [self presentViewController:submitScoreViewController animated:YES
                     completion:^(){
                         [self.navigationController popViewControllerAnimated:NO];
                     }];
}

-(void)updateScore:(int)newPoints
{
    score += newPoints;
    
    lblScore.text = [NSString stringWithFormat:@"%07d", score];
    if (score > 0)
    {
        lblScore.text = [@"+" stringByAppendingString:lblScore.text];
    }
}

-(void)nextLevel
{
    if (currentLevelNumber < 32)
    {
        [self initLevelWithNumber:currentLevelNumber+1];
    }
    else
    {
        [self endGame];
    }
}

-(int)calculatePointsForCorrectAnswer
{
    int points = 0;
	//  = (n levels * max points per level) + (n bonus levels * bonus points)
	//  = (32*1000)+(8*3000) = 120000
    // Calculate base points
    switch (currentLevelRevealedCount) {
        case 1:
            points = 1000;
            break;
        case 2:
            points = 800;
            break;
        case 3:
            points = 600;
            break;
        default:
            points = 400;
            break;
    }
    
	// Calculate bonus points
    if ([bonusLevels containsObject:currentLevelTeam])
    {
        points += 3000;
        bonusAchieved = YES;
    }
    
    // Calculate time points. The less time spent the more points.
    NSTimeInterval timeSpent = [[NSDate date] timeIntervalSinceDate:timeLevelStarted]; // Time in seconds
    int timePoints = (100/timeSpent);
    NSLog(@"Level Time Spent: %f", timeSpent);
    NSLog(@"Level Time Points: %d", points);
    
    if (currentLevelNumberOfTries == 1)
    {
        timePoints *= (points/2);
        //points += 2000;
    }
    else if (currentLevelNumberOfTries == 2)
    {
        timePoints *= (points/4);
    }
    else
    {
        timePoints *= (points/5);
    }
    
    points += timePoints;
    
    return points;
}

-(void)initLevelWithNumber:(int)levelNumber
{
    self.title = [NSString stringWithFormat:@"LEVEL %d of 32", levelNumber];
    
    currentLevelNumber = levelNumber;
    currentLevelTeam = [levels objectAtIndex:levelNumber-1];
    currentLevelPlayers = [GameUtility getPlayersForTeam:currentLevelTeam];
    currentLevelRevealedCount = 1;
    currentLevelNumberOfTries = 0;
    
    NSLog(@"Current Level: %@", currentLevelTeam);
    
    // Initialize player images
    
    UIImage *img = [UIImage imageNamed:[currentLevelPlayers objectAtIndex:0]];
    [btnPlayer1 setImage:img forState:UIControlStateNormal];
    
    img = [UIImage imageNamed:@"avatar"];
    [btnPlayer2 setImage:img forState:UIControlStateNormal];
    
    img = [UIImage imageNamed:@"blank"];
    [btnPlayer3 setImage:img forState:UIControlStateNormal];
    [btnPlayer4 setImage:img forState:UIControlStateNormal];
    
    // Initialize flag buttons
    
    NSMutableArray *possibleTeams = [NSMutableArray arrayWithArray:[GameUtility getShuffledTeams]];
    [possibleTeams removeObject:currentLevelTeam]; // Remove answer
    NSUInteger answerIndex = arc4random_uniform(8); // Random int between 0 and N - 1
    // Insert answer back in at random spot
    [possibleTeams insertObject:currentLevelTeam atIndex:answerIndex];
    currentLevelPossibleTeams = [possibleTeams subarrayWithRange:NSMakeRange(0, 8)];
    
    [self initTeamButton:btnTeam1 withLabel:lblTeam1 withTeamName:[currentLevelPossibleTeams objectAtIndex:0]];
    [self initTeamButton:btnTeam2 withLabel:lblTeam2 withTeamName:[currentLevelPossibleTeams objectAtIndex:1]];
    [self initTeamButton:btnTeam3 withLabel:lblTeam3 withTeamName:[currentLevelPossibleTeams objectAtIndex:2]];
    [self initTeamButton:btnTeam4 withLabel:lblTeam4 withTeamName:[currentLevelPossibleTeams objectAtIndex:3]];
    [self initTeamButton:btnTeam5 withLabel:lblTeam5 withTeamName:[currentLevelPossibleTeams objectAtIndex:4]];
    [self initTeamButton:btnTeam6 withLabel:lblTeam6 withTeamName:[currentLevelPossibleTeams objectAtIndex:5]];
    [self initTeamButton:btnTeam7 withLabel:lblTeam7 withTeamName:[currentLevelPossibleTeams objectAtIndex:6]];
    [self initTeamButton:btnTeam8 withLabel:lblTeam8 withTeamName:[currentLevelPossibleTeams objectAtIndex:7]];
    
    timeLevelStarted = [NSDate date];
    NSLog(@"Level Time Started: %@", timeLevelStarted);
}

-(void)initTeamButton:(UIButton *)button withLabel:(UILabel *)label withTeamName:(NSString *)teamName
{
    UIImage *img = [UIImage imageNamed:teamName];
    [img setAccessibilityIdentifier:teamName];
    [button setImage:img forState:UIControlStateNormal];
    [label setText:[teamName uppercaseString]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
