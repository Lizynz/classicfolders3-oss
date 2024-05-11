#import "Headers.h"

%hook SBIconListView

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

- (void)layoutIconsNow {
	%orig;

	if (![self classicFolderFrameSet]){
		for (UIView *icon in self.subviews){
			icon.alpha = 1.0f;
		}
		return;
	}

	CGRect classicFolderFrame = [self classicFolderFrame];
	for (SBIconView *icon in self.subviews){
		CGRect frame = icon.frame;
		if ([self classicFolderInDock]){
			frame.origin.y -= classicFolderFrame.size.height;
		} else {
			if (frame.origin.y + frame.size.height > (classicFolderFrame.origin.y - 10)){
				frame.origin.y += classicFolderFrame.size.height;
			}
		}
		frame.origin.y += [self classicFolderShift];
		if (icon != [self classicFolderIconView])
			icon.alpha = 0.5f;
		else
			[icon _applyIconLabelAlpha:0.0f];
		icon.frame = frame;
	}
}

%end
