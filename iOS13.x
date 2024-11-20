#import "Headers.h"

#define isModern [[CSClassicFolderSettingsManager sharedInstance] modern]

typedef struct SBIconCoordinate {
	long long row;
	long long col;
} SBIconCoordinate;

@interface SBFolderIconListView()
- (CGFloat)sideIconInset;
@end

@interface SBIconListGridLayoutConfiguration : NSObject
@property (assign,nonatomic) unsigned long long numberOfPortraitColumns;
@property (assign,nonatomic) unsigned long long numberOfPortraitRows;
@property (assign,nonatomic) unsigned long long numberOfLandscapeColumns;
@property (assign,nonatomic) unsigned long long numberOfLandscapeRows;
@property (assign,nonatomic) UIEdgeInsets portraitLayoutInsets;
@property (assign,nonatomic) UIEdgeInsets landscapeLayoutInsets;
@end

@interface SBIconListFlowLayout : NSObject
- (SBIconListGridLayoutConfiguration *)layoutConfiguration;
@end

static BOOL speed;

%group FolderHooks
%subclass SBFolderIconListView : SBIconListView

- (SBIconListFlowLayout *)layout {
	SBIconListFlowLayout *layout = %orig;

	SBIconListGridLayoutConfiguration *configuration = [layout layoutConfiguration];
//	configuration.numberOfPortraitColumns = 4;
//	configuration.numberOfPortraitRows = 5;
//	configuration.numberOfLandscapeColumns = 5;
//	configuration.numberOfLandscapeRows = 4;

	configuration.portraitLayoutInsets = UIEdgeInsetsMake(-5, [self sideIconInset], 20.0f, [self sideIconInset]); //5
	configuration.landscapeLayoutInsets = UIEdgeInsetsMake(-5, [self sideIconInset], 20.0f, [self sideIconInset]); //5

	return layout;
}

%new;
- (CGFloat)sideIconInset {
	if (isModern)
		return 17.0f;

	if ([[UIScreen mainScreen] bounds].size.width > 320 && [[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad)
		return 27.0f;
	else
		return 17.0f;
}
%end

%hook SBIconListFlowLayout // Icon Layout
- (NSUInteger)numberOfRowsForOrientation:(NSInteger)arg1 {
    NSString *path1 = BOLDERS_PATH;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path1]) {
        return %orig(arg1);
    }

    NSInteger x = %orig(arg1);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if (x == 1) {
            return %orig;
        }
        if (x == 3) {
            return 4;
        }
        return %orig;
    }
    return %orig;
}

- (NSUInteger)numberOfColumnsForOrientation:(NSInteger)arg1 {
    NSString *path1 = BOLDERS_PATH;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path1]) {
        return %orig(arg1);
    }
    
    NSInteger x = %orig(arg1);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        if (x==1) {
            return %orig;
        }
        if (x==3) {
            return 4;
        }
        return %orig;
    }
    return %orig;
}

%end

@interface _SBIconGridWrapperView : UIView // Grid Icon ≤ iOS 17
@property (nonatomic, assign) CGAffineTransform transform;
@end

//@interface _SBIconGridImageWrapperView : UIView // Grid Icon iOS 18
//@property (nonatomic, assign) CGAffineTransform transform;
//@end

//≤ iOS 17
%hook _SBIconGridWrapperView
- (void)layoutSubviews {
    NSString *path1 = BOLDERS_PATH;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path1]) {
        %orig;
        return;
    }
    
    %orig;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.translatesAutoresizingMaskIntoConstraints = YES;
        self.transform = CGAffineTransformIdentity;
        CGAffineTransform originalIconView = CGAffineTransformIdentity;
        self.transform = CGAffineTransformMake(
                                               0.77,
                                               originalIconView.b,
                                               originalIconView.c,
                                               0.77,
                                               originalIconView.tx,
                                               originalIconView.ty
                                               );
    }
}
%end

//iOS 18
//%hook _SBIconGridImageWrapperView
//- (void)layoutSubviews {
//    NSString *path1 = BOLDERS_PATH;
//    if ([[NSFileManager defaultManager] fileExistsAtPath:path1]) {
//        %orig;
//        return;
//    }
//
//    %orig;
//
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        CGAffineTransform originalIconView = (self.transform);
//        self.transform = CGAffineTransformMake(
//                                               0.77,
//                                               originalIconView.b,
//                                               originalIconView.c,
//                                               0.77,
//                                               originalIconView.tx,
//                                               originalIconView.ty
//                                               );
//    }
//}
//%end

//Doesn’t work only display icons

