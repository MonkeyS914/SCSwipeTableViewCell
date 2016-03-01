# SCSwipeTableViewCell

# SCSwipeTableViewCell  仿QQ tableViewCell 侧滑自定义btn
==============
[![CocoaPods](http://img.shields.io/cocoapods/v/SCSwipeTableViewCell.svg?style=flat)](http://cocoapods.org/?q= YYText)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/SCSwipeTableViewCell.svg?style=flat)](http://cocoapods.org/?q= SCSwipeTableViewCell)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%206%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;


### 支持iOS6.0以上，最新测试系统iPhone6 iOS9.2

###------3.1更新v1.0.4------

     感谢[kallyWang](https://github.com/kallyWang)发现的bug，关于cellheight错乱问题，已经fixed

###------12.23更新v1.0.3------

     fix the bug(didSelectRowAtIndexPath didn't respond)

###------12.20更新v1.0.2------

     1.adjust btn height to cell height itself

     2.judge the condition with translation.x and translation.y on when to enable tablevieW scroll and when to enbale cell animation

###------12.20更新v1.0.1------

     1.重写reuse方法，在进入队列后还原为初始状态

     2.optionBtn点击后，cell将会还原

     3.修复tableView上滑下滑时会展开cell的bug

###------12.19初始版本v1.0.0------

     1.实现cell左滑后btn自定义

     2.可以监测btn的四个状态（willshow，didshow，willhide，didhide）和点击事件（clicked）


![image](https://raw.githubusercontent.com/MonkeyS914/SCSwipeTableViewCell/master/screenshort/1234.gif?2)

### 安装方法：
==============

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

