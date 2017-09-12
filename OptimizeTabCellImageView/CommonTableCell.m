//
//  CommonTableCell.m
//  OptimizeTabCellImageView
//
//  Created by zheng zhang on 2017/9/12.
//  Copyright © 2017年 auction. All rights reserved.
//

#import "CommonTableCell.h"
#import "RunLoopWorkDistribution.h"
@interface CommonTableCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *firstImageView;
@property (strong, nonatomic) UIImageView *secondImageView;
@property (strong, nonatomic) UIImageView *thirdImageView;
@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation CommonTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.firstImageView];
        [self.contentView addSubview:self.secondImageView];
        [self.contentView addSubview:self.thirdImageView];
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}

#pragma mark - context
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

#pragma mark - 数据处理
- (void)setSource:(NSDictionary *)source
{
    _source = source;
    _titleLabel.text = [NSString stringWithFormat:@"%zd %@", self.index, source[@"title"]];
    _contentLabel.text = [NSString stringWithFormat:@"%zd %@", self.index, source[@"detail"]];
    NSString *path = [[NSBundle mainBundle] pathForResource:source[@"image"] ofType:@"jpg"];
    //不优化
    if ([_title containsString:@"一"]) {
        _firstImageView.image = [UIImage imageNamed:@""];
        _secondImageView.image = [UIImage imageNamed:@""];
        _thirdImageView.image = [UIImage imageNamed:@""];
        [UIView transitionWithView:self.contentView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
            _firstImageView.image = [UIImage imageWithContentsOfFile:path];
            _secondImageView.image = [UIImage imageWithContentsOfFile:path];
            _thirdImageView.image = [UIImage imageWithContentsOfFile:path];
        } completion:^(BOOL finished) {
        }];
    }
    //优化方式之context
    else if ([_title containsString:@"二"])
    {
        UIImage *sourceImage = [UIImage imageWithContentsOfFile:path];
        dispatch_async(dispatch_queue_create("com.queue11", DISPATCH_QUEUE_SERIAL), ^{
            UIImage *result = [self reSizeImage:sourceImage toSize:CGSizeMake(65, 65)];
            dispatch_async(dispatch_get_main_queue(), ^{
                _firstImageView.image = [UIImage imageNamed:@""];
                _secondImageView.image = [UIImage imageNamed:@""];
                _thirdImageView.image = [UIImage imageNamed:@""];
                [UIView transitionWithView:self.contentView duration:1 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    _firstImageView.image = result;
                    _secondImageView.image = result;
                    _thirdImageView.image = result;
                } completion:^(BOOL finished) {
                }];
            });
        });
    }
    //优化方式之runloop
    else if ([_title containsString:@"三"])
    {
        [[RunLoopWorkDistribution sharedRunLoopWorkDistribution] addTask:^{
            _firstImageView.image = [UIImage imageNamed:@""];
            [UIView transitionWithView:self.contentView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
                _firstImageView.image = [UIImage imageWithContentsOfFile:path];
            } completion:^(BOOL finished) {
            }];
        }];
        [[RunLoopWorkDistribution sharedRunLoopWorkDistribution] addTask:^{
            _secondImageView.image = [UIImage imageNamed:@""];
            [UIView transitionWithView:self.contentView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
                _secondImageView.image = [UIImage imageWithContentsOfFile:path];
            } completion:^(BOOL finished) {
            }];
        }];
        [[RunLoopWorkDistribution sharedRunLoopWorkDistribution] addTask:^{
            _thirdImageView.image = [UIImage imageNamed:@""];
            [UIView transitionWithView:self.contentView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
                _thirdImageView.image = [UIImage imageWithContentsOfFile:path];
            } completion:^(BOOL finished) {
            }];
        }];
    }
}

#pragma mark - UI
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 300, 25)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor redColor];
            label.font = [UIFont boldSystemFontOfSize:13];
            label;
        });
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 99, 300, 35)];
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.numberOfLines = 0;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor colorWithRed:0 green:100.f/255.f blue:0 alpha:1];
            label.font = [UIFont boldSystemFontOfSize:13];
            label;
        });
    }
    return _contentLabel;
}

- (UIImageView *)firstImageView
{
    if (!_firstImageView) {
        _firstImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(105, 30, 65, 65)];
            imageView.backgroundColor = [UIColor grayColor];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView;
        });
    }
    return _firstImageView;
}

- (UIImageView *)secondImageView
{
    if (!_secondImageView) {
        _secondImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 30, 65, 65)];
            imageView.backgroundColor = [UIColor grayColor];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView;
        });
    }
    return _secondImageView;
}

- (UIImageView *)thirdImageView
{
    if (!_thirdImageView) {
        _thirdImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 30, 65, 65)];
            imageView.backgroundColor = [UIColor grayColor];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView;
        });
    }
    return _thirdImageView;
}

@end
