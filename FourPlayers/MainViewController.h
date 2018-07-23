//
//  ViewController.h
//  FourPlayers
//
//  Created by victor lantigua on 5/22/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighScoresTableViewCell.h"

@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
-(void) loadHighScores;
@end
