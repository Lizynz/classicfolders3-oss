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

static char *kCSFolderIconBackgroundViewIdentifier;

%group IconHook
%hook SBFolderIconBackgroundView
- (void)setWallpaperBackgroundRect:(CGRect)backgroundRect forContents:(CGImageRef)contents withFallbackColor:(CGColorRef)fallbackColor {
	SBWallpaperEffectView *backView = objc_getAssociatedObject(self, &kCSFolderIconBackgroundViewIdentifier);
    if (backView){
        [backView removeFromSuperview];
        backView = nil;
    }
    objc_setAssociatedObject(self, &kCSFolderIconBackgroundViewIdentifier, backView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	%orig(backgroundRect,contents,fallbackColor);
}

- (void)layoutSubviews {
	%orig;
    if (![self respondsToSelector:@selector(setWallpaperBackgroundRect:forContents:withFallbackColor:)]){
        [self setBlurring:YES];
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

%hook SBHLibraryAdditionalItemsIndicatorIconImageView
- (void)layoutSubviews {
    NSString *path1 = @"/var/jb/Library/MobileSubstrate/DynamicLibraries/BoldersReborn.dylib";
    if ([[NSFileManager defaultManager] fileExistsAtPath:path1]) {
        %orig;
        return;
    }

    %orig;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"15.0") && SYSTEM_VERSION_LESS_THAN(@"18.0")) { //No change required on iOS 18
        
        self.translatesAutoresizingMaskIntoConstraints = YES;
        self.transform = CGAffineTransformIdentity;
        
        CGAffineTransform originalIconView = self.transform;
        self.transform = CGAffineTransformMake(
                                               1.26,
                                               originalIconView.b,
                                               originalIconView.c,
                                               1.26,
                                               originalIconView.tx - 0.3,
                                               originalIconView.ty - 0.3
                                               );
    }
}

%end
%end

%ctor {
    if ([[CSClassicFolderSettingsManager sharedInstance] enabled]){
        %init(IconHook);
    }
}
