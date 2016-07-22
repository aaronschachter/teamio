//
//  TMIOActionButtonCell.m
//  teamio
//

#import "TMIOActionButtonCell.h"

@interface TMIOActionButtonCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

- (IBAction)actionButtonTouchUpInside:(id)sender;

@end

@implementation TMIOActionButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.actionButton.backgroundColor = self.tintColor;
    self.actionButton.tintColor = [UIColor whiteColor];
}

- (void)setTitleLabelText:(NSString *)titleLabelText {
    self.titleLabel.text = titleLabelText;
}

- (void)setSubtitleLabelText:(NSString *)subtitleLabelText {
    self.subtitleLabel.text = subtitleLabelText;
}

- (void)setActionButtonText:(NSString *)actionButtonText {
    [self.actionButton setTitle:actionButtonText forState:UIControlStateNormal];
}

- (IBAction)actionButtonTouchUpInside:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchActionButtonForCell:)]) {
        [self.delegate didTouchActionButtonForCell:self];
    }
}

@end
