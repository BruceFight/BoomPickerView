//
//  BoomPickerView.m
//  BoomPickerView
//
//  Created by jianghongbao on 2021/3/25.
//

#import "BoomPickerView.h"
#import "BoomPickerColumnView.h"

@interface BoomPickerView ()

@property(nonatomic, copy)NSArray<BoomPickerColumnView *> *columnViews;

@end

@implementation BoomPickerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)didMoveToSuperview {
    [self configureSubviews];
    NSLog(@"(jianghongbao)✅ did move to super view");
}

- (void)configureSubviews {
    NSMutableArray *tempColumnViews = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < [self numberOfComponents]; i++) {
        BoomPickerColumnView *colunmView = [[BoomPickerColumnView alloc] init];
        colunmView.manager.row = [self numberOfRowsInComponent:i];
        [tempColumnViews addObject:colunmView];
        [self addSubview:colunmView];
    }
    self.columnViews = tempColumnViews;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"(jianghongbao)✅ super layout frame = %@", NSStringFromCGRect(self.frame));
    BoomPickerColumnView *preColumnView = nil;
    CGFloat columnHeight = self.bounds.size.height - 2 * [self boomPickerSafaVerticalBorder];
    for (int i = 0; i < self.columnViews.count; i++) {
        BoomPickerColumnView *columnView = self.columnViews[i];
        if (preColumnView) {
            columnView.frame = CGRectMake(CGRectGetMaxX(preColumnView.frame),
                                          CGRectGetMinY(preColumnView.frame),
                                          [self widthForComponent:i],
                                          CGRectGetHeight(preColumnView.frame));
        } else {
            columnView.frame = CGRectMake([self boomPickerSafaHorizontalBorder],
                                          [self boomPickerSafaVerticalBorder],
                                          [self widthForComponent:i],
                                          columnHeight);
        }
        columnView.manager.contentHeight = self.frame.size.height;
        columnView.manager.rowHeight = [self rowHeightForComponent:i];
        [columnView reloadData];
        preColumnView = columnView;
    }
}

//TODO: - (jianghongbao)❌
- (CGFloat)boomPickerSafaHorizontalBorder {
    return 0;
}

//TODO: - (jianghongbao)❌
- (CGFloat)boomPickerSafaVerticalBorder {
    return 0;
}


#pragma mark - (jianghongbao)inner methods for BoomPickerViewDataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponents {
    if (self.dataSource && [self.dataSource conformsToProtocol:@protocol(BoomPickerViewDataSource)]) {
        if ([self.dataSource respondsToSelector:@selector(numberOfComponentsInBoomPickerView:)]) {
            return [self.dataSource numberOfComponentsInBoomPickerView:self];
        }
    }
    return 0;
}

// returns the number of rows in each component..
- (NSInteger)numberOfRowsInComponent:(NSInteger)component {
    if (self.dataSource && [self.dataSource conformsToProtocol:@protocol(BoomPickerViewDataSource)]) {
        if ([self.dataSource respondsToSelector:@selector(boomPickerView:numberOfRowsInComponent:)]) {
            return [self.dataSource boomPickerView:self numberOfRowsInComponent:component];
        }
    }
    return 0;
}

- (nullable UIView *)contentViewForRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.dataSource && [self.dataSource conformsToProtocol:@protocol(BoomPickerViewDataSource)]) {
        if ([self.dataSource respondsToSelector:@selector(boomPickerView:contentViewForRow:inComponent:)]) {
            return [self.dataSource boomPickerView:self contentViewForRow:row inComponent:component];
        }
    }
    return nil;
}

#pragma mark - (jianghongbao)inner methods for BoomPickerViewDelegate

// returns width of column and height of row for each component.
- (CGFloat)widthForComponent:(NSInteger)component {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(BoomPickerViewDelegate)]) {
        if ([self.delegate respondsToSelector:@selector(boomPickerView:widthForComponent:)]) {
            return [self.delegate boomPickerView:self widthForComponent:component];
        }
    }
    return 0;
}

- (CGFloat)rowHeightForComponent:(NSInteger)component {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(BoomPickerViewDelegate)]) {
        if ([self.delegate respondsToSelector:@selector(boomPickerView:rowHeightForComponent:)]) {
            return [self.delegate boomPickerView:self rowHeightForComponent:component];
        }
    }
    return 0;
}

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (nullable NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(BoomPickerViewDelegate)]) {
        if ([self.delegate respondsToSelector:@selector(boomPickerView:titleForRow:forComponent:)]) {
            return [self.delegate boomPickerView:self titleForRow:row forComponent:component];
        }
    }
    return nil;
}

// attributed title is favored if both methods are implemented
- (nullable NSAttributedString *)boomPickerView:(BoomPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(BoomPickerViewDelegate)]) {
        if ([self.delegate respondsToSelector:@selector(boomPickerView:attributedTitleForRow:forComponent:)]) {
            return [self.delegate boomPickerView:self attributedTitleForRow:row forComponent:component];
        }
    }
    return nil;
}

- (UIView *)viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(BoomPickerViewDelegate)]) {
        if ([self.delegate respondsToSelector:@selector(boomPickerView:viewForRow:forComponent:reusingView:)]) {
            return [self.delegate boomPickerView:self viewForRow:row forComponent:component reusingView:view];
        }
    }
    return nil;
}

// didselect row in a component
- (void)boomPickerView:(BoomPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(BoomPickerViewDelegate)]) {
        if ([self.delegate respondsToSelector:@selector(boomPickerView:didSelectRow:inComponent:)]) {
            [self.delegate boomPickerView:self didSelectRow:row inComponent:component];
        }
    }
}

@end
