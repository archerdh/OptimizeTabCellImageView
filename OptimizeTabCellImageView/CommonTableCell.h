//
//  CommonTableCell.h
//  OptimizeTabCellImageView
//
//  Created by zheng zhang on 2017/9/12.
//  Copyright © 2017年 auction. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonTableCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *source;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSString *title;

@end
