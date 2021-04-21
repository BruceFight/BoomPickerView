//
//  BoomPickerColumManager.h
//  BoomPickerView
//
//  Created by jianghongbao on 2021/3/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 层级结构数
#define BoomPickerStructLevels 3
/// 最大可见数
#define BoomPickerMaxVisualNumber 8
/// 最小行高
#define BoomPickerMinRowHeight 24.0
/// 最大行高
#define BoomPickerMaxRowHeight 32.0
/// 默认行间隔
#define BoomPickerDefaultRowMargin 3.0

typedef enum : NSUInteger {
    BoomPickerColumnLevelTop,
    BoomPickerColumnLevelCenter,
    BoomPickerColumnLevelBottom,
} BoomPickerColumnLevelType;

typedef void(^BoomPickerColumnDidScrollBlock)(CGPoint);
typedef void(^BoomPickerColumnScrollViewDidScroll)(UIScrollView *);

@interface BoomPickerColumManager : NSObject<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, assign)NSInteger row;
@property(nonatomic, assign)NSInteger showingRows;
@property(nonatomic, assign)NSInteger selectedRow;
@property(nonatomic, assign)CGFloat contentHeight;
@property(nonatomic, assign)CGFloat rowHeight;
@property(nonatomic, copy)BoomPickerColumnDidScrollBlock didScrollBlock;
@property(nonatomic, copy)BoomPickerColumnScrollViewDidScroll scrollViewDidScrollBlock;

- (CGFloat)realRowHeight;

@end

NS_ASSUME_NONNULL_END
