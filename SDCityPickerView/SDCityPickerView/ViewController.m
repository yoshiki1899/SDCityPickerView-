//
//  ViewController.m
//  SDCityPickerView
//
//  Created by FENGYAN on 16/7/15.
//  Copyright © 2016年 Feng Yan. All rights reserved.
//

/*
 项目中使用方法：
 1 import SDCityPickerView.h
 2 遵守代理SDCityPickerViewDelegate
 2 property SDCityPickerView
 3 在点击调用城市选择器的方法中展示SDCityPickerView [_pickerView show]
 4 实现代理方法，其中province, city, district分别对应一二三级地区
 */

#import "ViewController.h"
#import "SDCityPickerView.h"

@interface ViewController ()<SDCityPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *adressLable;
@property (strong,nonatomic) SDCityPickerView *pickerView;
@end

@implementation ViewController

- (IBAction)touchBtn:(id)sender {
    
    if (_pickerView == nil) {
        _pickerView = [[SDCityPickerView alloc]init];
        _pickerView.delegate = self;
    }
    
    [_pickerView show];
}

- (void)cityPickerView:(id)cityPickerView didFinishedSelectWithProvince:(NSString *)province city:(NSString *)city district:(NSString *)district
{
    _adressLable.text = [NSString stringWithFormat:@"%@-%@-%@", province, city, district];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
