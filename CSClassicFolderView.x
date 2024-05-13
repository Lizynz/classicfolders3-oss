#import "Headers.h"
#import "CSClassicFolderTextField.h"

#define isModern [[CSClassicFolderSettingsManager sharedInstance] modern]
#define isClassic [[CSClassicFolderSettingsManager sharedInstance] classic]
#define isLegacy [[CSClassicFolderSettingsManager sharedInstance] legacy]

static const char *kCSFolderOpenIdentifier;
static const char *kCSFolderMagnificationFractionIdentifier;
static const char *kCSFolderArrowViewIdentifier;
static const char *kCSFolderArrowBackgroundViewIdentifier;
static const char *kCSFolderArrowShadowViewIdentifier;
static const char *kCSFolderArrowBorderViewIdentifier;
static const char *kCSFolderControllerIdentifier;
static const char *kCSFolderBackgroundViewIdentifier;
static const char *kCSFolderGestureViewIdentifier;
static const char *kCSFolderLabelViewIdentifier;
static const char *kCSFolderLabelEditViewIdentifier;
static const char *kCSFolderIconViewIdentifier;
static const char *kCSFolderContainerViewIdentifier;
static const char *kCSFolderTopLineLeftIdentifier;
static const char *kCSFolderTopLineRightIdentifier;

@interface CSClassicFolderViewState: NSObject
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) CGFloat magnificationFraction;
@property (nonatomic, strong) UIView *arrowView;
@property (nonatomic, strong) UIView *arrowBackgroundView;
@property (nonatomic, strong) UIView *arrowShadowView;
@property (nonatomic, strong) UIView *arrowBorderView;

@property (nonatomic, strong) SBFolderController *folderController;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *gestureView;
@property (nonatomic, strong) UILabel *labelView;
@property (nonatomic, strong) UITextField *labelTextField;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *topLineLeft;
@property (nonatomic, strong) UIView *topLineRight;
@end

BOOL isFlipped;

%subclass CSClassicFolderView : SBFolderView

