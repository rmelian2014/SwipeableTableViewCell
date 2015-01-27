#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SwipeableTableViewCellSide) {
    SwipeableTableViewCellSideLeft,
    SwipeableTableViewCellSideRight,
};

extern NSString *const kSwipeableTableViewCellHideButtonsEvent;
/**
 * The maximum number of milliseconds that closing the buttons may take after release.
 *
 * If the time for the buttons to be hidden exceeds this number, they will be animated
 * to close quickly.
 */
extern CGFloat const kSwipeableTableViewCellMaxCloseMilliseconds;
/**
 * The minimum velocity required to open buttons if released before completely open.
 */
extern CGFloat const kSwipeableTableViewCellOpenVelocityThreshold;

@interface SwipeableTableViewCell : UITableViewCell <UIScrollViewDelegate>

@property (nonatomic, readonly) CGFloat leftInset;
@property (nonatomic, readonly) CGFloat rightInset;
@property (nonatomic, weak) UIView *scrollViewContentView;
@property (nonatomic, weak) UILabel *scrollViewLabel;

+ (void)hideAllButtons;
- (UIButton *)createButtonWithWidth:(CGFloat)width onSide:(SwipeableTableViewCellSide)side;
- (void)hideButtons;

@end
