//
//  TMIOActionButtonCell.h
//  teamio
//

#import <UIKit/UIKit.h>

@protocol TMIOActionButtonCellDelegate;

@interface TMIOActionButtonCell : UITableViewCell

@property (weak, nonatomic) id<TMIOActionButtonCellDelegate> delegate;

@property (strong, nonatomic) NSString *titleLabelText;
@property (strong, nonatomic) NSString *subtitleLabelText;
@property (strong, nonatomic) NSString *actionButtonText;

@end


@protocol TMIOActionButtonCellDelegate <NSObject>

@required
- (void)didTouchActionButtonForCell:(TMIOActionButtonCell *)cell;

@end