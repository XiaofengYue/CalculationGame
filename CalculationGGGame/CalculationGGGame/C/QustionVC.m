//
//  QustionVC.m
//  CalculationGGGame
//
//  Created by YXF on 2018/7/5.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "QustionVC.h"
#import "DetailVC.h"

@interface QustionVC ()

@end

@implementation QustionVC{
    int index;
    int second;
    int tempSecond;
    int totalScore;
    NSTimer *timer;
    NSMutableArray *your;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self loadQuestion];
}

- (void)initView{
    _backView.layer.cornerRadius = _time.frame.size.width/2;
    _backView.backgroundColor = [UIColor greenColor];
    _QustionLabel.layer.cornerRadius = 6;
    _QustionLabel.clipsToBounds = YES;
    _score.textColor = [UIColor redColor];
    [_detail addTarget:self action:@selector(clickDetail) forControlEvents:UIControlEventTouchUpInside];
    your = [NSMutableArray array];
}

/**
 加载题目
 */
- (void)loadQuestion{
    index = 0;
    second = 20;
    totalScore = 0;
    [self begin];
}

/**
 一道题开始计时
 */
- (void)begin{
    [_QustionLabel setText:_questionArr[index++]];
    [_AnswerLabel setText:_answerArr[index-1]];
    [_score setText:[NSString stringWithFormat:@"%d",totalScore]];
    [_time setText:[NSString stringWithFormat:@"%d",second]];
    tempSecond = second;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeGo) userInfo:nil repeats:YES];
}

/**
 时间流逝
 */
- (void)timeGo{
    [_time setText:[NSString stringWithFormat:@"%d",tempSecond--]];
    if(tempSecond < -1 && index < _questionArr.count){
        [timer invalidate];
        [self begin];
    }else if(index >= _questionArr.count){
        [timer invalidate];
        [self end];
    }
        
}

/**
 游戏结束
 */
- (void)end{
    _scroView.hidden = NO;
    _endScore.text = [NSString stringWithFormat:@"总得分:%d",totalScore];
    [self.view endEditing:YES];
}

#pragma mark ******点击事件******

/**
 点击确认

 @param sender 按钮
 */
- (IBAction)clickOK:(id)sender {
    [your addObject:_AnswerLabel.text];
    if(index < _questionArr.count){
        [timer invalidate];
        if([_AnswerLabel.text isEqualToString:_answerArr[index-1]]){
            totalScore++;
        }
        [self begin];
    }else if(index == _questionArr.count){
        [timer invalidate];
        if([_AnswerLabel.text isEqualToString:_answerArr[index-1]]){
            totalScore++;
        }
        [self end];
    }
    
}

/**
 返回主界面

 @param sender 按钮
 */
- (IBAction)clickBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 点击空白

 @param touches -
 @param event -
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
/**
 返回主界面

 @param sender -
 */
- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickDetail{
    DetailVC *vc = [DetailVC new];
    vc.answer = _answerArr;
    vc.question = _questionArr;
    vc.your = your;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
