#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CDEItem : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSDate *createdDate;

+ (NSString *)entityName;

@end
