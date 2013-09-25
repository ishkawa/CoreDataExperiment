//#import <Foundation/Foundation.h>
//#import <CoreData/CoreData.h>
//
@interface CDECoreDataManager : NSObject

@property (readonly, nonatomic) BOOL isRequiredMigration;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (NSURL *)modelURL;
+ (NSURL *)storeURL;
+ (CDECoreDataManager *)sharedManager;

- (void)saveContext;
- (void)dropDatabase;

@end
