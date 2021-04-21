//
//  BoomPickerColumnView.m
//  BoomPickerView
//
//  Created by jianghongbao on 2021/3/25.
//

#import "BoomPickerColumnView.h"
#import "BoomPickerColumnCell.h"
#import "BoomPickerTableView.h"

@interface BoomPickerColumnView ()

@property(nonatomic, strong, readwrite)BoomPickerColumManager *manager;
@property(nonatomic, copy)NSArray<BoomPickerTableView *> *tableViews;

@end

@implementation BoomPickerColumnView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
        [self configureSubviews];
    }
    return self;
}

- (void)setup {
    self.manager = [[BoomPickerColumManager alloc] init];
    __weak typeof(self) weakself = self;
    self.manager.didScrollBlock = ^(CGPoint offset) {
        [weakself.tableViews enumerateObjectsUsingBlock:^(BoomPickerTableView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx != BoomPickerColumnLevelCenter) {
                CGPoint newOffset = CGPointMake(obj.stableOffset.x, obj.stableOffset.y + offset.y);
                [obj setContentOffset:newOffset animated:NO];
            }
        }];
    };
    self.manager.scrollViewDidScrollBlock = ^(UIScrollView *scrollView) {
        if ([scrollView isKindOfClass:[BoomPickerTableView class]]) {
            BoomPickerTableView *tableView = (BoomPickerTableView *)scrollView;
            if (tableView) {
                [weakself setVisibleCellsTransformForTableview: tableView];
            }
        }
    };
}

- (void)setVisibleCellsTransformForTableview:(BoomPickerTableView *)tableView {
    //TODO: - (jianghongbao)滚轮形变
    /*
    BoomPickerColumnLevelType type = (BoomPickerColumnLevelType)tableView.tag;
    if (type != BoomPickerColumnLevelCenter) {
        __block CGFloat preTranslateY = 0;
        __block CGFloat preTranslateZ = 0;
        __block NSInteger realIdx = 0;
        NSArray *subviews = type == BoomPickerColumnLevelTop ? tableView.subviews : [[tableView.subviews reverseObjectEnumerator] allObjects];
        [subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[BoomPickerColumnCell class]]) {
                BoomPickerColumnCell *cell = (BoomPickerColumnCell *)obj;
                cell.layer.transform = [self transformWithHeight:[self.manager realRowHeight]
                                                             idx:realIdx
                                                       levelType:type
                                                   preTranslateY:preTranslateY
                                                   preTranslateZ:preTranslateZ
                                                 translateYBlock:^(CGFloat value) {
                    preTranslateY = value;
                } translateZBlock:^(CGFloat value) {
                    preTranslateZ = value;
                }];
                realIdx += 1;
            }
        }];
    }
     */
}

- (void)layoutSubviews {
    [super layoutSubviews];
    BoomPickerTableView *preTableView = nil;
    self.manager.showingRows = [self confirmTotalShowingRows];
    CGFloat sideLevelHeight = ([self confirmTotalShowingRows] / 2) * [self.manager realRowHeight];
    CGFloat centerLevelHeight = [self confirmTotalShowingRows] * [self.manager realRowHeight];
    for (int i = 0; i < self.tableViews.count; i++) {
        BoomPickerTableView *tableView = self.tableViews[i];
        if (preTableView) {
            if (i == BoomPickerColumnLevelCenter) {
                tableView.frame = CGRectMake(0, (self.bounds.size.height - centerLevelHeight) / 2, self.bounds.size.width, centerLevelHeight);
            } else {
                tableView.frame = CGRectMake(0, (self.bounds.size.height - [self.manager realRowHeight]) / 2 + [self.manager realRowHeight], self.bounds.size.width, sideLevelHeight);
            }
        } else {
            tableView.frame = CGRectMake(0, (self.bounds.size.height - [self.manager realRowHeight]) / 2 - sideLevelHeight, self.bounds.size.width, sideLevelHeight);
        }
        [self setVisibleCellsTransformForTableview: tableView];
        preTableView = tableView;
    }
}

/// 确认行数. 必须奇数嘛?
- (NSInteger)confirmTotalShowingRows {
    CGFloat modValue = (long)self.bounds.size.height / (long)[self.manager realRowHeight];
    if ((int)modValue % 2 == 0) {
        return (int)modValue - 1;
    }
    return (int)modValue;
}

- (void)configureSubviews {
    NSMutableArray *tempTableviews = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < BoomPickerStructLevels; i++) {
        BoomPickerTableView *tableView = [self setupTableViewForLevel:i];
        [tableView setUserInteractionEnabled: NO];
        [tempTableviews addObject:tableView];
        [self addSubview:tableView];
        if (i == BoomPickerColumnLevelCenter) {
            [tableView setUserInteractionEnabled: YES];
            [self insertSubview:tableView belowSubview:tempTableviews.firstObject];
        }
    }
    self.tableViews = tempTableviews;
}

