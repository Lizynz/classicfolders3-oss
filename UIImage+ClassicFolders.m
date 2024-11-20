#import <UIKit/UIKit.h>
#include <roothide.h>

@implementation UIImage (ClassicFolders)
+ (UIImage *)classicFolderImageNamed:(NSString *)imageNamed {
	return [UIImage imageWithContentsOfFile:[jbroot(@"/Library/Application Support/ClassicFolders.bundle/") stringByAppendingFormat:@"%@.png",imageNamed]];
}
@end
