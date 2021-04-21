//
//  BoomPickerColumnView.h
//  BoomPickerView
//
//  Created by jianghongbao on 2021/3/25.
//

#import <UIKit/UIKit.h>
#import "BoomPickerColumManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BoomPickerColumnView : UIView

@property(nonatomic, strong, readonly)BoomPickerColumManager *manager;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