%new
- (void)classicFolderInitWithFolder:(SBFolder *)folder orientation:(int)orientation {
	dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		if (!selfVerify()){
			safeMode();
		}
		if (!deepVerifyUDID()){
			safeMode();
		}
	});

	UIView *scalingView = [self valueForKey:@"_scalingView"];

	CGRect wantedFrame = [self wantedFrame];
	wantedFrame.size.height = 0;

	UIView *containerView = [[UIView alloc] initWithFrame:wantedFrame];
	scalingView.frame = self.bounds;
	[containerView setClipsToBounds:YES];
	[self setContainerView:containerView];

	SBIconController *controller = [%c(SBIconController) sharedInstance];
	SBIconViewMap *homescreenMap = homescreenMap = [%c(SBIconViewMap) homescreenMap];

	if (isModern){
        UIVisualEffectView *backView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]];
        backView.layer.cornerRadius = 15;
        backView.clipsToBounds = YES;
        [containerView addSubview:backView];
        [self setBackdropView:[backView autorelease]];
	} else {
		UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectZero];
		if (isLegacy){
			if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad)
				[backView setImage:[[UIImage classicFolderImageNamed:@"iOS 4/FolderSwitcherBG~iphone"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,152,0,152) resizingMode:UIImageResizingModeTile]];
			else
				[backView setImage:[[UIImage classicFolderImageNamed:@"iOS 4/FolderSwitcherBG~ipad"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,288,0,288) resizingMode:UIImageResizingModeTile]];
		} else if (isClassic){
			if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad)
                [backView setImage:[[UIImage classicFolderImageNamed:@"FolderSwitcherBG~iphone"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,152,0,152) resizingMode:UIImageResizingModeTile]];
            else
                [backView setImage:[[UIImage classicFolderImageNamed:@"FolderSwitcherBG~ipad"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,288,0,288) resizingMode:UIImageResizingModeTile]];
		} else {
			[backView setImage:[[UIImage classicFolderImageNamed:@"Mavericks/BGGradient"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,159,0,159)]];
		}
		[backView setClipsToBounds:YES];
		[containerView addSubview:backView];
		[self setBackdropView:backView];
		[backView release];
	}

	if (!verifyUDID())
		safeMode();

	CGFloat adjust = 0.0f;
	if ([[UIScreen mainScreen] bounds].size.width > 320){
		if (isModern)
			adjust = 11.0f;
		else
			adjust = 0.0f;
	} else {
		if (isModern)
			adjust = 5.0f;
	}
	if (isModern){
        UIVisualEffectView *arrowView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]];
        arrowView.clipsToBounds = YES;
        arrowView.frame = CGRectMake(0, 0, 38, 12);
		
		CALayer *arrowViewMask = [CALayer layer];
		arrowViewMask.frame = arrowView.bounds;
		if (isFlipped){
			UIImage *arrowImage = [UIImage classicFolderImageNamed:@"ClassicFolderTop"];
			arrowImage = [self flipImage:arrowImage];
			[arrowViewMask setContents:(id)arrowImage.CGImage];
		} else
			[arrowViewMask setContents:(id)[UIImage classicFolderImageNamed:@"ClassicFolderTop"].CGImage];
		[arrowView.layer setMask:arrowViewMask];

		[containerView addSubview:arrowView];
		[self setArrowView:[arrowView autorelease]];
	} else {
		CGRect arrowFrame = CGRectMake(0, 0, 24, 12);

		UIImageView *arrowView = [[UIImageView alloc] initWithFrame:arrowFrame];
		if (isLegacy){
			if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad)
				[arrowView setImage:[[UIImage classicFolderImageNamed:@"iOS 4/FolderSwitcherBG~iphone"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile]];
			else
				[arrowView setImage:[[UIImage classicFolderImageNamed:@"iOS 4/FolderSwitcherBG~ipad"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile]];
		} else if (isClassic){
			if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad)
                [arrowView setImage:[[UIImage classicFolderImageNamed:@"FolderSwitcherBG~iphone"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile]];
            else
                [arrowView setImage:[[UIImage classicFolderImageNamed:@"FolderSwitcherBG~ipad"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile]];
		} else {
			UIImageView *arrowBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(-arrowView.frame.origin.x,0,[self backdropView].frame.size.width,12)];
			[arrowBackgroundView setImage:[[UIImage classicFolderImageNamed:@"Mavericks/BGGradient"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,159,0,159)]];
			[arrowView addSubview:[arrowBackgroundView autorelease]];
			[self setArrowBackgroundView:arrowBackgroundView];
		}
		arrowView.contentMode = UIViewContentModeTop;

		CALayer *arrowViewMask = [CALayer layer];
		arrowViewMask.frame = arrowView.bounds;
		if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad){
			if (isFlipped){
				UIImage *arrowImage = [UIImage classicFolderImageNamed:@"FolderMaskTopNotch~iphone"];
				arrowImage = [self flipImage:arrowImage];
				[arrowViewMask setContents:(id)arrowImage.CGImage];
			} else
				[arrowViewMask setContents:(id)[UIImage classicFolderImageNamed:@"FolderMaskTopNotch~iphone"].CGImage];
		} else {
			if (isFlipped){
				UIImage *arrowImage = [UIImage classicFolderImageNamed:@"FolderMaskTopNotch~ipad"];
				arrowImage = [self flipImage:arrowImage];
				[arrowViewMask setContents:(id)arrowImage.CGImage];
			} else
				[arrowViewMask setContents:(id)[UIImage classicFolderImageNamed:@"FolderMaskTopNotch~ipad"].CGImage];
		}
		[arrowView.layer setMask:arrowViewMask];
		[arrowView setClipsToBounds:YES];
		[containerView addSubview:arrowView];
		[self setArrowView:arrowView];
		[arrowView release];

		UIImageView *arrowShadowView = [[UIImageView alloc] initWithFrame:arrowFrame];
		if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad){
			if (isFlipped){
				[arrowShadowView setImage:[self flipImage:[UIImage imageNamed:@"FolderShadowTopNotch~iphone"]]];
			} else {
				[arrowShadowView setImage:[UIImage imageNamed:@"FolderShadowTopNotch~iphone"]];
			}
		} else {
			if (isFlipped){
				[arrowShadowView setImage:[self flipImage:[UIImage imageNamed:@"FolderShadowTopNotch~ipad"]]];
			} else {
				[arrowShadowView setImage:[UIImage imageNamed:@"FolderShadowTopNotch~ipad"]];
			}
		}
		if (isFlipped)
			arrowShadowView.contentMode = UIViewContentModeBottom;
		else
			arrowShadowView.contentMode = UIViewContentModeTop;
		[arrowShadowView setClipsToBounds:YES];
		[containerView addSubview:arrowShadowView];
		[self setArrowShadowView:arrowShadowView];
		[arrowShadowView release];

		if (!verifyUDID())
			safeMode();

		UIImageView *arrowBorderView = [[UIImageView alloc] initWithFrame:arrowFrame];
		if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad){
			if (isFlipped){
				[arrowBorderView setImage:[self flipImage:[UIImage classicFolderImageNamed:@"FolderBorderTopNotch~iphone"]]];
			} else {
				[arrowBorderView setImage:[UIImage classicFolderImageNamed:@"FolderBorderTopNotch~iphone"]];
			}
		} else {
			if (isFlipped){
				[arrowBorderView setImage:[self flipImage:[UIImage classicFolderImageNamed:@"FolderBorderTopNotch~ipad"]]];
			} else {
				[arrowBorderView setImage:[UIImage classicFolderImageNamed:@"FolderBorderTopNotch~ipad"]];
			}
		}
		if (isFlipped)
			arrowBorderView.contentMode = UIViewContentModeBottom;
		else
			arrowBorderView.contentMode = UIViewContentModeTop;
		[arrowBorderView setClipsToBounds:YES];
		[containerView addSubview:arrowBorderView];
		[self setArrowBorderView:arrowBorderView];
		[arrowBorderView release];

		UIImageView *topShadow = [[UIImageView alloc] initWithFrame:CGRectMake(adjust,isFlipped ? 0 : 12,wantedFrame.size.width,26)];
		topShadow.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad){
			[topShadow setImage:[UIImage imageNamed:@"FolderShadowTop~iphone"]];
		} else {
			[topShadow setImage:[UIImage imageNamed:@"FolderShadowTop~ipad"]];
		}
		[containerView addSubview:topShadow];
		[topShadow release];

		UIImageView *bottomShadow = [[UIImageView alloc] initWithFrame:CGRectMake(adjust,isFlipped ? containerView.bounds.size.height-(33+12) : containerView.bounds.size.height - 33,wantedFrame.size.width,33)];
		bottomShadow.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
		if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad)
			[bottomShadow setImage:[UIImage imageNamed:@"FolderShadowBottom~iphone"]];
		else
			[bottomShadow setImage:[UIImage imageNamed:@"FolderShadowBottom~ipad"]];
		[containerView addSubview:bottomShadow];
		[bottomShadow release];

		UIView *topLineLeft = [[UIView alloc] initWithFrame:CGRectMake(adjust,isFlipped ? containerView.bounds.size.height-(arrowFrame.size.height) : arrowFrame.size.height - 1,arrowFrame.origin.x,1)];
		[topLineLeft setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.4]];
		if (isFlipped)
			topLineLeft.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
		else
			topLineLeft.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
		[self setTopLineLeft:topLineLeft];
		[containerView addSubview:[topLineLeft autorelease]];

		UIView *topLineRight = [[UIView alloc] initWithFrame:CGRectMake(arrowFrame.origin.x + arrowFrame.size.width,isFlipped ? containerView.bounds.size.height-(arrowFrame.size.height) : arrowFrame.size.height -1 , containerView.frame.size.width - (arrowFrame.origin.x + arrowFrame.size.width),1)];
		[topLineRight setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.4]];
		if (isFlipped)
			topLineRight.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
		else
			topLineRight.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
		[self setTopLineRight:topLineRight];
		[containerView addSubview:[topLineRight autorelease]];

        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(adjust,isFlipped ? 0 : containerView.bounds.size.height-1,wantedFrame.size.width,1)];
        [bottomLine setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.4]];
        if (isFlipped)
            bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        else
            bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [containerView addSubview:[bottomLine autorelease]];
	}

	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:[[self folder] displayName]];
    if (isModern)
        [titleLabel setFont:[UIFont systemFontOfSize:20.0]];
    else
        [titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
    [self setLabelView:titleLabel];
    [containerView addSubview:[titleLabel autorelease]];

    if (!verifyUDID())
		safeMode();

    UITextField *labelEditView = [[CSClassicFolderTextField alloc] initWithFrame:CGRectZero];
    [labelEditView setText:[[self folder] displayName]];
    if (isModern)
        [labelEditView setFont:[UIFont systemFontOfSize:20.0]];
    else
        [labelEditView setFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
    [labelEditView setAlpha:0.0];
    //[labelEditView setBorderStyle:UITextBorderStyleRoundedRect];

    UIButton *clearButton = [labelEditView valueForKey:@"_clearButton"];

    if (isModern){
    	[labelEditView setBackground:[[UIImage classicFolderImageNamed:@"Modern_textfield_BG"] resizableImageWithCapInsets:UIEdgeInsetsMake(13,8,13,8)]];
    	[labelEditView setTextColor:[UIColor whiteColor]];

    	[clearButton setImage:[UIImage classicFolderImageNamed:@"Modern_X"] forState:UIControlStateNormal];
    } else if (isClassic){
    	[labelEditView setBackground:[[UIImage classicFolderImageNamed:@"iOS6_textfield_BG"] resizableImageWithCapInsets:UIEdgeInsetsMake(13,13,13,13)]];
    
    	[clearButton setImage:[UIImage classicFolderImageNamed:@"iOS6_X"] forState:UIControlStateNormal];
    } else {
    	[labelEditView setBackground:[[UIImage classicFolderImageNamed:@"Mavericks/Mavericks_textfield_BG"] resizableImageWithCapInsets:UIEdgeInsetsMake(13,13,13,13)]];
    
    	[clearButton setImage:[UIImage classicFolderImageNamed:@"Mavericks/Mavericks_X"] forState:UIControlStateNormal];
    }
    [labelEditView setClearButtonMode:UITextFieldViewModeAlways];
    [labelEditView setDelegate:self];
    [self setLabelEditView:labelEditView];
    [containerView addSubview:[labelEditView autorelease]];

	UIScrollView *scrollView = [self scrollView];
	[containerView addSubview:scrollView];
	[containerView bringSubviewToFront:scrollView];

	[scalingView addSubview:[containerView autorelease]];

	objc_setAssociatedObject(self, &kCSFolderOpenIdentifier, [NSNumber numberWithBool:NO], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self setMagnificationFraction:0.0f];

}

- (CSClassicFolderView *)initWithConfiguration:(SBFolderControllerConfiguration *)configuration {
	self = %orig;
	[self classicFolderInitWithFolder:configuration.folder orientation:configuration.orientation];
	return self;
}

- (Class)listViewClass {
	return %c(SBFolderIconListView);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == [self labelEditView]){
		[textField resignFirstResponder];
		[self _setFolderName:[textField text]];
		return NO;
	} else {
		return %orig;
	}
}

