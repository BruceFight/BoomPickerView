//
//  ViewController.m
//  BoomPickerView
//
//  Created by jianghongbao on 2021/3/25.
//

#import "ViewController.h"
#import "BoomPickerView.h"

@interface ViewController ()
<
BoomPickerViewDelegate,
BoomPickerViewDataSource,
UIPickerViewDelegate,
UIPickerViewDataSource
>

@property(nonatomic, strong)BoomPickerView *boomPickerView;
@property(nonatomic, strong)UIPickerView *sysPickerView;
@property(nonatomic, strong)UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureBoomPickerView];
    [self configureSystemPickerView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.boomPickerView.frame = CGRectMake(0, 0, 200, 300);
    self.sysPickerView.frame = CGRectMake(0, CGRectGetMaxY(self.boomPickerView.frame), CGRectGetWidth(self.boomPickerView.frame), 300);
    self.collectionView.frame = CGRectMake(CGRectGetMaxX(self.boomPickerView.frame), 0, 200, 300);
}

#pragma mark - (jianghongbao)BoomPickerView

- (void)configureBoomPickerView {
    self.boomPickerView = [[BoomPickerView alloc] init];
    self.boomPickerView.delegate = self;
    self.boomPickerView.dataSource = self;
    [self.view addSubview:self.boomPickerView];
}

- (NSInteger)numberOfComponentsInBoomPickerView:(BoomPickerView *)pickerView {
    return 2;
}

- (NSInteger)boomPickerView:(BoomPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 12;
    }
    return 3;
}

- (CGFloat)boomPickerView:(BoomPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 90;
}


#pragma mark - (jianghongbao)System UIPickerView

- (void)configureSystemPickerView {
    self.sysPickerView = [[UIPickerView alloc] init];
    self.sysPickerView.delegate = self;
    self.sysPickerView.dataSource = self;
    [self.view addSubview:self.sysPickerView];
    
    // 💣牛批 找到Picker内置方法并禁止滚动时滴答音效
//    SEL sse = NSSelectorFromString([NSString stringWithFormat:@"%@%@%@", @"set",@"Sounds",@"Enabled:"]);
//    if ([UIPickerView instancesRespondToSelector:sse]) {
//        IMP sseimp = [UIPickerView instanceMethodForSelector:sse];
//        if (sseimp) {
//            ((void (*)(id, SEL, BOOL))sseimp)(self.sysPickerView, sse, NO);
//        }
//    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 1) {
        return 15;
    }
    return 3;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = nil;
    if ([view isKindOfClass:[UILabel class]]) {
        label = (UILabel *)view;
    } else {
        label = [UILabel new];
    }
    label.text = [NSString stringWithFormat:@"%@", @(row)];
    label.backgroundColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 100;
}

//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
//    return 60;
//}

@end
