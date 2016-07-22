//
//  TMIOUserProfileDataCell.m
//  teamio
//
//  Created by Aaron Schachter on 7/21/16.
//  Copyright © 2016 New School Old School. All rights reserved.
//

#import "TMIOUserProfileDataCell.h"

@interface TMIOUserProfileDataCell ()

@property (weak, nonatomic) IBOutlet UILabel *propertyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *propertyValueLabel;

@end


@implementation TMIOUserProfileDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPropertyNameLabelText:(NSString *)propertyNameLabelText {
    self.propertyNameLabel.text = propertyNameLabelText;
}

- (void)setPropertyValueLabelText:(NSString *)propertyValueLabelText {
    self.propertyValueLabel.textColor = [UIColor darkTextColor];
    if ([propertyValueLabelText isEqualToString:@""] || !propertyValueLabelText) {
        propertyValueLabelText = @"n/a";
        self.propertyValueLabel.textColor = [UIColor lightGrayColor];
    }
    self.propertyValueLabel.text = propertyValueLabelText;
}

@end
