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
    NSString *message = [NSString stringWithFormat:@"you choose the %ldth btn in section %ld row %ld",(long)tag,(long)indexpath.section,(long)indexpath.row ];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"tips"
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:@"ok"
                                         otherButtonTitles:nil, nil];
    [alert show];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 212;
    }
    
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"DefacultCell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        return cell;
    }
    else{
        UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 55)];
        btn1.backgroundColor = [UIColor redColor];
        [btn1 setTitle:@"delete" forState:UIControlStateNormal];
        UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 55)];
        btn2.backgroundColor = [UIColor greenColor];
        [btn2 setTitle:@"add" forState:UIControlStateNormal];
        btnArr = [[NSMutableArray alloc]initWithObjects:btn1,btn2, nil];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 55)];
        
        static NSString *cellIdentifier = @"Cell";
        SCSwipeTableViewCell *cell = (SCSwipeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[SCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:@"Cell"
                                                      withBtns:btnArr
                                                     tableView:_tableView
                                                 cellIndexPath:indexPath];
            cell.delegate = self;
            [cell.SCContentView addSubview:label];
        }
        
//        for (UILabel *subLabel in cell.SCContentView.subviews) {
            label.text = [NSString stringWithFormat:@"swipeCell test row %ld",(long)indexPath.row];
//        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *selected = [tableView indexPathForSelectedRow];
    
    if(selected)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    NSString *message = [NSString stringWithFormat:@"you choose cell in section %ld row %ld"
                         ,(long)indexPath.section,(long)indexPath.row ];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"tips"
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:@"ok"
                                         otherButtonTitles:nil, nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
