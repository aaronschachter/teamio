//
//  TMIOUserProfileHeaderCell.h
//  teamio
//

#import <UIKit/UIKit.h>

@interface TMIOUserProfileHeaderCell : UITableViewCell

@property (strong, nonatomic, readwrite) NSString *profileImageViewURLString;
@property (strong, nonatomic, readwrite) NSString *userNameLabelText;
@property (strong, nonatomic) UIColor *backgroundColor;

@end
