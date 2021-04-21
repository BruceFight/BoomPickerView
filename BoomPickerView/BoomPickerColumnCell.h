//
//  BoomPickerColumnCell.h
//  BoomPickerView
//
//  Created by jianghongbao on 2021/3/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BoomPickerColumnCell : UITableViewCell

@property(nonatomic, strong)UIView *customContentView;
@property(nonatomic, weak)id<NSCopying, NSMutableCopying, NSSecureCoding> content;

@end

NS_ASSUME_NONNULL_END
