//
//  RunLoopWorkDistribution.h
//  OptimizeTabCellImageView
//
//  Created by zheng zhang on 2017/9/12.
//  Copyright © 2017年 auction. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RunLoopWorkDistributionBlock)(void);

@interface RunLoopWorkDistribution : NSObject

+ (instancetype)sharedRunLoopWorkDistribution;

- (void)addTask:(RunLoopWorkDistributionBlock)unit;

- (void)removeAllTasks;

@end
