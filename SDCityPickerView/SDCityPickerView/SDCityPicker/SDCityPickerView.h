//
//  SDCityPickerView.h
//  SDCityPickerView
//
//  Created by FENGYAN on 16/7/15.
//  Copyright © 2016年 Feng Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDCityPickerView;

@protocol SDCityPickerViewDelegate <NSObject>

/** 选择省市区代理方法 */
- (void)cityPickerView:(SDCityPickerView *)cityPickerView didFinishedSelectWithProvince:(NSString *)province city:(NSString *)city district:(NSString *)district;

@end

@interface SDCityPickerView : UIView

@property (weak,nonatomic) id<SDCityPickerViewDelegate> delegate;

/** 显示调用 */
- (void)show;

@end
