//
//  ViewController.m
//  CalculationGGGame
//
//  Created by YXF on 2018/7/5.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ViewController.h"
#import "QustionVC.h"
#import <BRPickerView.h>
#import <KxMenu.h>
#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
@interface ViewController ()

@end

@implementation ViewController{
    NSMutableArray *questionArr;
    NSMutableArray *answerArr;
    NSMutableArray *language;
    NSMutableArray *levelArr;
    NSString *questionTotalStr;
    NSString *answerTotalStr;
    int flag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_levelChoose setUserInteractionEnabled: YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickchoose)];
    [_levelChoose addGestureRecognizer:tap];
    [self setLang];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setLang{
    _LanguageLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clicklang)];
    [_LanguageLabel addGestureRecognizer:tap];
}

#pragma mark ******核心功能******

/**
 创建全部问题和答案
 */
- (void)creatQuestionList{
    
    srand((unsigned)time(0));
    
    questionArr = [NSMutableArray array];
    answerArr = [NSMutableArray array];
    language = [NSMutableArray array];
    levelArr = [NSMutableArray array];
    [language addObject:@"中文"];
    [language addObject:@"英文"];
    [levelArr addObject:@"10"];
    [levelArr addObject:@"100"];
    [levelArr addObject:@"1000"];
    [levelArr addObject:@"10000"];
    
    int totalNum = [_levelChoose.text intValue];
    while (totalNum--) {
        [self creatQustion];
    }
    
}

/**
 创建一个问题
 */
- (void)creatQustion{
    
    //没有重复的题，答案不一致即可
    //生成几个框
    int calculationNumberOfOneToOne = rand()%3+1;
    char symbol[10];
    NSString *resultStr[10];
    NSString *questionStr[10];
    //运算式子创建
    for (int i = 0 ; i < calculationNumberOfOneToOne ; i ++ ) {
        int num1 = rand()%9+1;
        int num2 = rand()%9+1;
        int tag = rand()%4;
        questionStr[i] = [NSString stringWithFormat:@"(%d %c %d)",num1,[self getCalculationWay:tag],num2];
        symbol[i] = [self getCalculationWay:i%3+1];
        resultStr[i] = [self getCalculationResultWithString:tag number1:[NSString stringWithFormat:@"%d",num1] number2:[NSString stringWithFormat:@"%d",num2]];
        
        if(i!=0){
            int ttag = [self getInt:symbol[i-1]];
            resultStr[i] = [self getCalculationResultWithString:ttag number1:resultStr[i-1] number2:resultStr[i]];
        }
    }
    [answerArr addObject:[self GCD:resultStr[calculationNumberOfOneToOne-1]]];
    
    symbol[calculationNumberOfOneToOne-1] = '=';
    
    //处理
    questionTotalStr = @"";
    answerTotalStr = @"";
    int proi1 = 0 ,proi2 = 0,prioMid = 0;
    for (int i = 0 ; i < calculationNumberOfOneToOne ; i ++ ) {
        if(i == 0){
            questionTotalStr = questionStr[i];
            //前面的优先级
            proi1 = [self getPrio:[questionStr[i]characterAtIndex:3]];
            //符号的优先级
            prioMid = [self getPrio:symbol[i]];
            //如果符号优先级小于前面的
            if(prioMid <= proi1){
                //去掉括号
                questionTotalStr = [questionTotalStr substringFromIndex:1];
                questionTotalStr = [questionTotalStr substringToIndex:questionTotalStr.length-1];
            }
            proi1 = prioMid;
            
        }else{
            //后面式子的优先级
            proi2 = [self getPrio:[questionStr[i]characterAtIndex:3]];
            //与前面符号比较
            if(proi2 >= proi1){
                questionStr[i] = [questionStr[i] substringFromIndex:1];
                questionStr[i] = [questionStr[i] substringToIndex:questionStr[i].length-1];
            }
            //添加前面的符号位
            questionTotalStr = [questionTotalStr stringByAppendingString:[NSString stringWithFormat:@" %c ",symbol[i-1]]];
            //添加后面的式子
            questionTotalStr = [questionTotalStr stringByAppendingString:questionStr[i]];
            //添加括号
            questionTotalStr = [NSString stringWithFormat:@"(%@)",questionTotalStr];
            //后面的符号位优先级
            prioMid = [self getPrio:symbol[i]];
            if(prioMid <= proi1){
                //去掉括号
                questionTotalStr = [questionTotalStr substringFromIndex:1];
                questionTotalStr = [questionTotalStr substringToIndex:questionTotalStr.length-1];
            }
            proi1 = prioMid;
        }
    }
    questionTotalStr = [questionTotalStr stringByAppendingString:@" = "];
    [questionArr addObject:questionTotalStr];
    
}

