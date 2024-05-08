#import <UIKit/UIKit.h>

@implementation UIImage (ClassicFolders)
+ (UIImage *)classicFolderImageNamed:(NSString *)imageNamed {
	return [UIImage imageWithContentsOfFile:[@"/var/jb/Library/Application Support/ClassicFolders.bundle/" stringByAppendingFormat:@"%@.png",imageNamed]];
}
@end