//%hook SBFloatingDockViewController
//- (void)_presentFolderForIcon:(SBFolderIcon *)folderIcon location:(NSString *)location animated:(BOOL)animated completion:(id)completion {
//    if (folderIcon && [self _shouldOpenFolderIcon:folderIcon]) {
//        SBFolder *folder = [folderIcon folder];
//       
//        Class folderControllerClass = [self controllerClassForFolder:folder];
//        Class configurationClass = [folderControllerClass configurationClass];
//        
//        SBHIconManager *iconManager = [[%c(SBIconController) sharedInstance] iconManager];
//        [[iconManager openedFolderController] isOpen];
//        
//        SBFolderControllerConfiguration *configuration = (SBFolderControllerConfiguration *)[[configurationClass alloc] init];
//        configuration.folder = folder;
//        configuration.originatingIconLocation = location;
//        
//        SBFolderController *folderController = [[folderControllerClass alloc] initWithConfiguration:configuration];
//        [folderController setFolderDelegate:self];
//        [folderController setLegibilitySettings:[self legibilitySettings]];
//        [folderController setEditing:[iconManager isEditing]];
//        
//        SBFolderPresentingViewController *presentingController = [self folderPresentingViewController];
//        [presentingController presentFolderController:folderController animated:animated completion:completion];
//        
//        if ([folderControllerClass _contentViewClass] == %c(CSClassicFolderView)){
//            CSClassicFolderView *folderView = (CSClassicFolderView *)[folderController contentView];
//            [folderView setFolderController:folderController];
//            [folderView setFolderIconView:[folderController folderIconView]];
//            
//            [folderView openFolder:animated completion:nil];
//        }
//    }
//}
// // Works normal
//- (void)dismissPresentedFolderAnimated:(BOOL)animated completion:(id)completion {
//    SBFolderPresentingViewController *presentingController = [self folderPresentingViewController];
//    
//    SBFolderController *folderController = [presentingController presentedFolderController];
//    if (folderController){
//        if ([folderController innerFolderController] != nil){
//            [folderController popFolderAnimated:animated completion:completion];
//            return;
//        } else {
//            CSClassicFolderView *folderView = (CSClassicFolderView *)[folderController contentView];
//            if ([folderView respondsToSelector:@selector(closeFolder:completion:)]){
//                [folderView closeFolder:animated completion:^(BOOL finished){
//                    [presentingController dismissPresentedFolderControllerAnimated:NO completion:completion];
//                }];
//            } else {
//                [presentingController dismissPresentedFolderControllerAnimated:NO completion:completion];
//            }
//            return;
//        }
//    }
//}
//%end

%hook SBFolderController
- (void)pushFolderIcon:(SBFolderIcon *)folderIcon location:(NSString *)location animated:(BOOL)animated completion:(id)completion {
    if ((folderIcon != nil) && ([self shouldOpenFolderIcon:folderIcon])){
        SBFolder *folder = [folderIcon folder];
        
        Class folderControllerClass = [self controllerClassForFolder:folder];
        Class configurationClass = [folderControllerClass configurationClass];
        
        SBFolderControllerConfiguration *configuration = (SBFolderControllerConfiguration *)[[configurationClass alloc] init];
        configuration.folder = folder;
        configuration.originatingIconLocation = location;
        
        [self configureInnerFolderControllerConfiguration:configuration];
        
        if ([location isEqual:@"SBIconLocationAppLibraryCategoryPod"] || [location isEqual:@"SBIconLocationAppLibraryCategoryPodRecents"] || [location isEqual:@"SBIconLocationAppLibraryCategoryPodSuggestions"]) { //Fix animation App Library and reachability
            BOOL aniLib = YES;
            
            SBFolderController *innerController = [(SBFolderController *)[folderControllerClass alloc] initWithConfiguration:configuration];
            [self pushNestedViewController:innerController animated:aniLib withCompletion:^(BOOL finished) {
                if ([folderControllerClass _contentViewClass] == %c(CSClassicFolderView)) {
                    CSClassicFolderView *folderView = (CSClassicFolderView *)[innerController contentView];
                    [folderView setFolderController:innerController];
                    [folderView setFolderIconView:[innerController folderIconView]];
                    [folderView openFolder:animated completion:nil];
                }
            }];
            
            double delayInSeconds = 0.1;
               dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
               dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                   
                   [UIView animateWithDuration:0.0 animations:^{
                       [self pushNestedViewController:innerController animated:aniLib withCompletion:completion];
                   } completion:^(BOOL finished) {
                       if ([folderControllerClass _contentViewClass] == %c(CSClassicFolderView)) {
                           CSClassicFolderView *folderView = (CSClassicFolderView *)[innerController contentView];
                           [folderView setFolderController:innerController];
                           [folderView setFolderIconView:[innerController folderIconView]];
                           [folderView openFolder:animated completion:nil];
                       }
                   }];
            });
        }
        
        if ([location isEqual:@"SBIconLocationRoot"] || [location isEqual:@"SBIconLocationDock"]) { // Fix folder animation and reachability
            SBFolderController *innerController = [(SBFolderController *)[folderControllerClass alloc] initWithConfiguration:configuration];
            
            if (animated) {
                [UIView animateWithDuration:0.0 animations:^{
                    [self pushNestedViewController:innerController animated:speed withCompletion:completion];
                } completion:^(BOOL finished) {
                    if ([folderControllerClass _contentViewClass] == %c(CSClassicFolderView)) {
                        CSClassicFolderView *folderView = (CSClassicFolderView *)[innerController contentView];
                        [folderView setFolderController:innerController];
                        [folderView setFolderIconView:[innerController folderIconView]];
                        [folderView openFolder:animated completion:nil];
                    }
                }];
            } else {
                [UIView animateWithDuration:0.0 animations:^{
                    [self pushNestedViewController:innerController animated:speed withCompletion:completion];
                } completion:^(BOOL finished) {
                    if ([folderControllerClass _contentViewClass] == %c(CSClassicFolderView)) {
                        CSClassicFolderView *folderView = (CSClassicFolderView *)[innerController contentView];
                        [folderView setFolderController:innerController];
                        [folderView setFolderIconView:[innerController folderIconView]];
                        [folderView openFolder:NO completion:nil];
                    }
                }];
            }
        }
    }
}

