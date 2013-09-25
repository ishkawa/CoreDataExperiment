#import "CDEItem.h"

@implementation CDEItem

@dynamic name;
@dynamic identifier;
@dynamic createdDate;

+ (NSString *)entityName
{
    return NSStringFromClass([self class]);
}

@end
