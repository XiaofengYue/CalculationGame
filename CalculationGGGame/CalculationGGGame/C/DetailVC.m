//
//  DetailVC.m
//  CalculationGGGame
//
//  Created by YXF on 2018/7/5.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "DetailVC.h"
#import "DetailCell.h"

@interface DetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView reloadData];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    back.frame = CGRectMake(self.view.frame.size.width*0.8, self.view.frame.size.height*0.8, self.view.frame.size.width*0.1, self.view.frame.size.width*0.1);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _question.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[NSBundle mainBundle]loadNibNamed:@"DetailCell" owner:nil options:nil].firstObject;
        cell.title.text = _question[indexPath.row];
        [cell.title setTextColor:[UIColor orangeColor]];
        cell.your.text = _your[indexPath.row];
        cell.stand.text = _answer[indexPath.row];
        [cell.stand setTextColor:[UIColor greenColor]];
    }
    return cell;
}

- (void)clickBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
