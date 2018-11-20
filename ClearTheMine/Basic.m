//
//  YGBaisc.m
//  ClearTheMine
//
//  Created by xiangyaguo on 15-6-22.
//  Copyright (c) 2015年 XYG. All rights reserved.
//

#import "Basic.h"
@implementation NSMutableArray (judgeBeyond)

-(id)objectAtPoint:(CGPoint)point
{
    if (point.x > 15 || point.x < 0 || point.y < 0 || point.y > 20) {
        return nil;
    }
    else
        return [self objectAtIndex:point.x+point.y*16];
}
@end

@implementation Basic

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"tile_0_mask"];
        self.isMine = NO;
        self.isChecked = NO;
        self.numberOfMineNearby = 0;
        self.userInteractionEnabled = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
