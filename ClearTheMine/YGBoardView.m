//
//  YGBoardView.m
//  ClearTheMine
//
//  Created by xiangyaguo on 15-6-22.
//  Copyright (c) 2015年 XYG. All rights reserved.
//

#import "YGBoardView.h"
#import "Basic.h"

#define MINE_NUMBER 5
@implementation YGBoardView
{
    NSMutableArray * _basicArray;
    int _numberOfMineLeft;
    int _secondCost;
    NSTimer *_timer;
    UIImageView *_numberFirstImageView;
    UIImageView *_numberSecondeImageView;
    UIImageView *_numberThirdImageView;
    UIImageView *_secondFirstImageView;
    UIImageView *_secondSecondImageView;
    UIImageView *_secondThirdImageView;
    UIImageView *_smileFace;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 20, 320, 460);
        self.userInteractionEnabled = YES;
        _basicArray = [[NSMutableArray alloc] init];
        _numberOfMineLeft = MINE_NUMBER;
        _secondCost = 0;
        [self prepareScoreBar];
        [self prepareBoard];
        [self showWithnumberOfMineLeft];
        [self showWithSecondeOfScondCost];
    }
    return self;
}
-(void)prepareScoreBar
{
    
    _numberFirstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 40)];
    _numberSecondeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 20, 40)];
    _numberThirdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, 20, 40)];
    _secondFirstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(250, 0, 20, 40)];
    _secondSecondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 0, 20, 40)];
    _secondThirdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290, 0, 20, 40)];
    
    _smileFace = [[UIImageView alloc] initWithFrame:CGRectMake(140, 0, 40, 40)];
    _smileFace.image = [UIImage imageNamed:@"classic_smile_open"];
    _smileFace.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(smileTapClicked:)];
    tap.numberOfTapsRequired = 1;
    [_smileFace addGestureRecognizer:tap];
    
    [self addSubview:_numberFirstImageView];
    [self addSubview:_numberSecondeImageView];
    [self addSubview:_numberThirdImageView];
    [self addSubview:_secondFirstImageView];
    [self addSubview:_secondSecondImageView];
    [self addSubview:_secondThirdImageView];
    [self addSubview:_smileFace];
}
//点击笑脸重置游戏
- (void)smileTapClicked:(UITapGestureRecognizer *)tap
{
    [_timer invalidate];
    _timer = nil;
    self.userInteractionEnabled = YES;
    _basicArray = [[NSMutableArray alloc] init];
    _numberOfMineLeft = MINE_NUMBER;
    _secondCost = 0;
    [self prepareScoreBar];
    [self prepareBoard];
    [self showWithnumberOfMineLeft];
    [self showWithSecondeOfScondCost];
    
}
-(void)prepareBoard
{
    int randomPositionArr[MINE_NUMBER] = {0};
    randomPositionArr[0] = arc4random_uniform(21)*16+arc4random_uniform(16);
    int i = 1,j = 0;
    while (i < MINE_NUMBER) {
        int tmp = arc4random_uniform(21)*16+arc4random_uniform(16);
        for (j = 0; j < i;  j++) {
            if (tmp == randomPositionArr[j])
                break;
        }
        if (i == j) {
            randomPositionArr[i] = tmp;
            NSLog(@"[%d] = %d",i,randomPositionArr[i]);
            i++;
        }
    }
    //布置
    for (j = 0; j < 21; j++) {
        for (i = 0; i < 16; i++) {
            Basic *basic = [[Basic alloc] initWithFrame:CGRectMake(i*20, j*20+40, 20, 20)];
            basic.position = CGPointMake(i, j);
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1Clicked:)];
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2Clicked:)];
            tap2.numberOfTapsRequired = 2;
            [tap1 requireGestureRecognizerToFail:tap2];
            [basic addGestureRecognizer:tap1];
            [basic addGestureRecognizer:tap2];
            [_basicArray addObject:basic];
            [self addSubview:basic];
        }
    }
    //将随机数组中的元素相对应的坐标标上雷,周围的数字+1
    for (i = 0; i < MINE_NUMBER; i++) {
        Basic *basic = [_basicArray objectAtIndex:randomPositionArr[i]];
        basic.isMine = YES;
        basic.numberOfMineNearby = -1;
        for (Basic *b in [self BasicAtEverySideOfBasic:basic]) {
            if (!b.isMine)
                b.numberOfMineNearby += 1;
        }
    }
}
//单机标记
- (void)tap1Clicked:(UITapGestureRecognizer *)tap1
{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(showWithSecondeOfScondCost) userInfo:nil repeats:YES];
    }
    Basic *basic = (Basic *)tap1.view;
    basic.isMarked = !basic.isMarked;
    if (basic.isMarked) {
        if (_numberOfMineLeft > 0) {
            _numberOfMineLeft--;
            [self showWithnumberOfMineLeft];
            basic.image = [UIImage imageNamed:@"tile_0_d"];
        }
    }
    else {
        basic.image = [UIImage imageNamed:@"tile_0_mask"];
    }
        
}
//双击打开
-(void)tap2Clicked:(UITapGestureRecognizer *)tap2
{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(showWithSecondeOfScondCost) userInfo:nil repeats:YES];
    }
    Basic *basic = (Basic *)tap2.view;
    //点到地雷
    if (basic.isMine) {
        UIAlertView *lose = [[UIAlertView alloc] initWithTitle:@"遗憾" message:@"很不幸,手滑了一下!" delegate:nil cancelButtonTitle:@"朕知道了" otherButtonTitles:nil];
        [lose show];
        [_timer invalidate];
        for (Basic *b in _basicArray) {
            if (b.isMine) {
                b.image = [UIImage imageNamed:@"tile_0_b2"];
            }
            else if(b.numberOfMineNearby > 0){
//                b.image = [UIImage  imageNamed:@"tile_0_base"];
                NSString *str = [NSString stringWithFormat:@"tile_0_%d",b.numberOfMineNearby];
                b.image = [UIImage imageNamed:str];
            }
            else if(b.numberOfMineNearby == 0)
            {
                b.image = [UIImage imageNamed:@"tile_0_base"];
            }
        }
        basic.image = [UIImage imageNamed:@"tile_0_b"];
        basic.userInteractionEnabled = NO;
        _smileFace.image = [UIImage imageNamed:@"classic_smile_dead"];
    }
    //点到数字
    else if (basic.numberOfMineNearby > 0) {
        basic.image = [UIImage imageNamed:
                       [NSString stringWithFormat:@"tile_0_%d",basic.numberOfMineNearby]];
        basic.isChecked = YES;
        basic.userInteractionEnabled = NO;
        [self judgeWin];
    }
    //点到空
    else if(basic.numberOfMineNearby == 0){
        
        [self traverseTheBoardFromBasic:basic];
    }
}
- (void)judgeWin
{
    int k = 0;
    for (Basic *b in _basicArray) {
        if (!b.isMine && b.isChecked) {
            k++;
        }
    }
    if (k == 21*16 - MINE_NUMBER) {
        //获胜
        _smileFace.image = [UIImage imageNamed:@"classic_smile_win"];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *recorder = [ud objectForKey:@"time"];
        if (!recorder || _secondCost >= [recorder intValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜" message:@"看来你扫雷如秋风扫落叶!" delegate:nil cancelButtonTitle:@"承让!" otherButtonTitles:nil];
            [alert show];
            [ud setObject:[NSString stringWithFormat:@"%d",_secondCost] forKey:@"time"];
            [ud synchronize];
        }
        else if (_secondCost < [recorder intValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"破纪录" message:@"江南江北一条街,不用打听你是爹!" delegate:nil cancelButtonTitle:@"承让!" otherButtonTitles:nil];
            [alert show];
            [ud setObject:[NSString stringWithFormat:@"%d",_secondCost] forKey:@"time"];
            [ud synchronize];
        }
        [_timer invalidate];
//        _timer = nil;
    }
}
- (void)showWithnumberOfMineLeft
{
    _numberFirstImageView.image = [UIImage imageNamed:
                                     [NSString stringWithFormat:@"classic_numbers_%d",_numberOfMineLeft/100]];
    _numberSecondeImageView.image = [UIImage imageNamed:
                                     [NSString stringWithFormat:@"classic_numbers_%d",_numberOfMineLeft%100/10]];
    _numberThirdImageView.image = [UIImage imageNamed:
                                   [NSString stringWithFormat:@"classic_numbers_%d",_numberOfMineLeft%10]];
}
-(void)showWithSecondeOfScondCost
{
    
    _secondFirstImageView.image = [UIImage imageNamed:
                                   [NSString stringWithFormat:@"classic_numbers_%d_G",_secondCost/100]];
    _secondSecondImageView.image = [UIImage imageNamed:
                                    [NSString stringWithFormat:@"classic_numbers_%d_G",_secondCost%100/10]];
    NSString *str = [NSString stringWithFormat:@"classic_numbers_%d_G",_secondCost%10];
    UIImage *image = [UIImage imageNamed:str];
    _secondThirdImageView.image = image;
    _secondCost ++;
//    [UIImage imageNamed:[NSString stringWithFormat:@"classic_numbers_%d_G",_secondCost%10]];
}
/*isMine,isChecked,isMarked,numberOfMineNearby*/
- (void)traverseTheBoardFromBasic:(Basic *)basic
{
    basic.image = [UIImage imageNamed:@"tile_0_base"];
    basic.isChecked = YES;
    [self judgeWin];
    basic.userInteractionEnabled = NO;
    for (Basic *b in [self BasicAtFourDirectionOfBasic:basic]) {
        //遍历空格的四周
        if (!b.isMarked && !b.isChecked ) {
            //为数字
            if (b.numberOfMineNearby > 0) {
                b.isChecked = YES;
                b.image = [UIImage imageNamed:
                           [NSString stringWithFormat:@"tile_0_%d",b.numberOfMineNearby]];
                b.userInteractionEnabled = NO;
                [self judgeWin];
//                NSLog(@"numberOfMinewNearby = %d",b.numberOfMineNearby);
            }
            //点到空
            else if (b.numberOfMineNearby == 0) {
                [self traverseTheBoardFromBasic:b];
            }
        }

    }
}
- (NSArray *)BasicAtEverySideOfBasic:(Basic *)basic
{
    NSMutableArray *_array = [[NSMutableArray alloc] init];
    Basic * leftUp = [_basicArray objectAtPoint:CGPointMake(basic.position.x-1, basic.position.y-1)];
    Basic * rightUp = [_basicArray objectAtPoint:CGPointMake(basic.position.x+1, basic.position.y-1)];
    Basic * Up = [_basicArray objectAtPoint:CGPointMake(basic.position.x, basic.position.y-1)];
    Basic * Left = [_basicArray objectAtPoint:CGPointMake(basic.position.x-1, basic.position.y)];
    Basic * Right = [_basicArray objectAtPoint:CGPointMake(basic.position.x+1, basic.position.y)];
    Basic * leftDown = [_basicArray objectAtPoint:CGPointMake(basic.position.x-1, basic.position.y+1)];
    Basic * Down = [_basicArray objectAtPoint:CGPointMake(basic.position.x, basic.position.y+1)];
    Basic * rightDown = [_basicArray objectAtPoint:CGPointMake(basic.position.x+1, basic.position.y+1)];
    if (leftUp) {
        [_array addObject:leftUp];
    }
    if (rightUp) {
        [_array addObject:rightUp];
    }
    if (Up) {
        [_array addObject:Up];
    }
    if (Left) {
        [_array addObject:Left];
    }
    if (Right) {
        [_array addObject:Right];
    }
    if (leftDown) {
        [_array addObject:leftDown];
    }
    if (Down) {
        [_array addObject:Down];
    }
    if (rightDown) {
        [_array addObject:rightDown];
    }
    return [_array copy];
}
- (NSArray *)BasicAtFourDirectionOfBasic:(Basic *)basic
{
    Basic * Up = [_basicArray objectAtPoint:CGPointMake(basic.position.x, basic.position.y-1)];
    Basic * Left = [_basicArray objectAtPoint:CGPointMake(basic.position.x-1, basic.position.y)];
    Basic * Right = [_basicArray objectAtPoint:CGPointMake(basic.position.x+1, basic.position.y)];
    Basic * Down = [_basicArray objectAtPoint:CGPointMake(basic.position.x, basic.position.y+1)];
    NSMutableArray *_array = [[NSMutableArray alloc] init];
    if (Up) {
        [_array addObject:Up];
    }
    if (Left) {
        [_array addObject:Left];
    }
    if (Right) {
        [_array addObject:Right];
    }
    if (Down) {
        [_array addObject:Down];
    }
    return [_array copy];
}

























@end
