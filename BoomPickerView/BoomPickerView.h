//
//  BoomPickerView.h
//  BoomPickerView
//
//  Created by jianghongbao on 2021/3/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BoomPickerViewDelegate, BoomPickerViewDataSource;

@interface BoomPickerView : UIView

@property(nullable, nonatomic, weak)id<BoomPickerViewDelegate> delegate;
@property(nullable, nonatomic, weak)id<BoomPickerViewDataSource> dataSource;

@end

@protocol BoomPickerViewDataSource<NSObject>
@required

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInBoomPickerView:(BoomPickerView *)pickerView;

// returns the number of rows in each component..
- (NSInteger)boomPickerView:(BoomPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

@optional

- (nullable UIView *)boomPickerView:(BoomPickerView *)pickerView contentViewForRow:(NSInteger)row inComponent:(NSInteger)component;

@end

@protocol BoomPickerViewDelegate<NSObject>
@optional

// returns width of column and height of row for each component.
- (CGFloat)boomPickerView:(BoomPickerView *)pickerView widthForComponent:(NSInteger)component;
- (CGFloat)boomPickerView:(BoomPickerView *)pickerView rowHeightForComponent:(NSInteger)component;

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (nullable NSString *)boomPickerView:(BoomPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (nullable NSAttributedString *)boomPickerView:(BoomPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component; // attributed title is favored if both methods are implemented
- (UIView *)boomPickerView:(BoomPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view;

- (void)boomPickerView:(BoomPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end


NS_ASSUME_NONNULL_END