- (BoomPickerTableView *)setupTableViewForLevel:(int)i {
    BoomPickerTableView *tableview = [[BoomPickerTableView alloc] init];
    tableview.tag = i;
    tableview.delegate = self.manager;
    tableview.dataSource = self.manager;
    tableview.backgroundColor = i == BoomPickerColumnLevelCenter ? [UIColor purpleColor] : [UIColor whiteColor];
    tableview.estimatedRowHeight = 0;
    tableview.estimatedSectionHeaderHeight = 0;
    tableview.estimatedSectionFooterHeight = 0;
    tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [tableview registerClass:[BoomPickerColumnCell class] forCellReuseIdentifier:@"BoomPickerColumnCell"];
    return tableview;
}

- (void)reloadData {
    NSLog(@"(jianghongbao)✅ reload data");
    [self.tableViews enumerateObjectsUsingBlock:^(BoomPickerTableView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj reloadData];
    }];
    
    [self.tableViews enumerateObjectsUsingBlock:^(BoomPickerTableView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case BoomPickerColumnLevelTop:
                [obj setContentOffset:CGPointMake(0, self.manager.selectedRow * [self.manager realRowHeight]) animated:NO];
                break;
            case BoomPickerColumnLevelCenter:
                [obj setContentOffset:CGPointMake(0, self.manager.selectedRow * [self.manager realRowHeight]) animated:NO];
                break;
            case BoomPickerColumnLevelBottom:
                obj.stableOffset = CGPointMake(0, ([self showingRows] + 1) * [self.manager realRowHeight]);
                [obj setContentOffset:CGPointMake(0, [self.manager realRowHeight] + (self.manager.selectedRow + [self showingRows]) * [self.manager realRowHeight]) animated:NO];
                break;
            default:
                break;
        }
    }];
}

- (NSInteger)showingRows {
    return ([self confirmTotalShowingRows] / 2);
}

- (CATransform3D)transformWithHeight:(CGFloat)height
                                 idx:(NSInteger)idx
                           levelType:(BoomPickerColumnLevelType)levelType
                       preTranslateY:(CGFloat)preTranslateY
                       preTranslateZ:(CGFloat)preTranslateZ
                     translateYBlock:(void(^)(CGFloat))yblock
                     translateZBlock:(void(^)(CGFloat))zblock {
    CGFloat realRowMargin = levelType == BoomPickerColumnLevelTop ? -BoomPickerDefaultRowMargin : BoomPickerDefaultRowMargin;
    // 求角度
    CGFloat calculateAngle = (idx > (BoomPickerMaxVisualNumber - 1) ? BoomPickerMaxVisualNumber : (idx + 1)) * M_PI_2 / BoomPickerMaxVisualNumber;
    CGFloat angle = levelType == BoomPickerColumnLevelTop ? calculateAngle : -calculateAngle;
    // X轴旋转
    CATransform3D transformOfRotate = CATransform3DMakeRotation(angle, 1, 0, 0);
    // 求Y轴位移值
    CGFloat calculateTranslateForY = (height - cos(angle) * height);
    CGFloat translateForY = levelType == BoomPickerColumnLevelTop ? calculateTranslateForY : -calculateTranslateForY;
    CGFloat realTranslateForY = (preTranslateY + translateForY / 2) + realRowMargin;
    // Y轴位移
    CATransform3D transformOfTranslateY = CATransform3DMakeTranslation(0, realTranslateForY, 0);
    if (yblock) {
        CGFloat newpreTranslateY = preTranslateY + translateForY + realRowMargin;
        yblock(newpreTranslateY);
    }
    // 求Z轴位移值
    CGFloat calculateTranslateForZ = sin(angle) * height;
    CGFloat translateForZ = levelType == BoomPickerColumnLevelTop ? -calculateTranslateForZ : calculateTranslateForZ;
    CGFloat realTranslateForZ = preTranslateZ + translateForZ / 2;
    // Z轴位移
    CATransform3D transformOfTranslateZ = CATransform3DMakeTranslation(0, 0, realTranslateForZ);
    if (zblock) {
        zblock(preTranslateZ + translateForZ);
    }
    CATransform3D transform = CATransform3DConcat(transformOfRotate, transformOfTranslateY);
    return CATransform3DConcat(transform, transformOfTranslateZ);
}

/*
 struct CATransform3D{
   CGFloat     m11(x缩放),   m12(y切变),   m13(旋转),   m14();
   CGFloat     m21(x切变),   m22(y缩放),   m23,        m24;
   CGFloat     m31(旋转),    m32,         m33,         m34(透视效果，要有旋转角度才能看出效果）;
   CGFloat     m41(x平移),   m42(y平移),   m43(z平移),  m44;
 };
 */

@end
