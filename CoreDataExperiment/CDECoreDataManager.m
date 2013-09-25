#import "CDECoreDataManager.h"

@implementation CDECoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (NSURL *)modelURL
{
    return [[NSBundle mainBundle] URLForResource:@"CoreDataExperiment" withExtension:@"momd"];
}

+ (NSURL *)storeURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *documentURLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentURL = [documentURLs lastObject];
    
    return [documentURL URLByAppendingPathComponent:@"CoreDataExperiment.sqlite"];
}

#pragma mark -

+ (CDECoreDataManager *)sharedManager
{
    static CDECoreDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CDECoreDataManager alloc] init];
    });
    
    return manager;
}

#pragma mark - accessors

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    _managedObjectContext.stalenessInterval = 0.0;
    _managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[self class] modelURL]];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSError *error = nil;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[[self class] storeURL] options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

- (BOOL)isRequiredMigration
{
    NSError *error = nil;
    NSDictionary *metaData = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:[[self class] storeURL] error:&error];
    if (error.code == NSFileReadNoSuchFileError) {
        return NO;
    } else if (error.code == NSPersistentStoreInvalidTypeError) {
        return YES;
    } else if (error) {
        NSLog(@"could not obtain metadata of persistent store: %@(%@)", [error localizedDescription], [error userInfo]);
        abort();
    }
    
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[self class] modelURL]];
    return ![model isConfiguration:nil compatibleWithStoreMetadata:metaData];
}

#pragma mark -

- (void)saveContext
{
    if (![self.managedObjectContext hasChanges]) {
        return;
    }
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)dropDatabase
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *URL = [[self class] storeURL];
    if ([fileManager fileExistsAtPath:[URL path]]) {
        NSError *error = nil;
        if (![fileManager removeItemAtURL:URL error:&error]) {
            NSLog(@"error: %@", error);
            abort();
        }
    }
    
    _managedObjectModel = nil;
    _persistentStoreCoordinator = nil;
    _managedObjectContext = nil;
}

@end
