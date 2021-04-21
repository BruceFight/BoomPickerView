//
//  BoomPickerColumManager.m
//  BoomPickerView
//
//  Created by jianghongbao on 2021/3/25.
//

#import "BoomPickerColumManager.h"
#import "BoomPickerColumnCell.h"
#import <AVFoundation/AVFoundation.h>

@interface BoomPickerColumManager ()

@property(nonatomic, assign)NSInteger currentRow;

@end

@implementation BoomPickerColumManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark - (jianghongbao)UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.row + 2 * (self.showingRows / 2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BoomPickerColumnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BoomPickerColumnCell"];
    if (!cell) {
        cell = [[BoomPickerColumnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BoomPickerColumnCell"];
    }
    switch (tableView.tag) {
        case BoomPickerColumnLevelCenter:
            cell.contentView.backgroundColor = [UIColor redColor];
            break;
        default:
            cell.contentView.backgroundColor = [UIColor blueColor];
            break;
    }
    if (indexPath.row < self.showingRows / 2) {
        cell.content = @"丢";
    } else if ((indexPath.row - self.showingRows / 2) < self.row){
        cell.content = [NSString stringWithFormat:@"%@", @(indexPath.row - self.showingRows / 2)];
    } else if (indexPath.row >= self.showingRows / 2) {
        cell.content = @"丢";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self realRowHeight];
}

- (CGFloat)realRowHeight {
    if (self.rowHeight <= 0) {
        // 求模
        CGFloat modValue = (long)self.contentHeight % (long)BoomPickerMaxRowHeight;
        if (modValue >= BoomPickerMaxVisualNumber) {
            return BoomPickerMaxRowHeight;
        }
        return BoomPickerMinRowHeight;
    }
    return self.rowHeight;
}

#pragma mark - (jianghongbao)UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 用于统一步伐
    if (scrollView.tag == BoomPickerColumnLevelCenter) {
        if (self.didScrollBlock) {
            self.didScrollBlock(scrollView.contentOffset);
        }
    }
    // 用于各层级TableViewCell的形变处理
    if (self.scrollViewDidScrollBlock) {
        self.scrollViewDidScrollBlock(scrollView);
    }
    // 滴答声
    if (scrollView.tag == BoomPickerColumnLevelCenter) {
        NSInteger realIndex = [self fetchRealIndexOfScrollView: scrollView];
        if (self.currentRow != realIndex) {
            self.currentRow = realIndex;
            if (realIndex >= 0) {
                [self dida];
            }
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    // 即将停止拖拽
    if (scrollView.tag == BoomPickerColumnLevelCenter) {
        NSInteger realIndex = [self fetchRealIndexOfScrollView: scrollView];
        CGFloat aimOffsetY = realIndex * [self realRowHeight];
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, aimOffsetY) animated:YES];
    }
}

- (NSInteger)fetchRealIndexOfScrollView:(UIScrollView *)scrollView {
    CGFloat index = scrollView.contentOffset.y / [self realRowHeight];
    CGFloat remainder = index - floor(index);
    return floor(index) + (remainder < 0.5 ? 0 : 1);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 停止拖拽
    NSLog(@"(jianghongbao)✅ scrollViewDidEndDragging");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    // 即将开始速减
    NSLog(@"(jianghongbao)✅ scrollViewWillBeginDecelerating");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 速减结束
    NSLog(@"(jianghongbao)✅ scrollViewDidEndDecelerating");
}

- (void)dida {
    AudioServicesPlaySystemSoundWithCompletion(1157, nil);
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *impactFeedBack = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [impactFeedBack prepare];
        [impactFeedBack impactOccurred];
    }
}

- (NSInteger)confirmResultSelectedRow {
    if (self.selectedRow <= 0) {
        return 0;
    } else if (self.selectedRow >= self.row) {
        return self.row;
    }
    return self.selectedRow;
}

@end
