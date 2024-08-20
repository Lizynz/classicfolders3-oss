#import <dlfcn.h>
#import <UIKit/UIKit.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface UIImage (ClassicFolders)
+ (UIImage *)classicFolderImageNamed:(NSString *)name;
@end

@interface SBWallpaperEffectView : UIView
- (void)setStyle:(int)style;
- (id)initWithWallpaperVariant:(int)wallpaperVariant;
@end

@class SBIcon, SBIconView, SBIconContentView, SBFolderIcon, SBFolder, SBRootFolder, SBFolderView, SBFolderController, SBRootFolderController;

@interface SBApplication : NSObject
@end

@interface SBIcon : NSObject
@end

@interface SBHIconManager : NSObject
- (SBFolderController*)openedFolderController;
- (BOOL)isEditing;
- (id)legibilitySettings;
- (void)closeFolderAnimated:(BOOL)arg1 withCompletion:(id)arg2;
@end

@interface SBIconController : NSObject
@property (nonatomic,readonly) SBFolderController *currentFolderController;
@property (nonatomic,readonly) SBFolderController *openFolderController;
@property (nonatomic,readonly) SBHIconManager *iconManager;
+ (id)sharedInstance;
- (SBRootFolderController *)_rootFolderController;
- (SBIconContentView *)contentView;
- (UIInterfaceOrientation)orientation;
- (BOOL)isEditing;
- (SBFolderController *)_openFolderController;
- (void)iconManager:(id)arg1 launchIconForIconView:(id)arg2;
- (void)iconManager:(SBHIconManager *)arg1 willCloseFolderController:(SBFolderController *)arg2;
@end

@interface SBIconView : UIView
@property (nonatomic,copy) NSString * location; //iOS 14 +
//iOS 13.0 - 13.3
- (void)setAllIconElementsButLabelToHidden:(BOOL)hidden;
//iOS 13.4+
- (void)setAllIconElementsButLabelHidden:(BOOL)hidden;
- (id)_legibilitySettingsWithPrimaryColor:(UIColor *)color;

//iOS 7+
- (void)_applyIconLabelAlpha:(CGFloat)alpha;
- (void)setIconImageAlpha:(CGFloat)alpha;
@end

@interface SBIconListView : UIView
//iOS 13
@property (nonatomic, readonly) NSUInteger iconRowsForCurrentOrientation;
@property (nonatomic, readonly) NSUInteger iconColumnsForCurrentOrientation;
@property (nonatomic, assign) NSInteger orientation;
- (NSArray *)icons;
- (NSArray *)visibleIcons;
- (void)layoutIconsNow;

- (BOOL) classicFolderFrameSet;
- (CGRect) classicFolderFrame;
- (void)setClassicFolderFrame:(CGRect)frame;
- (BOOL)classicFolderInDock;
- (void)setClassicFolderInDock:(BOOL)inDock;

- (SBIconView *)classicFolderIconView;
- (void)setClassicFolderIconView:(SBIconView *)iconView;

- (CGFloat) classicFolderShift;
- (void)setClassicFolderShift:(CGFloat)shift;
@end

@interface SBFolderIconListView : SBIconListView
@end

@interface SBFolderIcon : SBIcon
- (SBFolder *)folder;
@end

@interface SBFolderIconView : SBIconView
- (UIView *)_folderIconImageView;
- (UIView *)iconBackgroundView;
@end

@interface SBFolder : NSObject
- (SBFolderIcon *)icon;
- (NSString *)displayName;
- (NSSet *)allIcons;
- (Class)controllerClass;
@end

@interface SBRootFolder : SBFolder
@end

@interface SBIconListPageControl : UIPageControl
@end

@interface SBFolderView : UIView
@property (retain, nonatomic) SBIconListPageControl *pageControl;
- (BOOL)isEditing;
- (SBFolder *)folder;
- (UIScrollView *)scrollView;
- (SBIconListView *)currentIconListView; //iOS 13+
- (NSArray *)iconListViews;
- (void)resetIconListViews;
- (void)_setFolderName:(NSString *)folderName;
@end

@interface SBFolderContainerView : UIView
- (SBFolderView *)folderView;
- (UIView *)backgroundView;
@end

@interface CSClassicFolderView : SBFolderView <UITextFieldDelegate>
- (void)classicFolderInitWithFolder:(SBFolder *)folder orientation:(int)orientation;
- (UIImage *)flipImage:(UIImage *)image;
- (UIView *)containerView;
- (void)setContainerView:(UIView *)containerView;
- (UIView *)backdropView;
- (void)setBackdropView:(UIView *)backdropView;
- (UIView *)gestureView;
- (void)setGestureView:(UIView *)gestureView;
- (UILabel *)labelView;
- (void)setLabelView:(UILabel *)labelView;
- (UITextField *)labelEditView;
- (void)setLabelEditView:(UITextField *)labelEditView;
- (SBIconView *)folderIconView;
- (void)setFolderIconView:(SBIconView *)folderIconView;
- (UIView *)arrowView;
- (void)setArrowView:(UIView *)arrowView;
- (UIImageView *)arrowBackgroundView;
- (void)setArrowBackgroundView:(UIImageView *)arrowBackgroundView;
- (UIView *)arrowShadowView;
- (void)setArrowShadowView:(UIView *)arrowShadowView;
- (UIView *)arrowBorderView;
- (void)setArrowBorderView:(UIView *)arrowBorderView;
- (SBFolderController *)folderController;
- (void)setFolderController:(SBFolderController *)folderController;
- (CGFloat)magnificationFraction;
- (void)setMagnificationFraction:(CGFloat)magnificationFraction;
- (void)updateArrowViewMask:(UIView *)arrowView;
- (UIView *)topLineLeft;
- (void)setTopLineLeft:(UIView *)topLineLeft;
- (UIView *)topLineRight;
- (void)setTopLineRight:(UIView *)topLineRight;
- (CGRect)wantedFrame;
- (CGFloat)wantedShift:(CGRect)frame;
- (void)openFolder:(BOOL)animated completion:(void (^)(BOOL completed))completion;
- (void)closeFolder:(BOOL)animated completion:(void (^)(BOOL completed))completion;
- (NSArray *)getVisibleViewsUnderFolder;
- (NSInteger)getMaximumIconRowsForPages;
- (void)resetIconListViews;
@end

