//
//  RunLoopWorkDistribution.m
//  OptimizeTabCellImageView
//
//  Created by zheng zhang on 2017/9/12.
//  Copyright © 2017年 auction. All rights reserved.
//

#import "RunLoopWorkDistribution.h"

@interface RunLoopWorkDistribution ()

@property (nonatomic, strong) NSMutableArray *tasks;

@end

@implementation RunLoopWorkDistribution
#pragma mark - systemMethod
- (instancetype)init
{
    if (self = [super init]) {
        self.tasks = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)sharedRunLoopWorkDistribution
{
    static RunLoopWorkDistribution *singleDis;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleDis = [[RunLoopWorkDistribution alloc] init];
        [self _registerRunLoopWorkDistributionAsMainRunloopObserver:singleDis];
    });
    return singleDis;
}

#pragma mark - customMethod
- (void)addTask:(RunLoopWorkDistributionBlock)unit{
    [self.tasks addObject:unit];
}

- (void)removeAllTasks {
    [self.tasks removeAllObjects];
}

#pragma mark - runloop观察者相关
+ (void)_registerRunLoopWorkDistributionAsMainRunloopObserver:(RunLoopWorkDistribution *)runLoopWorkDistribution {
    static CFRunLoopObserverRef defaultModeObserver;
    _registerObserver(kCFRunLoopBeforeWaiting, defaultModeObserver, NSIntegerMax - 999, kCFRunLoopDefaultMode, (__bridge void *)runLoopWorkDistribution, &_defaultModeRunLoopWorkDistributionCallback);
}

//注册一个观察者，观察每一次runloopd的开始和各种状态；
//观察者需要一个回调方法，由于这是corefoundation，是C code，你需要一个函数指针，来当做观察者d额回调方法
static void _registerObserver(CFOptionFlags activities, CFRunLoopObserverRef observer, CFIndex order, CFStringRef mode, void *info, CFRunLoopObserverCallBack callback) {
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopObserverContext context = {
        0,
        info,
        &CFRetain,
        &CFRelease,
        NULL
    };
    observer = CFRunLoopObserverCreate(     NULL,
                                       activities,
                                       YES,
                                       order,
                                       callback,
                                       &context);
    CFRunLoopAddObserver(runLoop, observer, mode);
    CFRelease(observer);
}

static void _defaultModeRunLoopWorkDistributionCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    _runLoopWorkDistributionCallback(observer, activity, info);
}

//这个方法就是观察者的回调方法，这个方法会在每次进入一个新的runloop循环的时候执行
//所以，假如我们有18个任务，每个任务就是一次imageview.image = image;
//所以我们每次只需要从我们的数组中取出第一个任务，执行它，然后remove掉
static void _runLoopWorkDistributionCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    RunLoopWorkDistribution *runLoopWorkDistribution = (__bridge RunLoopWorkDistribution *)info;
    if (runLoopWorkDistribution.tasks.count == 0) {
        return;
    }
    while (runLoopWorkDistribution.tasks.count) {
        RunLoopWorkDistributionBlock unit  = runLoopWorkDistribution.tasks.firstObject;
        unit();
        [runLoopWorkDistribution.tasks removeObjectAtIndex:0];
    }
}

@end
