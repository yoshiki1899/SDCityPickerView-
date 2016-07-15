//
//  SDCityPickerView.m
//  SDCityPickerView
//
//  Created by FENGYAN on 16/7/15.
//  Copyright © 2016年 Feng Yan. All rights reserved.
//

#import "SDCityPickerView.h"

#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define KAnimationTimeInterval 0.2f

@interface SDCityPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *myPickerView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) NSDictionary *totalDatas;

@end

@implementation SDCityPickerView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SDCityPickerView" owner:self options:nil] lastObject];
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        [self loadData];
    }
    return self;
}

// pickerView数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        
        return [self.totalDatas count];
        
    } else if (component == 1) {
        
        NSDictionary *provinceFather = [self.totalDatas valueForKey:[NSString stringWithFormat:@"%ld",(long)[pickerView selectedRowInComponent:0]]];
       
        NSDictionary *provinceDictionary = [provinceFather valueForKey:[[provinceFather allKeys] firstObject]];
        return [provinceDictionary count];
        
    } else {
        
        NSDictionary *provinceFather = [self.totalDatas valueForKey:[NSString stringWithFormat:@"%ld",(long)[pickerView selectedRowInComponent:0]]];
       
        NSDictionary *provinceDictionary = [provinceFather valueForKey:[[provinceFather allKeys] firstObject]];
       
        NSDictionary *cityDictionary = [provinceDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)[pickerView selectedRowInComponent:1]]];
      
        NSArray *districtArray = [cityDictionary valueForKey:[[cityDictionary allKeys] firstObject]];
        
        return [districtArray count];
    }
}

// 设置分组的宽
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return SCREEN_WIDTH / 3.0f;
}

// 行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 30;
}

//自定义显示视图
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3.0f, 30)];
    [desLabel setBackgroundColor:[UIColor clearColor]];
    [desLabel setTextAlignment:NSTextAlignmentCenter];
    [desLabel setFont:[UIFont systemFontOfSize:14]];
    
    // 省级父类的字典
    NSDictionary *provinceFather = [self.totalDatas valueForKey:[NSString stringWithFormat:@"%ld",(long)[pickerView selectedRowInComponent:0]]];
    // 省字典
    NSDictionary *provinceDictionary = [provinceFather valueForKey:[[provinceFather allKeys] firstObject]];
    // 市字典
    NSDictionary *cityDictionary = [provinceDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)[pickerView selectedRowInComponent:1]]];
    // 区数组
    NSArray *districtArray = [cityDictionary valueForKey:[[cityDictionary allKeys] firstObject]];
    
    if (component == 0) { // 第一组
        [desLabel setText:[[[self.totalDatas valueForKey:[NSString stringWithFormat:@"%ld", (long)row]] allKeys] firstObject]];
        return desLabel;
    } else if (component == 1) { // 第二组
        [desLabel setText:[[[provinceDictionary valueForKey:[NSString stringWithFormat:@"%ld", (long)row]] allKeys] firstObject]];
        return desLabel;
    } else { // 第三组
        if (districtArray.count <= row) {
            return nil;
        }
        [desLabel setText:districtArray[row]];
        return desLabel;
    }
}

// 单元格选中时的委托方法，需要注意的是，单元格的值改变后停止滚动动画停止即调用这个方法，不需要手点击
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) { // 更改第一组的省份之后要更新该省份的市/区
        [self.myPickerView reloadComponent:1];
        [self.myPickerView reloadComponent:2];
        [self.myPickerView selectRow:0 inComponent:1 animated:YES];
        [self.myPickerView selectRow:0 inComponent:2 animated:YES];
    } else if (component == 1){ // 更改第二组的市之后要更新该市的区
        [self.myPickerView reloadComponent:2];
        [self.myPickerView selectRow:0 inComponent:2 animated:YES];
    }
}

- (IBAction)sureButtonAction:(UIButton *)sender {
    
    /***********  核心代码区  ************/
    /* 省 */
    NSInteger provinceIndex = [self.myPickerView selectedRowInComponent:0];
    /* 市 */
    NSInteger cityIndex = [self.myPickerView selectedRowInComponent:1];
    /* 区 */
    NSInteger districtIndex = [self.myPickerView selectedRowInComponent:2];
    
    // 省级父类的字典
    NSDictionary *provinceFather = [self.totalDatas valueForKey:[NSString stringWithFormat:@"%ld",(long)provinceIndex]];
    // 省的名字
    NSString *selectedProvinceName = [[provinceFather allKeys] firstObject];
    // 省字典
    NSDictionary *provinceDictionary = [provinceFather valueForKey:selectedProvinceName];
    // 市字典
    NSDictionary *cityDictionary = [provinceDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)cityIndex]];
    // 市的名字
    NSString *selectedCityName = [[cityDictionary allKeys] firstObject];
    // 区数组
    NSArray *districtArray = [cityDictionary valueForKey:selectedCityName];
    // 区名字
    NSString *selectedDistrictName = districtArray[districtIndex];
    /***********  核心代码区  ************/
    
    if ([self.delegate respondsToSelector:@selector(cityPickerView:didFinishedSelectWithProvince:city:district:)]) {
        
        [self.delegate cityPickerView:self didFinishedSelectWithProvince:selectedProvinceName city:selectedCityName district:selectedDistrictName];
    }
    [self closeAnimation];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    
    [self closeAnimation];
}

- (void)closeAnimation {
    [UIView animateWithDuration:KAnimationTimeInterval animations:^{
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        CGRect frame = self.contentView.frame;
        frame.origin.y = SCREEN_HEIGHT;
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)loadData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"changeCity" ofType:@"plist"];
    self.totalDatas = [NSDictionary dictionaryWithContentsOfFile:path];
    [self.myPickerView selectRow:0 inComponent:0 animated:YES];
    [self.myPickerView selectRow:0 inComponent:1 animated:YES];
    [self.myPickerView selectRow:0 inComponent:2 animated:YES];
    [self.myPickerView reloadAllComponents];

}

- (void)show {
    self.frame = [[UIScreen mainScreen] bounds];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    CGRect frame = self.contentView.frame;
    frame.origin.y = SCREEN_HEIGHT;
    self.contentView.frame = frame;
    
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [UIView animateWithDuration:KAnimationTimeInterval animations:^{
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
        CGRect frame = self.contentView.frame;
        frame.origin.y = SCREEN_HEIGHT - frame.size.height;
        self.contentView.frame = frame;
    }];
}

@end
