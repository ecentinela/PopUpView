#import "PopUpView.h"
#import <QuartzCore/QuartzCore.h>

static PopUpView *popUpView = nil;

@implementation PopUpView

#pragma mark - Private methods

// constructor
- (PopUpView *) initForView:(UIView *)addToView withLabelText:(NSString *)labelText andView:(UIView *)view
{
    // store params
    _originalAddToView = addToView;
    _view = view;
    _label = [self label:labelText];
    
    // initialize
    self = [super initWithFrame:CGRectZero];
    
    if (!self)
    {
        return nil;
    }
    
    // where to add the view
    addToView = [self getViewForView:addToView];
    
    // add the view
    [addToView addSubview:self];
    
    // setup the content view
    [self setupContentView];
    
    // add the content view
    [self addSubview:_contentView];
    
    // set the frame
    self.frame = [self getEnclosingFrame];
    
    // setup the view
    [self setupView];
    
    // set up the window background
    [self setupBackground];
    
    // show the view
    [self animateShow];
    
    return self;
}

// remove the view with animation
- (void) animateRemove
{
    _contentView.transform = CGAffineTransformIdentity;
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(remove:)];
    _contentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.alpha = 0.0;
	[UIView commitAnimations];
}

// set the label text. if there isn't a label it will be created
- (void) setLabelText:(NSString *)labelText
{
    if (_label)
    {
        _label.text = labelText;
        
        [self setFrames];
    }
    else
    {
        [self setLabel:[self label:labelText]];
    }
}

// set the label view
- (void) setLabel:(UILabel *)label
{
    [_label removeFromSuperview];
    
    _label = label;
    [_contentView addSubview:_label];
    
    [self setFrames];
}

// set the image/icon view
- (void) setView:(UIView *)view
{
    [_view removeFromSuperview];
    
    _view = view;
    [_contentView addSubview:_view];
    
    [self setFrames];
}

#pragma mark - Singleton methods

// appear a singleton popupview
+ (void) appearOnView:(UIView *)addToView withLabelText:(NSString *)labelText andView:(UIView *)view
{
    popUpView = [[PopUpView alloc] initForView:addToView withLabelText:labelText andView:view];
}

// make dissapear the singleton popupview
+ (void) dissapear
{
    [popUpView animateRemove];
}

#pragma mark - Private methods

// show the view
- (void) animateShow
{
    self.alpha = 0.0;
    _contentView.transform = CGAffineTransformMakeScale(3.0, 3.0);
    
	[UIView beginAnimations:nil context:nil];
    _contentView.transform = CGAffineTransformIdentity;
    self.alpha = 1.0;
	[UIView commitAnimations];
}

// remove the view
- (void) remove
{
    [self removeFromSuperview];
    
    _originalAddToView = nil;
    _contentView = nil;
    _view = nil;
    _label = nil;
}

// get the view where to add the popupview
- (UIView *) getViewForView:(UIView *)view
{
    UIView *keyboardView = [[UIApplication sharedApplication] keyboardView];
    return keyboardView ? keyboardView.superview : view;
}

// get the frame for the view
- (CGRect) getEnclosingFrame;
{
    // take care when the keyboard is visible
    return self.superview == _originalAddToView ?
    self.superview.bounds :
    [_originalAddToView convertRect:_originalAddToView.bounds toView:self.superview];
}

// setup the view content
- (void) setupContentView
{
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _contentView.layer.cornerRadius = 10.0;
}

// setup the view
- (void) setupView
{
    [_contentView addSubview:_view];
    [_contentView addSubview:_label];
    
    [self setFrames];
}

// setup the background
- (void) setupBackground
{
	self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
}

// setup the view frames
- (void) setFrames
{
    CGRect viewFrame = _view.frame;
    CGRect labelFrame = _label.frame;
    CGRect frame = CGRectZero;
    
    CGSize maxSize = CGSizeMake(260, 400);
    CGSize textSize = [_label.text sizeWithFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]] constrainedToSize:maxSize lineBreakMode:_label.lineBreakMode];
    
    // require that the label be at least as wide as the view, since that width is used for the border view:
    if (textSize.width < viewFrame.size.width)
    {
        textSize.width = viewFrame.size.width + 10;
    }
    
    // if there's no label text, don't need to allow height for it:
    if (_label.text.length == 0)
    {
        textSize.height = 0;
    }
    
    // fix the label frame size
    labelFrame = CGRectMake(labelFrame.origin.x, labelFrame.origin.y, textSize.width, textSize.height);
    _label.frame = labelFrame;
    
    // set view frames
    frame.size.width = 30.0 + textSize.width;
    frame.size.height = 40.0 + viewFrame.size.height + textSize.height;
    frame.origin.x = floor(0.5 * (self.frame.size.width - frame.size.width));
    frame.origin.y = floor(0.5 * (self.frame.size.height - frame.size.height));
    _contentView.frame = frame;  
    
	viewFrame.origin.x = 0.5 * (frame.size.width - viewFrame.size.width);
	viewFrame.origin.y = 20.0;
    _view.frame = viewFrame;
    
    labelFrame.origin.x = 0.5 * (frame.size.width - labelFrame.size.width);
    labelFrame.origin.y = _view ? 30.0 + viewFrame.size.height : 20;
    _label.frame = labelFrame;
}

// get a new label object
- (UILabel *) label:(NSString *)labelText
{
    UILabel *label = [[UILabel alloc] init];
    
    label.text = labelText;
    label.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.lineBreakMode = UILineBreakModeWordWrap;
    
    return label;
}

@end

#pragma mark - Extend UIApplication

@implementation UIApplication (KeyboardView)

//  keyboardView
//
//  Copyright Matt Gallagher 2009. All rights reserved.
// 
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.

- (UIView *)keyboardView;
{
	NSArray *windows = [self windows];
	for (UIWindow *window in [windows reverseObjectEnumerator])
	{
		for (UIView *view in [window subviews])
		{
            // UIPeripheralHostView is used from iOS 4.0, UIKeyboard was used in previous versions:
			if (!strcmp(object_getClassName(view), "UIPeripheralHostView") || !strcmp(object_getClassName(view), "UIKeyboard"))
			{
				return view;
			}
		}
	}
	
	return nil;
}

@end
