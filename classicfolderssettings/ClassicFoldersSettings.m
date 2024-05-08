#import <Social/Social.h>
#import <spawn.h>

extern char **environ;

@interface PSListController : UITableViewController {
	id _specifiers;
}
- (id)loadSpecifiersFromPlistName:(NSString *)plistName target:(id)target;
- (UITableView *)table;
@end

@interface ClassicFoldersSettingsListController: PSListController {
}
@end

@implementation ClassicFoldersSettingsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"ClassicFoldersSettings" target:self];
	}
	return _specifiers;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width, 121)];
	headerView.tag = 23491234;
	headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[headerView setBackgroundColor:[UIColor colorWithRed:0 green:(122.f/255.f) blue:1.f alpha:1.0f]];

	UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,121)];
	titleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	[titleView setImage:[UIImage imageWithContentsOfFile:@"/var/jb/Library/PreferenceBundles/ClassicFoldersSettings.bundle/banner.png"]];
	[titleView setBackgroundColor:[UIColor colorWithRed:0 green:(122.f/255.f) blue:1.f alpha:1.0f]];
	[headerView addSubview:titleView];

	[[self table] addSubview:headerView];
	[[self table] setContentOffset:CGPointMake(0,0)];

	[[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/var/jb/Library/PreferenceBundles/ClassicFoldersSettings.bundle/heart.png"] style:UIBarButtonItemStylePlain target:self action:@selector(tweet:)]];
}

- (void)tweet:(id)sender {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
#pragma clang diagnostic pop
	[tweetSheet setInitialText:@"I am loving #ClassicFolders3 by @CStar_OW and @JeremyGoulet!"];
	[self presentViewController:tweetSheet animated:YES completion:nil];
}

- (void)respring:(id)sender {
    pid_t pid;
    int status;
    const char* args[] = { "killall", "-9", "SpringBoard", NULL };
    posix_spawn(&pid, "/var/jb/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
    waitpid(pid, &status, WEXITED);
}

- (void)coolstarTwitter:(id)sender {
	NSString *user = @"CStar_OW";
	UIApplication *app = [UIApplication sharedApplication];
	if([app canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
		[app openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]] options:@{} completionHandler:nil];
	
	else if([app canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
		[app openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:user]] options:@{} completionHandler:nil];
	
	else if([app canOpenURL:[NSURL URLWithString:@"tweetings:"]])
		[app openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]] options:@{} completionHandler:nil];
	
	else if([app canOpenURL:[NSURL URLWithString:@"twitter:"]])
		[app openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]] options:@{} completionHandler:nil];
	
	else
		[app openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]] options:@{} completionHandler:nil];
}
- (void)jeremyTwitter:(id)sender {
	NSString *user = @"JeremyGoulet";
	UIApplication *app = [UIApplication sharedApplication];
	if([app canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
		[app openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]] options:@{} completionHandler:nil];
	
	else if([app canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
		[app openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:user]] options:@{} completionHandler:nil];
	
	else if([app canOpenURL:[NSURL URLWithString:@"tweetings:"]])
		[app openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]] options:@{} completionHandler:nil];
	
	else if([app canOpenURL:[NSURL URLWithString:@"twitter:"]])
		[app openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]] options:@{} completionHandler:nil];
	
	else
		[app openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]] options:@{} completionHandler:nil];
}
@end

// vim:ft=objc
