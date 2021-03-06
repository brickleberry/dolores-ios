//
//  UITextField+Addition.m
//  CategoryCollection
//
//  Created by Heath on 27/03/2017.
//  Copyright © 2017 Heath. All rights reserved.
//

#import "UITextField+Addition.h"

@implementation UITextField (Addition)

+ (instancetype)textFieldWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    UITextField *textField = [[UITextField alloc] init];
    textField.font = font;
    textField.textColor = textColor;
    return textField;
}

+ (instancetype)textFieldWithFont:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)alignment {
    UITextField *textField = [UITextField textFieldWithFont:font textColor:textColor];
    textField.textAlignment = alignment;
    return textField;
}

+ (instancetype)textFieldWithFont:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)alignment placeholder:(NSString *)placeholder {
    UITextField *textField = [UITextField textFieldWithFont:font textColor:textColor textAlignment:alignment];
    textField.placeholder = placeholder;
    return textField;
}

+ (instancetype)textFieldWithFont:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)alignment placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType {
    UITextField *textField = [UITextField textFieldWithFont:font textColor:textColor textAlignment:alignment placeholder:placeholder];
    textField.keyboardType = keyboardType;
    return textField;
}

@end

@implementation UITextField (PaddingLabel)

-(void) setLeftPaddingText:(NSString *) paddingValue width:(CGFloat) width
{
    UILabel *paddingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
    paddingLabel.text = paddingValue;
    paddingLabel.font = [UIFont systemFontOfSize:14];
    self.leftView = paddingLabel;
    self.leftViewMode = UITextFieldViewModeAlways;
}

-(void) setRightPaddingText:(NSString *) paddingValue width:(CGFloat) width
{
    UILabel *paddingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
    paddingLabel.text = paddingValue;
    paddingLabel.font = [UIFont systemFontOfSize:14];
    self.rightView = paddingLabel;
    self.rightViewMode = UITextFieldViewModeAlways;
}

@end