/**
 求最终化简答案

 @param str 答案
 @return 化简的答案
 */
- (NSString *)GCD:(NSString *)str{
    if([str containsString:@"/"]){
        NSInteger indexPath = [str rangeOfString:@"/"].location;
        NSString *numTop = [str substringToIndex:indexPath];
        NSString *numBot = [str substringFromIndex:indexPath+1];
        int gcdInt = [self gcdWithNum1:[numTop intValue] num2:[numBot intValue]];
        numTop = [NSString stringWithFormat:@"%d",[numTop intValue]/gcdInt];
        numBot = [NSString stringWithFormat:@"%d",[numBot intValue]/gcdInt];
        if([numBot isEqualToString:@"1"]){
            return numTop;
        }else{
            if([numTop containsString:@"-"] && [numBot containsString:@"-"]){
                return [NSString stringWithFormat:@"%@/%@",[numTop substringFromIndex:1],[numBot substringFromIndex:1]];
            }else if((![numTop containsString:@"-"]) && ([numBot containsString:@"-"])){
                return [NSString stringWithFormat:@"%@/%@",[NSString stringWithFormat:@"-%@",numTop],[numBot substringFromIndex:1]];
            }else {
                return [NSString stringWithFormat:@"%@/%@",numTop,numBot];
            }
            
        }
    }
    return str;
}
- (int)gcdWithNum1:(int)m num2:(int)n{
    if(n == 0){
        return m;
    }
    return [self gcdWithNum1:n num2:m%n];
}
/**
 根据符号获得优先级

 @param c 符号
 @return 优先级
 */
- (int)getPrio:(char)c{
    if(c == '+' || c == '-'){
        return 0;
    }else if(c == '='){
        return -1;
    }
    return 1;
}


/**
 获得结果

 @param tag 符号算法
 @param num1 第一个数
 @param num2 第二个数
 @return 结果
 */
