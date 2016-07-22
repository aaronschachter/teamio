//
//  TMIOUserProfileHeaderCell.m
//  teamio
//

#import "TMIOUserProfileHeaderCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TMIOUserProfileHeaderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation TMIOUserProfileHeaderCell

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.contentView.backgroundColor = backgroundColor;
}

- (void)setProfileImageViewURLString:(NSString *)profileImageViewURLString {
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:profileImageViewURLString] placeholderImage:[UIImage imageNamed:@"slackbox"]];
}

- (void)setUserNameLabelText:(NSString *)userNameLabelText {
    self.userNameLabel.text = userNameLabelText;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.profileImageView.layer.cornerRadius = 70;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth=2.0;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.borderColor=[[UIColor whiteColor] CGColor];
}

@end
