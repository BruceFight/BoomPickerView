//
//  BoomPickerColumnCell.m
//  BoomPickerView
//
//  Created by jianghongbao on 2021/3/25.
//

#import "BoomPickerColumnCell.h"

@implementation BoomPickerColumnCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.layer.masksToBounds = YES;
        return self;
    }
    return nil;
}

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setCustomContentView:(UIView *)customContentView {
    [customContentView removeFromSuperview];
    _customContentView = customContentView;
    [self.contentView addSubview: _customContentView];
}

- (void)setContent:(id<NSCopying,NSMutableCopying,NSSecureCoding>)content {
    _content = content;
    NSString *title = (NSString *)content;
    if (title) {
        self.textLabel.text = title;
        return;
    }
    NSAttributedString *attributeTitle = (NSAttributedString *)content;
    if (attributeTitle) {
        self.textLabel.attributedText = attributeTitle;
        return;
    }
    self.textLabel.text = nil;
    self.textLabel.attributedText = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _customContentView.frame = self.contentView.bounds;
    self.textLabel.frame = self.bounds;
}

@end
