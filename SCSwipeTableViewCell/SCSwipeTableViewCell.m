//
//  SCSwipeTableViewCell.m
//  SCSwipeTableViewCell
//
//  Created by Sunc on 15/12/17.
//  Copyright © 2015年 Sunc. All rights reserved.
//

#import "SCSwipeTableViewCell.h"

#define SC_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

@interface SCSwipeTableViewCell()<UIGestureRecognizerDelegate>

@property (nonatomic, retain)UIView  *cellContentView;
@property (nonatomic, retain)UIPanGestureRecognizer *panGesture;
@property (nonatomic, retain)UITapGestureRecognizer *tapGesture;
@property (nonatomic, assign)CGFloat judgeWidth;
@property (nonatomic, assign)CGFloat rightfinalWidth;
@property (nonatomic, assign)CGFloat cellHeight;
@property (nonatomic, assign,readwrite)BOOL isRightBtnShow;
@property (nonatomic, assign)BOOL otherCellIsOpen;
@property (nonatomic, assign)BOOL isHiding;
@property (nonatomic, assign)BOOL isShowing;
@end

@implementation SCSwipeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                     withBtns:(NSArray *)arr
          tableView:(UITableView *)tableView cellIndexPath:(NSIndexPath *)indexPath
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _rightBtnArr = [NSArray arrayWithArray:arr];
        self.superTableView = tableView;
        self.cellHeight = [_superTableView rectForRowAtIndexPath:indexPath].size.height;
        
        NSLog(@"%f",self.cellHeight);
        
        [self prepareForCell];
        self.selectionStyle = UITableViewCellSelectionStyleNone;//set default select style
    }
    return self;
}

- (void)prepareForCell{
    [self setBtns];
    [self setScrollView];
    [self addObserverEvent];
    [self addNotify];
}

#pragma mark prepareForReuser
- (void)prepareForReuse
{
    if ((_SCContentView.frame.origin.x == -_judgeWidth)) {
        if (!_isHiding) {
            [self cellWillHide];
            _isHiding = YES;
        }
    }
    _superTableView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect temRect = _SCContentView.frame;
        temRect.origin.x = 0;
        _SCContentView.frame = temRect;
    } completion:^(BOOL finished) {
        if (_isRightBtnShow) {
            [self cellDidHide];
            _isHiding = NO;
        }
    }];
    [super prepareForReuse];
}

#pragma mark setter
- (void)setRightBtnArr:(NSArray *)rightBtnArr{
    _rightBtnArr = rightBtnArr;
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    [self setBtns];
}

#pragma mark initCell

- (void)setBtns{
    if (_rightBtnArr.count>0) {
        [self processBtns];
    }
    else{
        return;
    }
}

- (void)processBtns{
    CGFloat lastWidth = 0;
    int i = 0;
    
    for (UIButton *temBtn in _rightBtnArr)
    {
        temBtn.tag = i;
        CGRect temRect = temBtn.frame;
        temRect.origin.x = SC_SCREEN_WIDTH - temRect.size.width - lastWidth;
        temBtn.frame = temRect;
        lastWidth = lastWidth + temBtn.frame.size.width;
        
        if (!_judgeWidth) {
            _judgeWidth = lastWidth;
        }
        
        if (_cellHeight != temBtn.frame.size.height) {
            CGRect frame = temBtn.frame;
            frame.size.height = _cellHeight;
            temBtn.frame = frame;
        }
        [temBtn addTarget:self action:@selector(cellBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (_SCContentView) {
            [self.contentView insertSubview:temBtn belowSubview:_SCContentView];
        }
        else{
            [self.contentView addSubview:temBtn];
        }
        i++;
    }
    _rightfinalWidth = lastWidth;
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setScrollView{
    if (_SCContentView) {
        return;
    }
    _SCContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SC_SCREEN_WIDTH, _cellHeight)];
    _SCContentView.backgroundColor = [UIColor yellowColor];
    
    [self.contentView addSubview:_SCContentView];
    self.contentView.clipsToBounds = YES;
    
    _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    _panGesture.delegate = self;
    [self.SCContentView addGestureRecognizer:_panGesture];
    
    _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellTaped:)];
    _tapGesture.delegate = self;
    [self.SCContentView addGestureRecognizer:_tapGesture];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideBtn];
}

#pragma mark events,gesture and observe

- (void)addNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotify:)
                                                 name:@"SC_CELL_SHOULDCLOSE"
                                               object:nil];
}

- (void)handleNotify:(NSNotification *)notify{
    if ([[notify.userInfo objectForKey:@"action"] isEqualToString:@"closeCell"]) {
        [self hideBtn];
        _otherCellIsOpen = NO;
    }
    else if ([[notify.userInfo objectForKey:@"action"] isEqualToString:@"otherCellIsOpen"]){
        _otherCellIsOpen = YES;
    }
    else if ([[notify.userInfo objectForKey:@"action"] isEqualToString:@"otherCellIsClose"])
    {
        _otherCellIsOpen = NO;
    }
}

- (void)addObserverEvent{
    [_superTableView addObserver:self
                      forKeyPath:@"contentOffset"
                         options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                         context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint oldpoint = [[change objectForKey:@"old"] CGPointValue];
        CGPoint newpoint = [[change objectForKey:@"new"] CGPointValue];
        if (oldpoint.y!=newpoint.y) {
//            NSLog(@"---sueperTabelViewMoves---");
            if ((_SCContentView.frame.origin.x == -_judgeWidth)) {
                [self hideBtn];
            }
        }
    }
}

