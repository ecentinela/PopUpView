#import <UIKit/UIKit.h>

#pragma mark - PopUpView

@interface PopUpView : UIView
{
  UIView *_originalAddToView;
  UIView *_contentView;
  UIView *_view;
  UILabel *_label;
}

// constructor
- (PopUpView *) initForView:(UIView *)addToView withLabelText:(NSString *)labelText andView:(UIView *)view;

// remove the view with animation
- (void) animateRemove;

// set the label text. if there isn't a label it will be created
- (void) setLabelText:(NSString *)labelText;

// set the label view
- (void) setLabel:(UILabel *)label;

// set the image/icon view
- (void) setView:(UIView *)view;

// appear a new popupview with a label and an image/icon view
+ (void) appearOnView:(UIView *)addToView withLabelText:(NSString *)labelText andView:(UIView *)view;

// make dissapear the singleton popupview
+ (void) dissapear;

@end

// extend popupview with an empty category to use as private methods
@interface PopUpView();

// show the view with animation
- (void) animateShow;

// remove the view
- (void) remove;

// get the view where to add the popupview
- (UIView *) getViewForView:(UIView *)view;

// get the frame for the view
- (CGRect) getEnclosingFrame;

// setup the view content
- (void) setupContentView;

// setup the view
- (void) setupView;

// setup the background
- (void) setupBackground;

// setup the view frames
- (void) setFrames;

// get a new label object
- (UILabel *) label:(NSString *)labelText;

@end

#pragma mark - Extend UIApplication

@interface UIApplication (KeyboardView)

- (UIView *)keyboardView;

@end
