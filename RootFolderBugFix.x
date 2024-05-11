#import "Headers.h"

%hook SBRootFolderView

static const char *kCSFolderFrameIdentifier;
static const char *kCSFolderInDockIdentifier;
static const char *kCSFolderShiftIdentifier;
static const char *kCSFolderIconIdentifier;

%new;
- (CGFloat) classicFolderShift {
	return [(NSNumber *)objc_getAssociatedObject(self, &kCSFolderShiftIdentifier) floatValue];
}

%new;
- (void)setClassicFolderShift:(CGFloat)shift {
	objc_setAssociatedObject(self, &kCSFolderShiftIdentifier, [NSNumber numberWithFloat:shift], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new;
- (BOOL) classicFolderFrameSet {
	return (objc_getAssociatedObject(self, &kCSFolderFrameIdentifier) != nil);
}

%new;
- (CGRect) classicFolderFrame {
	return CGRectFromString(objc_getAssociatedObject(self, &kCSFolderFrameIdentifier));
}

%new;
- (void)setClassicFolderFrame:(CGRect)frame {
	if (@available(iOS 13, *)){
		frame.origin.y += [[UIApplication sharedApplication] statusBarFrame].size.height;
	}

	if (frame.size.width == 0)
		objc_setAssociatedObject(self, &kCSFolderFrameIdentifier, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	else
		objc_setAssociatedObject(self, &kCSFolderFrameIdentifier, NSStringFromCGRect(frame), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new;
- (SBIconView *)classicFolderIconView {
	return (SBIconView *)objc_getAssociatedObject(self, &kCSFolderIconIdentifier);
}

%new;
- (void)setClassicFolderIconView:(SBIconView *)iconView {
	[[self classicFolderIconView] _applyIconLabelAlpha:1.0f];
	[iconView _applyIconLabelAlpha:0.0f];
	objc_setAssociatedObject(self, &kCSFolderIconIdentifier, iconView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new;
- (BOOL)classicFolderInDock {
	return [(NSNumber *)objc_getAssociatedObject(self, &kCSFolderInDockIdentifier) boolValue];
}

%new;
- (void)setClassicFolderInDock:(BOOL)inDock {
	objc_setAssociatedObject(self, &kCSFolderInDockIdentifier, [NSNumber numberWithBool:inDock], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)layoutSubviews {
	%orig;

	SBIconListView *iconListView = nil;
	[iconListView setClassicFolderInDock:[self classicFolderInDock]];
	[iconListView setClassicFolderFrame:[self classicFolderFrame]];
	[iconListView setClassicFolderShift:[self classicFolderShift]];
	[iconListView setClassicFolderIconView:[self classicFolderIconView]];
	[iconListView layoutIconsNow];

	CGRect classicFolderFrame = [self classicFolderFrame];

	if (![self classicFolderInDock]){
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ||
			UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])){
			UIView *dockView = [self dockView];
			CGRect dockViewFrame = dockView.frame;
			dockViewFrame.origin.y += classicFolderFrame.size.height;
			dockView.frame = dockViewFrame;
		}
        
        [[self classicFolderIconView] _applyIconLabelAlpha:0.0];
	}
}

%end
