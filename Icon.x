#import "Headers.h"

#define isModern [[CSClassicFolderSettingsManager sharedInstance] modern]
#define isClassic [[CSClassicFolderSettingsManager sharedInstance] classic]
#define isLegacy [[CSClassicFolderSettingsManager sharedInstance] legacy]
#define classicIcon [[CSClassicFolderSettingsManager sharedInstance] classicIcon]
#define classicShape [[CSClassicFolderSettingsManager sharedInstance] classicShape]
#define outline [[CSClassicFolderSettingsManager sharedInstance] outline]

@interface SBFolderIconBackgroundView : UIView
- (void)setBlurring:(BOOL)blurring;
@end

@interface SBHLibraryAdditionalItemsIndicatorIconImageView : SBFolderIconImageView
- (unsigned long long)concreteBackgroundStyle;
@end

@interface _UIBackdropView : UIView
- (id)initWithStyle:(int)arg1;
@end

static char *kCSFolderIconBackgroundViewIdentifier;

%group IconHook
%hook SBFolderIconBackgroundView
- (void)setWallpaperBackgroundRect:(CGRect)backgroundRect forContents:(CGImageRef)contents withFallbackColor:(CGColorRef)fallbackColor {
	SBWallpaperEffectView *backView = objc_getAssociatedObject(self, &kCSFolderIconBackgroundViewIdentifier);
	if ([[CSClassicFolderSettingsManager sharedInstance] dark]){
		if (!backView){
			backView = [[%c(SBWallpaperEffectView) alloc] initWithWallpaperVariant:1];
			backView.frame = self.bounds;
			[backView setStyle:14];
			[self addSubview:[backView autorelease]];
		}

    	contents = nil;
    	backgroundRect = CGRectZero;
	} else {
		if (backView){
			[backView removeFromSuperview];
			backView = nil;
		}
	}
	objc_setAssociatedObject(self, &kCSFolderIconBackgroundViewIdentifier, backView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	%orig(backgroundRect,contents,fallbackColor);
}

- (void)layoutSubviews {
	%orig;
	if (![self respondsToSelector:@selector(setWallpaperBackgroundRect:forContents:withFallbackColor:)]){
		if ([[CSClassicFolderSettingsManager sharedInstance] dark]){
			[self setBlurring:NO];
			[self setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.6f]];
		} else {
			[self setBlurring:YES];
		}
	}
}

-(void)didAddSubview:(UIView *)arg1 {

}
%end

static BOOL useClassicIcon = NO;
static BOOL lockClassicIcon = NO;

%hook SBFolderIconImageView
- (void)setBackgroundView:(UIView *)arg1 {
        %orig;
    
    if (!lockClassicIcon){
        useClassicIcon = (!isModern && classicIcon);
        lockClassicIcon = YES;
    }

    if (useClassicIcon){
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:self.bounds];
        iconView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        iconView.clipsToBounds = YES;

        ANEMSettingsManager *manager = [%c(ANEMSettingsManager) sharedManager];
        if ([manager respondsToSelector:@selector(folderIconMaskRadius)]){
            CGFloat radius = [manager folderIconMaskRadius];
            iconView.layer.cornerRadius = radius;
        }

        if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad){
            if (isLegacy) {
                if (classicShape)
                    [iconView setImage:[UIImage classicFolderImageNamed:@"iOS 4/LegacyFolderIconBG~iphone"]];
                else if (outline)
                    [iconView setImage:[UIImage classicFolderImageNamed:@"iOS 4/OutlineFolderIconBG~iphone"]];
                else
                    [iconView setImage:[UIImage classicFolderImageNamed:@"iOS 4/FolderIconBG~iphone"]];
            } else if (isClassic){
                if (classicShape)
                    [iconView setImage:[UIImage imageNamed:@"FolderIconBG~iphone"]];
                else if (outline)
                    [iconView setImage:[UIImage classicFolderImageNamed:@"OutlineFolderIconBG~iphone"]];
                else
                    [iconView setImage:[UIImage classicFolderImageNamed:@"FolderIconBG~iphone"]];
            } else {
                if (classicShape)
                    [iconView setImage:[UIImage classicFolderImageNamed:@"Mavericks/LegacyFolderIconBG~iphone"]];
                else if (outline)
                    [iconView setImage:[UIImage classicFolderImageNamed:@"Mavericks/OutlineFolderIconBG~iphone"]];
                else
                    [iconView setImage:[UIImage classicFolderImageNamed:@"Mavericks/FolderIconBG~iphone"]];
            }
        } else {
            if (isLegacy) {
                if (classicShape)
                    [iconView setImage:[UIImage classicFolderImageNamed:@"iOS 4/LegacyFolderIconBG~ipad"]];
                else if (outline)
                    [iconView setImage:[UIImage classicFolderImageNamed:@"iOS 4/OutlineFolderIconBG~ipad"]];
                else
                    [iconView setImage:[UIImage classicFolderImageNamed:@"iOS 4/FolderIconBG~ipad"]];
            } else if (isClassic){
                if (classicShape)
                    [iconView setImage:[UIImage imageNamed:@"FolderIconBG~ipad"]];
                else if (outline)
                    [iconView setImage:[UIImage classicFolderImageNamed:@"OutlineFolderIconBG~ipad"]];
                else
                    [iconView setImage:[UIImage classicFolderImageNamed:@"FolderIconBG~ipad"]];
            } else {
                if (classicShape)
                    [iconView setImage:[UIImage classicFolderImageNamed:@"Mavericks/LegacyFolderIconBG~ipad"]];
                else if (outline)
                    [iconView setImage:[UIImage classicFolderImageNamed:@"Mavericks/OutlineFolderIconBG~ipad"]];
                else
                    [iconView setImage:[UIImage classicFolderImageNamed:@"Mavericks/FolderIconBG~ipad"]];
            }
        }
        [self insertSubview:[iconView autorelease] aboveSubview:[self backgroundView]];
        [[self backgroundView] setAlpha:0];
    }
}

- (void)layoutSubviews {
	%orig;
	if (useClassicIcon)
		[[self backgroundView] setAlpha:0];
}
%end

%hook SBFolderIconView
- (void)_updateAdaptiveColors {
	%orig;
	UIView *backgroundView = [self iconBackgroundView];
	[backgroundView layoutSubviews];
}
%end

_UIBackdropView *blurView;

%hook SBHLibraryAdditionalItemsIndicatorIconImageView
- (void)layoutSubviews {
    %orig;
    
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UIVisualEffectView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    blurEffectView.frame = self.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    blurEffectView.layer.cornerRadius = 13.5;
    blurEffectView.layer.masksToBounds = YES;
    blurEffectView.alpha = 0.7;
    
    [self insertSubview:blurEffectView atIndex:0];
}
%end
%end

%ctor {
	dlopen("/Library/MobileSubstrate/DynamicLibraries/AnemoneIcons.dylib", RTLD_LAZY);
	if ([[CSClassicFolderSettingsManager sharedInstance] enabled]){
		%init(IconHook);
	}
}