@interface SBIconContentView : UIView
- (void)initBlurView;
- (BOOL)classicFolderIsOpen;
- (void)setClassicFolderIsOpen:(BOOL)isOpen;
@end

@protocol SBFolderControllerDelegate <NSObject>
- (Class)controllerClassForFolder:(SBFolder *)arg1;
@end

@interface SBFolderControllerConfiguration : NSObject //iOS 13
@property (nonatomic, retain) SBFolder *folder;
@property (nonatomic, assign) NSInteger orientation;
@property (nonatomic, copy) NSString *originatingIconLocation;
@property (nonatomic, assign, weak) NSObject<SBFolderControllerDelegate> *folderDelegate;
@end

@interface SBFolderController : NSObject
- (SBFolderController *)initWithConfiguration:(SBFolderControllerConfiguration *)configuration; //iOS 13+
- (SBFolderController *)expandedChildViewController;
- (SBFolderController *)innerFolderController;
- (SBFolderController *)outerFolderController;
- (SBFolderView *)contentView;
- (BOOL)_iconAppearsOnCurrentPage:(SBIcon *)icon;
- (BOOL)popFolderAnimated:(BOOL)animated completion:(id)completion;
- (BOOL)isOpen;
- (Class) _contentViewClass;
- (void)setEditing:(BOOL)editing;

//iOS 13+
+ (Class)controllerClassForFolder;
- (Class)controllerClassForFolder:(SBFolder *)folder;
+ (Class)configurationClass;
+ (Class)_contentViewClass;
- (SBFolderControllerConfiguration *)configuration;
- (void)configureInnerFolderControllerConfiguration:(SBFolderControllerConfiguration *)configuration;
- (SBFolderIconView *)folderIconView;
- (SBFolder *)folder;
- (NSObject<SBFolderControllerDelegate> *) delegate;
- (BOOL)shouldOpenFolderIcon:(SBFolderIcon *)folderIcon;
- (BOOL)pushNestedViewController:(SBFolderController *)folder animated:(BOOL)animated withCompletion:(id)completion;
- (void)popNestedViewControllerAnimated:(BOOL)animated withCompletion:(id)completion;
- (NSObject<SBFolderControllerDelegate> *)folderDelegate;
- (void)setFolderDelegate:(NSObject<SBFolderControllerDelegate> *)delegate;
- (void)setLegibilitySettings:(id)legibilitySettings;
@end

@interface SBRootFolderView : SBFolderView
- (UIView *)dockView;
- (BOOL) classicFolderFrameSet;
- (CGRect) classicFolderFrame;
- (void)setClassicFolderFrame:(CGRect)frame;
- (BOOL)classicFolderInDock;
- (void)setClassicFolderInDock:(BOOL)inDock;
- (SBIconView *)classicFolderIconView;
- (void)setClassicFolderIconView:(SBIconView *)iconView;
- (CGFloat) classicFolderShift;
- (void)setClassicFolderShift:(CGFloat)shift;
@end

@interface SBRootFolderController : SBFolderController
- (SBRootFolderView *)contentView;
@end

@interface SBFolderIconImageView : UIImageView
-(UIView *)backgroundView;
@end

@interface CSClassicFolderSettingsManager : NSObject {
	NSUserDefaults *_prefs;
}
+ (CSClassicFolderSettingsManager *)sharedInstance;
- (BOOL)enabled;
- (NSInteger)blurBackground;
- (BOOL)modern;
- (BOOL)classic;
- (BOOL)legacy;
- (BOOL)classicIcon;
- (BOOL)classicShape;
- (BOOL)outline;
- (BOOL)autoCloseFolders;
- (CGFloat)speedMultiplier;
@end

@interface ANEMSettingsManager : NSObject
+ (ANEMSettingsManager *)sharedManager;
- (CGFloat)folderIconMaskRadius;
@end

@interface SBFolderPresentingViewController : UIViewController
- (void)dismissPresentedFolderControllerAnimated:(BOOL)arg1 completion:(id)arg2;
- (void)presentFolderController:(id)arg1 animated:(BOOL)arg2 completion:(id)arg3;
- (SBFolderController *)presentedFolderController;
@end

@interface SBFloatingDockViewController : UIViewController <SBFolderControllerDelegate>
- (SBFolderPresentingViewController *)folderPresentingViewController;
- (SBIconListView *)userIconListView;
- (SBIconController *)iconController;
- (BOOL)_shouldOpenFolderIcon:(id)arg1;
- (id)legibilitySettings;
- (void)dismissPresentedFolderAnimated:(BOOL)animated completion:(id)completion;
- (BOOL)pushNestedViewController:(SBFolderController *)folder animated:(BOOL)animated withCompletion:(id)completion;
- (void)dismissPresentedFolderAnimated:(bool)arg1 withTransitionContext:(id)arg2 completion:(id)arg3;
@end

@interface SBHSearchPillView : UIView //iOS 16+
@end

@interface SBSApplicationShortcutItem : NSObject
@property (nonatomic, retain) NSString *type;
@end

@interface _UIBackdropViewSettings : NSObject
+ (id)settingsForStyle:(NSInteger)arg1;
@end

@interface _UIBackdropView : UIView
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
@end
