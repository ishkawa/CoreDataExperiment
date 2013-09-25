#import "CDEViewController.h"
#import "CDECoreDataManager.h"
#import "CDEItem.h"

@implementation CDEViewController

- (id)init
{
    self = [super init];
    if (self) {
        NSManagedObjectContext *context = [CDECoreDataManager sharedManager].managedObjectContext;
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[CDEItem entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:YES]];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
        _fetchedResultsController.delegate = self;
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    UIBarButtonItem *addBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                  target:self
                                                  action:@selector(insertNewItem)];
    
    UIBarButtonItem *spaceBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                  target:nil
                                                  action:nil];
    
    UIBarButtonItem *pushBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Push next view controller"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(pushNextViewController)];
    
    self.navigationItem.rightBarButtonItems = @[addBarButtonItem];
    self.toolbarItems = @[spaceBarButtonItem, pushBarButtonItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbarHidden = NO;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        [NSException raise:NSGenericException format:@"%@", error];
    }
}

#pragma mark -

- (void)insertNewItem
{
    NSString *entityName = [CDEItem entityName];
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.parentContext = [CDECoreDataManager sharedManager].managedObjectContext;
    
    [context performBlock:^{
        CDEItem *item = (CDEItem *)[NSEntityDescription insertNewObjectForEntityForName:entityName
                                                                 inManagedObjectContext:context];
        
        item.createdDate = [NSDate date];
        
        NSError *error = nil;
        if (![context save:&error]) {
            [NSException raise:NSGenericException format:@"%@", error];
        }
    }];
}

- (void)pushNextViewController
{
    CDEViewController *viewController = [[CDEViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchedResultsController fetchedObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    CDEItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [item.createdDate description];
    
    return cell;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"called: %@, %d", NSStringFromSelector(_cmd), [self.navigationController.viewControllers indexOfObject:self]);
    [self.tableView reloadData];
}

@end
