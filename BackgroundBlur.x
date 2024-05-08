#import "Headers.h"

#define blurBackground [[CSClassicFolderSettingsManager sharedInstance] blurBackground]

static UIView *kCSblurView;
static const char *kCSFolderOpenIdentifier;

%hook SBIconContentView
%new;
- (void)initBlurView {
	SBWallpaperEffectView *blurView = [[%c(SBWallpaperEffectView) alloc] initWithWallpaperVariant:1];
	blurView.frame = self.bounds;
	blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[blurView setStyle:5];
	[self addSubview:[blurView autorelease]];
	[self sendSubviewToBack:blurView];

	[self setClassicFolderIsOpen:NO];

	if (!blurBackground)
		blurView.alpha = 0;

	kCSblurView = blurView;
}

//7.x
- (id)initWithOrientation:(int)orientation {
	self = %orig;

	[self initBlurView];

	return self;
}

//8.x+
- (id)initWithOrientation:(int)orientation statusBarHeight:(double)arg2 {
	self = %orig;

	[self initBlurView];

	return self;
}

%new;
- (BOOL)classicFolderIsOpen {
	return [(NSNumber *)objc_getAssociatedObject(self, &kCSFolderOpenIdentifier) boolValue];
}

%new;
- (void)setClassicFolderIsOpen:(BOOL)isOpen {
	objc_setAssociatedObject(self, &kCSFolderOpenIdentifier, [NSNumber numberWithBool:isOpen], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	if (blurBackground == 2){
		kCSblurView.alpha = isOpen ? 1 : 0;
	}
}

- (void)layoutSubviews {
	%orig;
	[self sendSubviewToBack:kCSblurView];

	if (blurBackground == 0)
		kCSblurView.alpha = 0;
	else if (blurBackground == 1)
		kCSblurView.alpha = 1;
	else
		kCSblurView.alpha = [self classicFolderIsOpen] ? 1 : 0;

	CGRect blurFrame = self.bounds;
	kCSblurView.frame = blurFrame;
}
%end
