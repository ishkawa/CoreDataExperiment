//
//  CDEAppDelegate.h
//  CoreDataExperiment
//
//  Created by Yosuke Ishikawa on 9/26/13.
//  Copyright (c) 2013 Yosuke Ishikawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
