//
//  QustionVC.h
//  CalculationGGGame
//
//  Created by YXF on 2018/7/5.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QustionVC : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *QustionLabel;
@property (strong, nonatomic) IBOutlet UITextField *AnswerLabel;
@property (strong, nonatomic) IBOutlet UILabel *quesitonTip;
@property (strong, nonatomic) IBOutlet UILabel *answerTip;

@property (nonatomic,strong)NSMutableArray *questionArr;
@property (nonatomic,strong)NSMutableArray *answerArr;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *score;
@property (strong, nonatomic) IBOutlet UILabel *endScore;
@property (strong, nonatomic) IBOutlet UIView *scroView;
@property (strong, nonatomic) IBOutlet UIButton *detail;


@end
