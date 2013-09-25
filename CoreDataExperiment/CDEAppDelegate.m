#import "CDEAppDelegate.h"
#import "CDEViewController.h"
#import "CDECoreDataManager.h"

@implementation CDEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CDECoreDataManager *manager = [CDECoreDataManager sharedManager];
    if (manager.isRequiredMigration) {
        [manager dropDatabase];
    }
    
    CDEViewController *viewController = [[CDEViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