- (void)cellTaped:(UITapGestureRecognizer *)recognizer{
    NSIndexPath *indexPath = [self.superTableView indexPathForCell:self];
    [self.superTableView.delegate tableView:self.superTableView didSelectRowAtIndexPath:indexPath];
    if (_otherCellIsOpen) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SC_CELL_SHOULDCLOSE" object:nil userInfo:@{@"action":@"closeCell"}];
    }
}

- (void)handleGesture:(UIPanGestureRecognizer *)recognizer{
    if (_isShowing||_isHiding) {
        return;
    }
    CGPoint translation = [_panGesture translationInView:self];
//    CGPoint location = [_panGesture locationInView:self];
//    NSLog(@"translation----(%f)----loaction(%f)",translation.x,location.y);
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            if (fabs(translation.x)<fabs(translation.y)) {
                _superTableView.scrollEnabled = YES;
                return;
            }else{
                _superTableView.scrollEnabled = NO;
            }
            if (_otherCellIsOpen) {
                return;
            }
            //contentoffse changed
            if (translation.x<0) {
                if (self.SCContentView.frame.origin.x==_rightfinalWidth) {
                    translation.x = self.SCContentView.frame.origin.x;
                }
                [self moveSCContentView:translation.x];
            }
            else if (translation.x>0){
                //SCContentView is moving towards right
                [self hideBtn];
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            _superTableView.scrollEnabled = YES;
            if (_otherCellIsOpen&&!(_SCContentView.frame.origin.x == -_judgeWidth)) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"SC_CELL_SHOULDCLOSE" object:nil userInfo:@{@"action":@"closeCell"}];
                return;
            }
            //end pan
            [self SCContentViewStop];
            break;
            
        case UIGestureRecognizerStateCancelled:
            _superTableView.scrollEnabled = YES;
            //cancell
            [self SCContentViewStop];
            break;
            
        default:
            break;
    }
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
}

- (void)moveSCContentView:(CGFloat)offset{
    CGRect temRect = _SCContentView.frame;
    temRect.origin.x = (temRect.origin.x + offset);//adjust touch offset with your finger movement
    if (temRect.origin.x+(SC_SCREEN_WIDTH)/2.0<0) {
        temRect.origin.x = -SC_SCREEN_WIDTH/2.0;
    }
    if (temRect.origin.x>SC_SCREEN_WIDTH/2.0) {
        temRect.origin.x = SC_SCREEN_WIDTH/2.0;
    }
    _SCContentView.frame = temRect;
}

- (void)SCContentViewStop{
    if ((_SCContentView.frame.origin.x == -_judgeWidth)) {
        //btn is shown
        if (_SCContentView.frame.origin.x + _judgeWidth<0) {
            [self showBtn];
        }
        else
        {
            [self hideBtn];
        }
    }
    else{
        if (_SCContentView.frame.origin.x+_judgeWidth>0) {
            [self hideBtn];
        }
        else{
            [self showBtn];
        }
    }
}

#pragma mark showBtn hideBtn

- (void)showBtn{
    if (!(_SCContentView.frame.origin.x == -_judgeWidth)) {
        if (!_isShowing) {
            [self cellWillShow];
            _isShowing = YES;
        }
    }
    _superTableView.scrollEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect temRect = _SCContentView.frame;
        temRect.origin.x = -_rightfinalWidth;
        _SCContentView.frame = temRect;
    } completion:^(BOOL finished) {
        if (!_isRightBtnShow) {
            [self cellDidShow];
            _isShowing = NO;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SC_CELL_SHOULDCLOSE" object:nil userInfo:@{@"action":@"otherCellIsOpen"}];
        _superTableView.scrollEnabled = YES;
    }];
}

- (void)hideBtn{
    if ((_SCContentView.frame.origin.x == -_judgeWidth)) {
        if (!_isHiding) {
            [self cellWillHide];
            _isHiding = YES;
        }
    }
    _superTableView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect temRect = _SCContentView.frame;
        temRect.origin.x = 0;
        _SCContentView.frame = temRect;
    } completion:^(BOOL finished) {
        if (_isRightBtnShow) {
            [self cellDidHide];
            _isHiding = NO;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SC_CELL_SHOULDCLOSE" object:nil userInfo:@{@"action":@"otherCellIsClose"}];
        _superTableView.userInteractionEnabled = YES;
    }];
}

#pragma delegate

- (void)cellWillHide{
    if ([_delegate respondsToSelector:@selector(cellOptionBtnWillHide)]) {
        [_delegate cellOptionBtnWillHide];
    }
}

- (void)cellWillShow{
    if ([_delegate respondsToSelector:@selector(cellOptionBtnWillShow)]) {
        [_delegate cellOptionBtnWillShow];
    }
}

- (void)cellDidShow{
    if ([_delegate respondsToSelector:@selector(cellOptionBtnDidShow)]) {
        [_delegate cellOptionBtnDidShow];
    }
}

- (void)cellDidHide{
    if ([_delegate respondsToSelector:@selector(cellOptionBtnDidHide)]) {
        [_delegate cellOptionBtnDidHide];
    }
}

- (void)cellBtnClicked:(UIButton *)sender{
    NSIndexPath *indexPath = [self.superTableView indexPathForCell:self];
    if ([_delegate respondsToSelector:@selector(SCSwipeTableViewCelldidSelectBtnWithTag:andIndexPath:)]) {
        [_delegate SCSwipeTableViewCelldidSelectBtnWithTag:sender.tag andIndexPath:indexPath];
    }
    [self hideBtn];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)dealloc{
    [_superTableView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SC_CELL_SHOULDCLOSE" object:nil];
}
@end
