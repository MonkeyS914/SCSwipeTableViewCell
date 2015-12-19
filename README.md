# SCSwipeTableViewCell
侧滑导航栏
# SCSwipeTableViewCell  仿QQ tableViewCell 侧滑自动定义btn

支持iOS6.0以上，最新测试系统iPhone6 iOS9.2

![image](https://raw.githubusercontent.com/MonkeyS914/SCSwipeTableViewCell/master/screenshort/1234.gif?2)

安装方法：

I 下载zip压缩包，把SCSwipeTableViewCell文件夹拖到自己工程下面 

import SCSwipeTableViewCell.h 

在tableViewCell的delegate里面实现自定义cell的侧滑btn

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

II 在pod 上search SCSwipeTableViewCell直接安装

之前看到cocoachina论坛上有人写过类似的控件，最近想尝试下写一个这个效果，只是简单的实现了左滑显示自定义btn，右滑显示自定义btn是一样的原理，后面会完善。这个是按照自己的想法写的，和SWTableViewCell还是有差距，希望多指教！