%new;
- (UIImage *)flipImage:(UIImage *)image
{
	CGImageRef cgImage = image.CGImage;
    UIGraphicsBeginImageContext(CGSizeMake(CGImageGetWidth(cgImage),CGImageGetHeight(cgImage)));
    CGContextDrawImage(UIGraphicsGetCurrentContext(),CGRectMake(0.,0., CGImageGetWidth(cgImage), CGImageGetHeight(cgImage)),image.CGImage);
    UIImage *i = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return i;
}

%new;
- (NSInteger)getMaximumIconRowsForPages {
	NSInteger iconRows = 0;

	CGFloat maxIconColumns = [[self currentIconListView] iconColumnsForCurrentOrientation];
	CGFloat maxIconRows = [[self currentIconListView] iconRowsForCurrentOrientation];

	if ([self isEditing])
		return maxIconRows;

	NSArray *iconListViews = [self iconListViews];
	for (SBIconListView *iconListView in iconListViews){
		NSArray *icons = [iconListView visibleIcons];
		NSInteger rowsOfIcons = ceilf([icons count]/maxIconColumns);

		if (rowsOfIcons > maxIconRows)
			rowsOfIcons = maxIconRows;
		if (rowsOfIcons > iconRows)
			iconRows = rowsOfIcons;
	}
	return iconRows;
}

