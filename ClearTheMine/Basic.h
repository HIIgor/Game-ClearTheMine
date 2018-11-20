//
//  YGBaisc.h
//  ClearTheMine
//
//  Created by xiangyaguo on 15-6-22.
//  Copyright (c) 2015年 XYG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSMutableArray (judgeBeyond)
-(id)objectAtPoint:(CGPoint)point;
@end

@interface Basic : UIImageView
@property (nonatomic ,assign) BOOL isMine;
@property (nonatomic ,assign) BOOL isChecked;
@property (nonatomic ,assign) BOOL isMarked;
@property (nonatomic ,assign) CGPoint position;
@property (nonatomic ,assign) int numberOfMineNearby;
@end
/*isMine,isChecked,isMarked,numberOfMineNearby*/
