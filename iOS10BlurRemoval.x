#import "Headers.h"

%group BlurRemoval
%hook SBFolderContainerView
- (void)layoutSubviews {
	[[self backgroundView] setAlpha:0];

	%orig;
}
%end
%end

%group BlurRemoval13
//iOS 13
%hook SBFolderController
-(void)viewWillTransitionToSize:(CGSize)arg2 forOperation:(NSInteger)operation withTransitionCoordinator:(id)coordinator {
	%orig;
	SBIconView *iconView = [self folderIconView];
	if ([iconView respondsToSelector:@selector(setAllIconElementsButLabelToHidden:)])
		[iconView setAllIconElementsButLabelToHidden:NO];
	else
		[iconView setAllIconElementsButLabelHidden:NO];
}
%end
%end

%ctor {
	if ([[CSClassicFolderSettingsManager sharedInstance] enabled]){
		if (kCFCoreFoundationVersionNumber >= 1600){
			%init(BlurRemoval);
			%init(BlurRemoval13);
		}
	}
}