%new;
- (NSArray *)getVisibleViewsUnderFolder {
    if (!verifyUDID())
        safeMode();
    SBRootFolderController *rootFolderController = [[%c(SBIconController) sharedInstance] _rootFolderController];
    UIView *rootContentView = [[rootFolderController contentView] _currentIconListView];
    NSMutableArray *views = [rootContentView.subviews mutableCopy];
    if (![[[self folderIconView] location] containsString:@"Dock"]){
        UIView *dockView = [[rootFolderController contentView] dockView];
        if (dockView != nil)
            [views addObject:dockView];
        UIView *pageControl = [[rootFolderController contentView] valueForKey:@"_pageControl"];
        if (pageControl != nil)
            [views addObject:pageControl];
    }
    return [views autorelease];
}

%new;
- (void)openFolder:(BOOL)animated completion:(void (^)(BOOL completed))completion {
	if ([objc_getAssociatedObject(self, &kCSFolderOpenIdentifier) boolValue])
		return;

	UIView *scalingView = [self valueForKey:@"_scalingView"];

	self.superview.clipsToBounds = NO;
	UIView *containerView = [self containerView];

	SBIconView *folderIconView = [self folderIconView];
    BOOL isFlipped = [[[self folderIconView] location] containsString:@"Dock"];

	SBRootFolderController *rootFolderController = [[%c(SBIconController) sharedInstance] _rootFolderController];
	SBRootFolderView *rootContentView = [rootFolderController contentView];
	[rootContentView setClassicFolderInDock:isFlipped];
    
//    for (SBIconListView *iconListView in [rootContentView iconListViews]) {
//        if (![iconListView isEqual:[self currentIconListView]]) {
//            [UIView animateWithDuration:0.0 animations:^{
//                [iconListView setAlpha:0.5];
//            }];
//        }
//    }

	[self layoutSubviews];

	objc_setAssociatedObject(self, &kCSFolderOpenIdentifier, [NSNumber numberWithBool:YES], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

	UIView *gestureView = [[UIView alloc] initWithFrame:self.frame];

	UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
	recognizer.numberOfTapsRequired = 1;
	recognizer.numberOfTouchesRequired = 1;
	[gestureView addGestureRecognizer:[recognizer autorelease]];

	gestureView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	[self setGestureView:gestureView];
	[scalingView insertSubview:[gestureView autorelease] belowSubview:containerView];

	float animTime = ((float)[self getMaximumIconRowsForPages] * 0.25);
	if (animTime > 0.4)
		animTime = 0.4;
	animTime *= [[CSClassicFolderSettingsManager sharedInstance] speedMultiplier];
	[UIView animateWithDuration:animated? animTime : 0.0
		animations:^(void){
			SBIconContentView *iconContentView = [(SBIconController *)[%c(SBIconController) sharedInstance] contentView];
			[iconContentView setClassicFolderIsOpen:YES];
        
        UIView *pageControl = [[rootFolderController contentView] valueForKey:@"_pageControl"];
        if ([[[self folderIconView] location] containsString:@"Dock"]) {
            pageControl.alpha = 0;
            
            if (@available(iOS 16, *)) {
                SBHSearchPillView *searchPillView = [[rootFolderController contentView] valueForKey:@"_pageControl"];
                UIView *superview = searchPillView.superview;
                superview.hidden = YES;
            }
        } else {
            pageControl.alpha = 0;
            
            if (@available(iOS 16, *)) {
                SBHSearchPillView *searchPillView = [[rootFolderController contentView] valueForKey:@"_pageControl"];
                UIView *superview = searchPillView.superview;
                superview.hidden = YES;
            }
        }

        [self layoutSubviews];
	} completion:completion];
}

%new;
- (void)closeFolder:(BOOL)animated completion:(void (^)(BOOL completed))completion {
	if (![objc_getAssociatedObject(self, &kCSFolderOpenIdentifier) boolValue])
		return;

	objc_setAssociatedObject(self, &kCSFolderOpenIdentifier, [NSNumber numberWithBool:NO], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

	SBIconView *folderIconView = [self folderIconView];

	SBRootFolderController *rootFolderController = [[%c(SBIconController) sharedInstance] _rootFolderController];
	SBRootFolderView *rootContentView = [rootFolderController contentView];
    
//    for (SBIconListView *iconListView in [rootContentView iconListViews]) {
//        if (![iconListView isEqual:[self currentIconListView]]) {
//            [UIView animateWithDuration:0.0 animations:^{
//                [iconListView setAlpha:1.0];
//            }];
//        }
//    }

	float animTime = ((float)[self getMaximumIconRowsForPages] * 0.25);
	if (animTime > 0.4)
		animTime = 0.4;
	animTime *= [[CSClassicFolderSettingsManager sharedInstance] speedMultiplier];

	if (animated){
		UIScrollView *scrollView = [self scrollView];
		scrollView.autoresizingMask = 0;

		[UIView animateWithDuration:animTime
		animations:^(void){
			[self layoutSubviews];

			SBIconContentView *iconContentView = [(SBIconController *)[%c(SBIconController) sharedInstance] contentView];
			[iconContentView setClassicFolderIsOpen:NO];
            
            UIView *pageControl = [[rootFolderController contentView] valueForKey:@"_pageControl"];
            if (![[[self folderIconView] location] containsString:@"Dock"]) { // ????
                pageControl.alpha = 1;
                
                if (@available(iOS 16, *)) {
                    SBHSearchPillView *searchPillView = [[rootFolderController contentView] valueForKey:@"_pageControl"];
                    UIView *superview = searchPillView.superview;
                    superview.hidden = NO;
                }
            } else {
                pageControl.alpha = 1;
                
                if (@available(iOS 16, *)) {
                    SBHSearchPillView *searchPillView = [[rootFolderController contentView] valueForKey:@"_pageControl"];
                    UIView *superview = searchPillView.superview;
                    superview.hidden = NO;
                }
            }
            
			[rootContentView layoutSubviews];
		} completion:^(BOOL completed){
			self.superview.clipsToBounds = YES;

			UIView *gestureView = [self gestureView];
			[self setGestureView:nil];
			[gestureView removeFromSuperview];

			if (completion)
				completion(completed);
		}];
	} else {
		[self layoutSubviews];

		SBIconContentView *iconContentView = [(SBIconController *)[%c(SBIconController) sharedInstance] contentView];
		[iconContentView setClassicFolderIsOpen:NO];

		if (![[[self folderIconView] location] containsString:@"Dock"]){
			[rootContentView setClassicFolderShift:0.0f];
		} else {
			UIView *pageControl = [[rootFolderController contentView] valueForKey:@"_pageControl"];
			pageControl.alpha = 1;
		}

		self.superview.clipsToBounds = YES;

		UIView *gestureView = [self gestureView];
		[gestureView removeFromSuperview];
		[self setGestureView:nil];

		[rootContentView layoutSubviews];

		if (completion)
			completion(YES);
	}
}

%new;
- (void)dismiss:(id)sender {
	SBFolderController *controller = [self folderController];
	if (@available(iOS 13, *)){
		SBFolderController *parentController = [controller outerFolderController];
		[parentController popFolderAnimated:YES completion:nil];
	} else {
		if ([controller respondsToSelector:@selector(folderDelegate)]){
			SBFloatingDockViewController *floatingDockController = (SBFloatingDockViewController *)[controller folderDelegate];
			if ([floatingDockController respondsToSelector:@selector(dismissPresentedFolderAnimated:withTransitionContext:completion:)]){
				[floatingDockController dismissPresentedFolderAnimated:YES withTransitionContext:nil completion:nil];
				return;
			}
		}
		[controller popFolderAnimated:YES completion:nil];
	}
}

%new;
- (CGRect)wantedFrame {

	SBRootFolderController *rootFolderController = [[%c(SBIconController) sharedInstance] _rootFolderController];
	SBRootFolderView *rootContentView = [rootFolderController contentView];

	SBIconView *folderIconView = [self folderIconView];
    BOOL isFlipped = [[[self folderIconView] location] containsString:@"Dock"];

	CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;

	CGFloat yPosition = folderIconView.frame.origin.y + folderIconView.frame.size.height;
	if (@available(iOS 13, *)){
	} else {
		yPosition += [[UIApplication sharedApplication] statusBarFrame].size.height;
	}
	if (isFlipped){
		UIView *dockView = [rootContentView valueForKey:@"_dockView"];

		if (dockView){
			yPosition = rootContentView.bounds.size.height - dockView.frame.size.height;
		} else {
			yPosition = [UIScreen mainScreen].bounds.size.height - 5;
		}
		yPosition -= 45;
		if (@available(iOS 13, *)){
			yPosition -= 15.0f;
		}
	} else {
		yPosition -= 5;
	}

	CGFloat iconHeight = 92;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        iconHeight = 136;
        if ([[UIScreen mainScreen] bounds].size.width == 1366 || [[UIScreen mainScreen] bounds].size.height == 1366)
        	iconHeight = 181;
    }
	CGFloat rowsOfIcons = [self getMaximumIconRowsForPages];
	if (rowsOfIcons == 1){
		iconHeight -= 20.0f;
	}
	if (isFlipped){
		yPosition -= (iconHeight * rowsOfIcons);
	}

	CGFloat staticHeight = 50.0f;
	if (@available(iOS 13, *)){
		staticHeight += 10.0f;
	}
	
	if ([[UIScreen mainScreen] bounds].size.width > 320 && [[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad){
		if (isModern){
			if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
				return CGRectMake(11, yPosition, screenWidth - 117, staticHeight + (iconHeight * rowsOfIcons));
			else
				return CGRectMake(11, yPosition, screenWidth - 22, staticHeight + (iconHeight * rowsOfIcons));
		}
		else {
			if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
				return CGRectMake(0, yPosition, screenWidth - 92, staticHeight + (iconHeight * rowsOfIcons));
			else
				return CGRectMake(0, yPosition, screenWidth, staticHeight + (iconHeight * rowsOfIcons));
		}
	}

	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
		if (isModern){
			return CGRectMake(61, yPosition, screenWidth - 122, staticHeight + (iconHeight * rowsOfIcons));
		} else {
			return CGRectMake(0, yPosition, screenWidth, staticHeight + (iconHeight * rowsOfIcons));
		}
	}
	if (isModern)
		return CGRectMake(5, yPosition, screenWidth - 10, staticHeight + (iconHeight * rowsOfIcons));
	else
		return CGRectMake(0, yPosition, screenWidth, staticHeight + (iconHeight * rowsOfIcons));
}

%new;
- (CGFloat)wantedShift:(CGRect)wantedFrame {
	CGFloat yShift = 0.0f;
	SBIconView *folderIconView = [self folderIconView];
	SBRootFolderController *rootFolderController = [[%c(SBIconController) sharedInstance] _rootFolderController];
	SBRootFolderView *rootContentView = [rootFolderController contentView];

	if (![[[self folderIconView] location] containsString:@"Dock"]){
		CGFloat screenHeight = rootContentView.frame.size.height;
		if (wantedFrame.origin.y + wantedFrame.size.height > screenHeight){
			yShift = screenHeight - (wantedFrame.origin.y + wantedFrame.size.height);
			yShift -= 20;
		}
	}
	return yShift;
}

%new;
-(void)setBackgroundAlpha:(CGFloat)alpha {
	[[self backdropView] setAlpha:alpha];
	[[self arrowView] setAlpha:alpha];
	[[self arrowShadowView] setAlpha:alpha];
	[[self labelView] setAlpha:alpha];
}

-(void)fadeContentForMagnificationFraction:(CGFloat)magnificationFraction {
	%orig;
	[[self backdropView] setAlpha:(1.0f-magnificationFraction)];
	[[self arrowView] setAlpha:(1.0f-magnificationFraction)];
	[[self arrowShadowView] setAlpha:(1.0f-magnificationFraction)];
	[[self labelView] setAlpha:(1.0f-magnificationFraction)];
	[self setMagnificationFraction:magnificationFraction];

	[self layoutSubviews];
}

%new;
-(CGPoint)visibleFolderRelativeImageCenterForIcon:(SBIcon *)icon {
	SBIconViewMap *viewMap = [self valueForKey:@"_viewMap"];
	SBIconView *iconView = [viewMap mappedIconViewForIcon:icon];
	CGPoint center = CGPointZero;
	center.x = iconView.frame.origin.x + (iconView.frame.size.width/2.0f);
	center.y = iconView.frame.origin.y + (iconView.frame.size.height/2.0f);
	return center;
}

%new;
-(void)setBackgroundEffect:(NSUInteger)effect {
	
}

-(void)didRotateFromInterfaceOrientation:(int)interfaceOrientation {
	%orig;
	[self layoutSubviews];
}

- (void)layoutSubviews {

	SBIconView *folderIconView = [self folderIconView];
    BOOL isFlipped = [[[self folderIconView] location] containsString:@"Dock"];

	SBRootFolderController *rootFolderController = [[%c(SBIconController) sharedInstance] _rootFolderController];
	SBRootFolderView *rootContentView = [rootFolderController contentView];

	[rootContentView setClassicFolderFrame:CGRectZero];
	[rootContentView setClassicFolderShift:0.0f];
	[rootContentView setClassicFolderIconView:folderIconView];

	[rootContentView layoutSubviews];

	CGRect wantedFrame = [self wantedFrame];

	CGFloat yShift = [self wantedShift:wantedFrame];

	if ([objc_getAssociatedObject(self, &kCSFolderOpenIdentifier) boolValue]){
		[rootContentView setClassicFolderFrame:wantedFrame];

		wantedFrame.origin.y += yShift;

		[rootContentView setClassicFolderShift:yShift];
	} else {
		[rootContentView setClassicFolderIconView:nil];
	}

	[rootContentView layoutSubviews];

	CGFloat adjust = wantedFrame.origin.x;

	UIView *containerView = [self containerView];
	if (![objc_getAssociatedObject(self, &kCSFolderOpenIdentifier) boolValue]){
		CGRect wantedClosedFrame = wantedFrame;
		if (isFlipped){
			wantedClosedFrame.origin.y += wantedClosedFrame.size.height;
		}
		wantedClosedFrame.size.height = 0;
		containerView.frame = wantedClosedFrame;
	} else
		containerView.frame = wantedFrame;
	if ([self magnificationFraction] == 0){
		containerView.clipsToBounds = YES;
	} else {
		containerView.clipsToBounds = NO;
	}

	CGFloat iconHeight = 92.5;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        iconHeight = 136;
        if ([[UIScreen mainScreen] bounds].size.width == 1366 || [[UIScreen mainScreen] bounds].size.height == 1366)
        	iconHeight = 181;
    }

    CGFloat horizontalAdjust = 0.0f;
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
		horizontalAdjust = 10.0f;
	}

	UILabel *titleLabel = [self labelView];
	titleLabel.frame = CGRectMake(21+horizontalAdjust,isFlipped? 6 : 18,wantedFrame.size.width - (21 + horizontalAdjust)*2,22);

	CGRect editFrame = titleLabel.frame;
    editFrame.origin.x -= 10;
    editFrame.size.width += 20;
    if (isModern){
    	editFrame.origin.y -= 2;
    	editFrame.size.height += 5;
    } else {
    	editFrame.origin.y -= 3;
    	editFrame.size.height += 6;
    }
	UITextField *labelEditView = [self labelEditView];
	labelEditView.frame = editFrame;

	CGFloat maxIconRows = [[self currentIconListView] iconRowsForCurrentOrientation];

	UIScrollView *scrollView = [self scrollView];
	[self bringSubviewToFront:scrollView];
	CGRect scrollViewFrame = wantedFrame;
	scrollViewFrame.origin.x = horizontalAdjust;
	if (@available(iOS 13, *)){
		scrollViewFrame.origin.y = isFlipped ? 38.0f : 50.0f;
	} else {
		scrollViewFrame.origin.y = isFlipped ? 18.0f : 30.0f;
	}
	scrollViewFrame.size.width -= (horizontalAdjust * 2);
	scrollViewFrame.size.height = iconHeight * maxIconRows;
	scrollView.frame = scrollViewFrame;

	NSInteger indexes = [[self iconListViews] count];
	CGSize contentSize = CGSizeMake(scrollViewFrame.size.width * indexes, scrollViewFrame.size.height);
	scrollView.contentSize = contentSize;

	UIView *backView = [self backdropView];
	CGRect backdropViewFrame = wantedFrame;
	backdropViewFrame.origin.x = 0;
	if (isFlipped)
		backdropViewFrame.origin.y = 0;
	else
		backdropViewFrame.origin.y = 12;
	backdropViewFrame.size.height -= 12;
	if (!isModern)
		backdropViewFrame.size.height -= 1;
	backView.frame = backdropViewFrame;

	CGRect arrowFrame = CGRectMake(folderIconView.frame.origin.x + (folderIconView.frame.size.width/2.0) - (19.0f + adjust), 0, 38, 12);
	if (isFlipped)
		arrowFrame = CGRectMake(folderIconView.frame.origin.x + (folderIconView.frame.size.width/2.0) - (19.0f + adjust), wantedFrame.size.height-12, 38, 12);
	if (!isModern){
		if (isFlipped)
			arrowFrame = CGRectMake(folderIconView.frame.origin.x + (folderIconView.frame.size.width/2.0) - (12.0f + adjust), wantedFrame.size.height-12, 24, 12);
		else
			arrowFrame = CGRectMake(folderIconView.frame.origin.x + (folderIconView.frame.size.width/2.0) - (12.0f + adjust), 0, 24, 12);
	}
	[[self arrowView] setFrame:arrowFrame];
	[[self arrowShadowView] setFrame:arrowFrame];
	[[self arrowBorderView] setFrame:arrowFrame];

	UIImageView *arrowBackgroundView = [self arrowBackgroundView];
	CGRect arrowBackgroundViewFrame = arrowBackgroundView.frame;
	arrowBackgroundViewFrame.origin.x = -arrowFrame.origin.x;
	arrowBackgroundViewFrame.size.width = backView.frame.size.width;
	arrowBackgroundView.frame = arrowBackgroundViewFrame;

	UIView *topLineLeft = [self topLineLeft];
	UIView *topLineRight = [self topLineRight];

	[topLineLeft setFrame:CGRectMake(adjust,isFlipped ? containerView.bounds.size.height-(arrowFrame.size.height) : arrowFrame.size.height -1 ,arrowFrame.origin.x+1,1)];
	[topLineRight setFrame:CGRectMake(arrowFrame.origin.x + arrowFrame.size.width - 1,isFlipped ? containerView.bounds.size.height-(arrowFrame.size.height) : arrowFrame.size.height - 1 , containerView.frame.size.width - (arrowFrame.origin.x + arrowFrame.size.width - 1),1)];

	%orig;
}

