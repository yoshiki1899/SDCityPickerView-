# SDCityPickerView-
 城市选择器（包含子级别全部地区的选择）

项目中使用方法：
 1 import SDCityPickerView.h
 2 遵守代理SDCityPickerViewDelegate
 2 property SDCityPickerView
 3 在点击调用城市选择器的方法中展示SDCityPickerView [_pickerView show]
 4 实现代理方法，其中province, city, district分别对应一二三级地区
 
 核心代码：
 
 if (_pickerView == nil) {
        _pickerView = [[SDCityPickerView alloc]init];
        _pickerView.delegate = self;
    }
    
    [_pickerView show];
    ...
    
    - (void)cityPickerView:(id)cityPickerView didFinishedSelectWithProvince:(NSString *)province city:(NSString *)city district:(NSString *)district
{
    _adressLable.text = [NSString stringWithFormat:@"%@-%@-%@", province, city, district];
}