- (NSString *)getCalculationResultWithString:(NSInteger)tag number1:(NSString *)num1 number2:(NSString *)num2{
    switch (tag) {
        case 0:
            if((![num1 containsString:@"/"])&&(![num2 containsString:@"/"])){
                return [NSString stringWithFormat:@"%@/%@",num1,num2];
            }else if(([num1 containsString:@"/"])&&(![num2 containsString:@"/"])){
                NSInteger indexPath = [num1 rangeOfString:@"/"].location;
                NSString *num1Top = [num1 substringToIndex:indexPath];
                NSString *num1Bot = [num1 substringFromIndex:indexPath+1];
                num1Bot = [NSString stringWithFormat:@"%d",[num1Bot intValue] * [num2 intValue]];
                return [NSString stringWithFormat:@"%@/%@",num1Top,num1Bot];
            }else if((![num1 containsString:@"/"])&&([num2 containsString:@"/"])){
                NSInteger indexPath = [num2 rangeOfString:@"/"].location;
                NSString *num2Top = [num2 substringToIndex:indexPath];
                NSString *num2Bot = [num2 substringFromIndex:indexPath+1];
                NSString *temp = num2Top;
                num2Top = [NSString stringWithFormat:@"%d",[num1 intValue]*[num2Bot intValue]];
                num2Bot = temp;
                return [NSString stringWithFormat:@"%@/%@",num2Top,num2Bot];
            }else if(([num1 containsString:@"/"])&&([num2 containsString:@"/"])){
                NSInteger num1indexPath = [num1 rangeOfString:@"/"].location;
                NSString *num1Top = [num1 substringToIndex:num1indexPath];
                NSString *num1Bot = [num1 substringFromIndex:num1indexPath+1];
                NSInteger indexPath = [num2 rangeOfString:@"/"].location;
                NSString *num2Top = [num2 substringToIndex:indexPath];
                NSString *num2Bot = [num2 substringFromIndex:indexPath+1];
                num1Top = [NSString stringWithFormat:@"%d",[num1Top intValue]*[num2Bot intValue]];
                num1Bot = [NSString stringWithFormat:@"%d",[num1Bot intValue]*[num2Top intValue]];
                return [NSString stringWithFormat:@"%@/%@",num1Top,num1Bot];
            }
        case 1:
            if((![num1 containsString:@"/"])&&(![num2 containsString:@"/"])){
                return [NSString stringWithFormat:@"%d",[num1 intValue]*[num2 intValue]];
            }else if(([num1 containsString:@"/"])&&(![num2 containsString:@"/"])){
                NSInteger indexPath = [num1 rangeOfString:@"/"].location;
                NSString *num1Top = [num1 substringToIndex:indexPath];
                NSString *num1Bot = [num1 substringFromIndex:indexPath+1];
                num1Top = [NSString stringWithFormat:@"%d",[num1Top intValue]*[num2 intValue]];
                return [NSString stringWithFormat:@"%@/%@",num1Top,num1Bot];
            }else if((![num1 containsString:@"/"])&&([num2 containsString:@"/"])){
                NSInteger indexPath = [num2 rangeOfString:@"/"].location;
                NSString *num2Top = [num2 substringToIndex:indexPath];
                NSString *num2Bot = [num2 substringFromIndex:indexPath+1];
                num2Top = [NSString stringWithFormat:@"%d",[num1 intValue]*[num2Top intValue]];
                return [NSString stringWithFormat:@"%@/%@",num2Top,num2Bot];
            }else if(([num1 containsString:@"/"])&&([num2 containsString:@"/"])){
                NSInteger num1indexPath = [num1 rangeOfString:@"/"].location;
                NSString *num1Top = [num1 substringToIndex:num1indexPath];
                NSString *num1Bot = [num1 substringFromIndex:num1indexPath+1];
                NSInteger indexPath = [num2 rangeOfString:@"/"].location;
                NSString *num2Top = [num2 substringToIndex:indexPath];
                NSString *num2Bot = [num2 substringFromIndex:indexPath+1];
                num1Top = [NSString stringWithFormat:@"%d",[num1Top intValue]*[num2Top intValue]];
                num1Bot = [NSString stringWithFormat:@"%d",[num1Bot intValue]*[num2Bot intValue]];
                return [NSString stringWithFormat:@"%@/%@",num1Top,num1Bot];
            }
        case 2:
            if((![num1 containsString:@"/"])&&(![num2 containsString:@"/"])){
                return [NSString stringWithFormat:@"%d",[num1 intValue]+[num2 intValue]];
            }else if(([num1 containsString:@"/"])&&(![num2 containsString:@"/"])){
                NSInteger indexPath = [num1 rangeOfString:@"/"].location;
                NSString *num1Top = [num1 substringToIndex:indexPath];
                NSString *num1Bot = [num1 substringFromIndex:indexPath+1];
                num1Top = [NSString stringWithFormat:@"%d",[num1Bot intValue]*[num2 intValue]+[num1Top intValue]];
                return [NSString stringWithFormat:@"%@/%@",num1Top,num1Bot];
            }else if((![num1 containsString:@"/"])&&([num2 containsString:@"/"])){
                NSInteger indexPath = [num2 rangeOfString:@"/"].location;
                NSString *num2Top = [num2 substringToIndex:indexPath];
                NSString *num2Bot = [num2 substringFromIndex:indexPath+1];
                num2Top = [NSString stringWithFormat:@"%d",[num1 intValue]*[num2Bot intValue]+[num2Top intValue]];
                return [NSString stringWithFormat:@"%@/%@",num2Top,num2Bot];
            }else if(([num1 containsString:@"/"])&&([num2 containsString:@"/"])){
                NSInteger num1indexPath = [num1 rangeOfString:@"/"].location;
                NSString *num1Top = [num1 substringToIndex:num1indexPath];
                NSString *num1Bot = [num1 substringFromIndex:num1indexPath+1];
                NSInteger indexPath = [num2 rangeOfString:@"/"].location;
                NSString *num2Top = [num2 substringToIndex:indexPath];
                NSString *num2Bot = [num2 substringFromIndex:indexPath+1];
                num1Top = [NSString stringWithFormat:@"%d",[num1Top intValue]*[num2Bot intValue] + [num2Top intValue]*[num1Bot intValue]];
                num1Bot = [NSString stringWithFormat:@"%d",[num1Bot intValue]*[num2Bot intValue]];
                return [NSString stringWithFormat:@"%@/%@",num1Top,num1Bot];
            }
        case 3:
            if((![num1 containsString:@"/"])&&(![num2 containsString:@"/"])){
                return [NSString stringWithFormat:@"%d",[num1 intValue]-[num2 intValue]];
            }else if(([num1 containsString:@"/"])&&(![num2 containsString:@"/"])){
                NSInteger indexPath = [num1 rangeOfString:@"/"].location;
                NSString *num1Top = [num1 substringToIndex:indexPath];
                NSString *num1Bot = [num1 substringFromIndex:indexPath+1];
                num1Top = [NSString stringWithFormat:@"%d",-1*([num1Bot intValue]*[num2 intValue])+[num1Top intValue]];
                return [NSString stringWithFormat:@"%@/%@",num1Top,num1Bot];
            }else if((![num1 containsString:@"/"])&&([num2 containsString:@"/"])){
                NSInteger indexPath = [num2 rangeOfString:@"/"].location;
                NSString *num2Top = [num2 substringToIndex:indexPath];
                NSString *num2Bot = [num2 substringFromIndex:indexPath+1];
                num2Top = [NSString stringWithFormat:@"%d",[num1 intValue]*[num2Bot intValue]-[num2Top intValue]];
                return [NSString stringWithFormat:@"%@/%@",num2Top,num2Bot];
            }else if(([num1 containsString:@"/"])&&([num2 containsString:@"/"])){
                NSInteger num1indexPath = [num1 rangeOfString:@"/"].location;
                NSString *num1Top = [num1 substringToIndex:num1indexPath];
                NSString *num1Bot = [num1 substringFromIndex:num1indexPath+1];
                NSInteger indexPath = [num2 rangeOfString:@"/"].location;
                NSString *num2Top = [num2 substringToIndex:indexPath];
                NSString *num2Bot = [num2 substringFromIndex:indexPath+1];
                num1Top = [NSString stringWithFormat:@"%d",[num1Top intValue]*[num2Bot intValue] - [num2Top intValue]*[num1Bot intValue]];
                num1Bot = [NSString stringWithFormat:@"%d",[num1Bot intValue]*[num2Bot intValue]];
                return [NSString stringWithFormat:@"%@/%@",num1Top,num1Bot];
            }
        default:
            break;
    }
    return @" ";
}