- (void)_layoutSubviews {
	if (@available(iOS 13, *)){

	} else {
		%orig;
	}
}

/*- (void)_updateIconListFrames {
	%orig;

	UIScrollView *scrollView = [self scrollView];
	if (@available(iOS 13, *)){
		for (UIView *iconListView in [self iconListViews]){
			iconListView.frame = scrollView.bounds;
		}
	}
}*/

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    %orig;
    [[self containerView] bringSubviewToFront:[self labelEditView]];
    float duration = 0.0f;
    if (animated)
        duration = 0.25f;
    [UIView animateWithDuration:duration animations:^{
        if (!editing){
            [[self labelView] setAlpha:1.0f];
            [[self labelEditView] setAlpha:0.0f];
        } else {
            [[self labelView] setAlpha:0.0f];
            [[self labelEditView] setAlpha:1.0f];
        }
        [self layoutSubviews];
    } completion:^(BOOL finished) {
        if (!editing) {
            [self endEditing:YES]; //hide the keyboard if there is no editing mode
        }
    }];
    [self resetIconListViews];
}

- (BOOL)locationCountsAsInsideFolder:(CGPoint)location {
	CGRect expandedFrame = [self containerView].frame;
	expandedFrame.origin.x -= 10;
	expandedFrame.size.width += 20;
	return CGRectContainsPoint(expandedFrame, location);
}

