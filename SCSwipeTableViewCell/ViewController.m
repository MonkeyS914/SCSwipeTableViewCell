//
//  ViewController.m
//  SCSwipeTableViewCell
//
//  Created by Sunc on 15/12/17.
//  Copyright © 2015年 Sunc. All rights reserved.
//

#import "ViewController.h"
#import "SCSwipeTableViewCell.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,SCSwipeTableViewCellDelegate>
{
    NSMutableArray *btnArr;
}
@property (nonatomic, retain)UITableView *tableView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"SCSwipeTableViewCell";
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark SCSwipeTableViewCellDelegate

- (void)SCSwipeTableViewCelldidSelectBtnWithTag:(NSInteger)tag andIndexPath:(NSIndexPath *)indexpath{
    NSLog(@"you choose the %ldth btn in section %ld row %ld",(long)tag,(long)indexpath.section,(long)indexpath.row);
}

- (void)cellOptionBtnWillShow{
    NSLog(@"cellOptionBtnWillShow");
}

- (void)cellOptionBtnWillHide{
    NSLog(@"cellOptionBtnWillHide");
}

- (void)cellOptionBtnDidShow{
    NSLog(@"cellOptionBtnDidShow");
}

- (void)cellOptionBtnDidHide{
    NSLog(@"cellOptionBtnDidHide");
}


#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 55)];
    btn1.backgroundColor = [UIColor redColor];
    [btn1 setTitle:@"delete" forState:UIControlStateNormal];
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 55)];
    btn2.backgroundColor = [UIColor greenColor];
    [btn2 setTitle:@"add" forState:UIControlStateNormal];
    btnArr = [[NSMutableArray alloc]initWithObjects:btn1,btn2, nil];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 55)];
    label.text = [NSString stringWithFormat:@"swipeCell test row %ld",(long)indexPath.row];
    
    static NSString *cellIdentifier = @"Cell";
    SCSwipeTableViewCell *cell = (SCSwipeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:@"Cell"
                                                  withBtns:btnArr
                                                 tableView:_tableView];
        cell.delegate = self;
    }
    
    [cell.SCContentView addSubview:label];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *selected = [tableView indexPathForSelectedRow];
    
    if(selected)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
