//
//  HighScoresTableViewCell.h
//  FourPlayers
//
//  Created by victor lantigua on 5/23/14.
//  Copyright (c) 2014 victor lantigua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HighScoresTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblRank;
@property (weak, nonatomic) IBOutlet UIImageView *imgFlag;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblScore;
@end
