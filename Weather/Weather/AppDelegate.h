//
//  AppDelegate.h
//  Weather
//
//  Created by jakouk on 2017. 3. 1..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