- (void)setEditing:(BOOL)arg1 animated:(BOOL)arg2 { // Animation control mode solves the problem when editing folder.
    %orig;
    if ([self isKindOfClass:NSClassFromString(@"SBFolderController")] || [self isKindOfClass:NSClassFromString(@"SBFloatyFolderController")]) {
        if ([self respondsToSelector:@selector(isOpen)]) {
            if (arg1) {
                [self setValue:@YES forKey:@"open"];
                speed = YES;
            } else {
                [self setValue:@YES forKey:@"open"];
                speed = NO;
            }
        }
    }
}

- (BOOL)popFolderAnimated:(BOOL)animated completion:(void(^)(BOOL finished))completion {
    SBFolderController *innerController = [self innerFolderController];
    if (innerController != nil){
		if ([innerController innerFolderController] != nil){
			return [[innerController innerFolderController] popFolderAnimated:animated completion:completion];
		} else {
			CSClassicFolderView *folderView = (CSClassicFolderView *)[innerController contentView];
			if ([folderView respondsToSelector:@selector(closeFolder:completion:)]){
				[folderView closeFolder:animated completion:^(BOOL finished){
					[self popNestedViewControllerAnimated:NO withCompletion:completion];
				}];
				return YES;
			} else {
				[self popNestedViewControllerAnimated:animated withCompletion:completion];
				return YES;
			}
		}
	} else {
		return NO;
	}
}

- (void)popNestedViewControllerAnimated:(BOOL)animated withCompletion:(void(^)(BOOL finished))completion {
	SBFolderController *innerController = [self innerFolderController];
	[innerController retain];
	%orig();
	if (innerController != nil){
		if (innerController != [self innerFolderController]){
			CSClassicFolderView *folderView = (CSClassicFolderView *)[innerController contentView];
			if ([folderView respondsToSelector:@selector(closeFolder:completion:)])
				[folderView closeFolder:NO completion:nil];
		}
		[innerController release];
	}
}
%end

%hook SBFloatyFolderController
+ (Class)_contentViewClass {
	return %c(CSClassicFolderView);
}
%end

//Fix crash
%hook UIImage
+ (UIImage *) sbf_imageFromContextWithSize:(CGSize)size scale:(CGFloat)scale type:(NSInteger)type pool:(id)pool drawing:(id)drawing encapsulation:(id)encapsulation {
	UIImage *image = nil;
	@try {
		image = %orig;
	} 
	@catch (NSException *exception){
		//NSLog(@"Caught iOS 13 crash: %@", exception);
	}
	return image;
}
%end

//Fix folder open when Reduce Transparency is enabled or when folders are opened in the air.
%hook SBFolderController

- (BOOL)_homescreenAndDockShouldFade {
    return NO;
}

%end

//Hide Folder Name Shortcuts
%hook SBIconView

- (void)setApplicationShortcutItems:(NSArray *)arg1 {
    NSMutableArray *newItems = [[NSMutableArray alloc] init];
    for (SBSApplicationShortcutItem *item in arg1) {
        if (![item.type isEqualToString:@"com.apple.springboardhome.application-shortcut-item.rename-folder"]) {
            [newItems addObject:item];
        }
    }
    %orig(newItems);
}

%end

//Auto Close Folder
%hook SBUIController
- (void)activateApplication:(id)arg1 fromIcon:(id)arg2 location:(long long)arg3 activationSettings:(id)arg4 actions:(id)arg5 {
    SBIconController *iconController = [%c(SBIconController) sharedInstance];
    if ([[iconController _openFolderController] isOpen]) {
        %orig;
        if ([[CSClassicFolderSettingsManager sharedInstance] autoCloseFolders]){
            [iconController.iconManager closeFolderAnimated:YES withCompletion:nil];
        }
    } else {
        %orig;
    }
}
%end
%end

%ctor {
	if (kCFCoreFoundationVersionNumber > 1600){
		if ([[CSClassicFolderSettingsManager sharedInstance] enabled]){
			%init(FolderHooks);
		}
	}
}