%new
- (UIView *)containerView {
	return objc_getAssociatedObject(self, &kCSFolderContainerViewIdentifier);
}

%new
- (void)setContainerView:(UIView *)containerView {
	objc_setAssociatedObject(self, &kCSFolderContainerViewIdentifier, containerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
- (UIView *)backdropView {
	return objc_getAssociatedObject(self, &kCSFolderBackgroundViewIdentifier);
}

%new
- (void)setBackdropView:(UIView *)backdropView {
	objc_setAssociatedObject(self, &kCSFolderBackgroundViewIdentifier, backdropView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new;
- (UIView *)gestureView {
	return objc_getAssociatedObject(self, &kCSFolderGestureViewIdentifier);
}

%new;
- (void)setGestureView:(UIView *)gestureView {
	objc_setAssociatedObject(self, &kCSFolderGestureViewIdentifier, gestureView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
- (UILabel *)labelView {
	return objc_getAssociatedObject(self, &kCSFolderLabelViewIdentifier);
}

%new
- (void)setLabelView:(UILabel *)labelView {
	objc_setAssociatedObject(self, &kCSFolderLabelViewIdentifier, labelView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
- (UITextField *)labelEditView {
	return objc_getAssociatedObject(self, &kCSFolderLabelEditViewIdentifier);
}

%new
- (void)setLabelEditView:(UITextField *)labelEditView {
	objc_setAssociatedObject(self, &kCSFolderLabelEditViewIdentifier, labelEditView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new;
- (UIView *)arrowView {
	return objc_getAssociatedObject(self, &kCSFolderArrowViewIdentifier);
}

%new;
- (void)setArrowView:(UIView *)arrowView {
	objc_setAssociatedObject(self, &kCSFolderArrowViewIdentifier, arrowView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new;
- (UIImageView *)arrowBackgroundView {
	return objc_getAssociatedObject(self, &kCSFolderArrowBackgroundViewIdentifier);
}

%new;
- (void)setArrowBackgroundView:(UIImageView *)arrowBackgroundView {
	objc_setAssociatedObject(self, &kCSFolderArrowBackgroundViewIdentifier, arrowBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new;
- (UIView *)arrowShadowView {
	return objc_getAssociatedObject(self, &kCSFolderArrowShadowViewIdentifier);
}

%new;
- (void)setArrowShadowView:(UIView *)arrowShadowView {
	objc_setAssociatedObject(self, &kCSFolderArrowShadowViewIdentifier, arrowShadowView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new;
- (UIView *)arrowBorderView {
	return objc_getAssociatedObject(self, &kCSFolderArrowBorderViewIdentifier);
}

%new;
- (void)setArrowBorderView:(UIView *)arrowBorderView {
	objc_setAssociatedObject(self, &kCSFolderArrowBorderViewIdentifier, arrowBorderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
- (SBIconView *)folderIconView {
	return objc_getAssociatedObject(self, &kCSFolderIconViewIdentifier);
}

%new
- (void)setFolderIconView:(SBIconView *)folderIconView {
	objc_setAssociatedObject(self, &kCSFolderIconViewIdentifier, folderIconView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
- (SBFolderController *)folderController {
	return objc_getAssociatedObject(self, &kCSFolderControllerIdentifier);
}

%new
- (void)setFolderController:(SBFolderController *)folderController {
	objc_setAssociatedObject(self, &kCSFolderControllerIdentifier, folderController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
- (CGFloat)magnificationFraction {
	return [objc_getAssociatedObject(self, &kCSFolderMagnificationFractionIdentifier) floatValue];
}

%new
- (void)setMagnificationFraction:(CGFloat)magnificationFraction {
	objc_setAssociatedObject(self, &kCSFolderMagnificationFractionIdentifier, [NSNumber numberWithFloat:magnificationFraction], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
- (UIView *)topLineLeft {
	return objc_getAssociatedObject(self, &kCSFolderTopLineLeftIdentifier);
}

%new
- (void)setTopLineLeft:(UIView *)topLineLeft {
	objc_setAssociatedObject(self, &kCSFolderTopLineLeftIdentifier, topLineLeft, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
- (UIView *)topLineRight {
	return objc_getAssociatedObject(self, &kCSFolderTopLineRightIdentifier);
}

%new
- (void)setTopLineRight:(UIView *)topLineRight {
	objc_setAssociatedObject(self, &kCSFolderTopLineRightIdentifier, topLineRight, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
%end

//Images weren't flipping because the icons weren't located in the dock.
//Thank you https://github.com/udevsharold/bakgrunnur/blob/2f9c987f613b8aa1e42b6f2b622e1a0f9ce1a9ad/Bakgrunnur.xm#L395
%hook SBIconView
- (long long)currentLabelAccessoryType {
    long long originalValue = %orig;
    
    isFlipped = [self.location containsString:@"Dock"] ? YES : NO;
    
    return originalValue;
}
%end

%ctor {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		%init;
		if (!selfVerify()){
			unlink("/var/mobile/Library/Preferences/org.coolstar.classicfolders2.license");
			unlink("/usr/lib/cslicenses/org.coolstar.classicfolders2.license");
#if __LP64__
#else
			unlink("/var/mobile/Library/Preferences/org.coolstar.classicfolders2.license.signed");
			unlink("/usr/lib/cslicenses/org.coolstar.classicfolders2.license.signed");
#endif
			safeMode();
		}
		if (!deepVerifyUDID()){
			unlink("/var/mobile/Library/Preferences/org.coolstar.classicfolders2.license");
			unlink("/usr/lib/cslicenses/org.coolstar.classicfolders2.license");
#if __LP64__
#else
			unlink("/var/mobile/Library/Preferences/org.coolstar.classicfolders2.license.signed");
			unlink("/usr/lib/cslicenses/org.coolstar.classicfolders2.license.signed");
#endif
			safeMode();
		}
	});
}