/**
 获得运算符

 @param tag 类型
 @return 运算符
 */
- (char)getCalculationWay:(int)tag{
    switch (tag) {
        case 0:
            return '/';
        case 1:
            return '*';
        case 2:
            return '+';
        case 3:
            return '-';
        default:
            break;
    }
    return ' ';
}

/**
 根据运算符获得tag

 @param c 运算符
 @return tag
 */
- (int)getInt:(char)c{
    switch (c) {
        case '/':
            return 0;
        case '*':
            return 1;
        case '+':
            return 2;
        case '-':
            return 3;
        default:
            break;
    }
    return ' ';
}

#pragma mark ******点击事件******

- (IBAction)clickStart:(id)sender {
    
    
    [self creatQuestionList];
    [self write];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    QustionVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"QuestionID"];
    vc.answerArr = answerArr;
    vc.questionArr = questionArr;
    [self presentViewController:vc animated:nil completion:nil];
    
    
}

- (void)clickchoose{
    NSArray *array = [NSArray arrayWithObjects:@"10",@"100",@"1000",@"10000", nil];
    [BRStringPickerView showStringPickerWithTitle:@"" dataSource:array defaultSelValue:_levelChoose.text resultBlock:^(id selectValue) {
        _levelChoose.text = selectValue;
    }];
}

- (void)write{
    for (int i = 0 ; i < questionArr.count ; i ++ ) {
        NSLog(@"Question: %@",questionArr[i]);
        NSLog(@"Answer:   %@",answerArr[i]);
    }
}
- (void)clicklang{
    NSArray *searchTypeItemArray=@[[KxMenuItem menuItem:@"中文"
                                                  image:nil
                                                 target:self
                                                 action:@selector(chooseChinese)],
                                   [KxMenuItem menuItem:@"英文"
                                                  image:nil
                                                 target:self
                                                 action:@selector(chooseEnglish)],
                                   [KxMenuItem menuItem:@"日文"
                                                  image:nil
                                                 target:self
                                                 action:@selector(chooseJapaness)],
                                   [KxMenuItem menuItem:@"法文"
                                                  image:nil
                                                 target:self
                                                 action:@selector(chooseFrench)]
                                   ];
    
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(_LanguageLabel.frame.origin.x,_LanguageLabel.frame.origin.y,44,44)
                 menuItems:searchTypeItemArray];
}

- (void)chooseChinese{
    _LanguageLabel.text = @"中文";
    _StartBtn.titleLabel.text = @"开始游戏";
    _level.text = @"级别";
    flag = 0;
}
- (void)chooseEnglish{
    _LanguageLabel.text = @"Language";
    _StartBtn.titleLabel.text = @"Start the game";
    _level.text = @"level";
    flag = 1;
}
- (void)chooseJapaness{
    _LanguageLabel.text = @"言語";
    _StartBtn.titleLabel.text = @"ゲームを開始する";
    _level.text = @"レベル";
    flag = 2;
}
- (void)chooseFrench{
    _LanguageLabel.text = @"Langue";
    _StartBtn.titleLabel.text = @"Démarrer le jeu";
    _level.text = @"Niveau";
    flag = 3;
}
@end
