#import <UIKit/UIKit.h>

@interface CDEViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

@end
