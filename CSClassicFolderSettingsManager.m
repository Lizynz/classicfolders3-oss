#import "Headers.h"

@implementation CSClassicFolderSettingsManager
+ (instancetype)sharedInstance {
    static CSClassicFolderSettingsManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}
- (CSClassicFolderSettingsManager *)init {
	self = [super init];
	_prefs = [[NSUserDefaults alloc] initWithSuiteName:@"org.coolstar.classicfolders"];
    [_prefs registerDefaults:@{
        @"enabled": @YES,
        @"mode": @0,
        @"labelColor":@0,
        @"blurBackground":@0,
        @"classicIcon":@NO,
        @"classicshape": @NO,
        @"outline": @NO,
        @"autoCloseFolders": @NO,
        @"tapToCloseFolders": @NO,
        @"speedMultiplier": @1
    }];
	return self;
}

- (BOOL)enabled {
	return [_prefs boolForKey:@"enabled"];
}

- (NSInteger)labelColor {
    return [_prefs integerForKey:@"labelColor"];
}

- (NSInteger)blurBackground {
	return [_prefs integerForKey:@"blurBackground"];
}

- (BOOL)modern {
	NSInteger mode = [_prefs integerForKey:@"mode"];
	return (mode == 0);
}

- (BOOL)classic {
	NSInteger mode = [_prefs integerForKey:@"mode"];
	return ((mode == 2) || (mode == 3));
}

- (BOOL)legacy {
	NSInteger mode = [_prefs integerForKey:@"mode"];
	return (mode == 3);
}

- (BOOL)classicIcon {
	return [_prefs boolForKey:@"classicIcon"];
}

- (BOOL)classicShape {
	return [_prefs boolForKey:@"classicshape"];
}

- (BOOL)outline {
	return [_prefs boolForKey:@"outline"];
}

- (BOOL)autoCloseFolders {
     return [_prefs boolForKey:@"autoCloseFolders"];
 }

- (BOOL)tapToCloseFolders {
     return [_prefs boolForKey:@"tapToCloseFolders"];
 }

- (CGFloat)speedMultiplier {
	return [_prefs floatForKey:@"speedMultiplier"];
}
@end
