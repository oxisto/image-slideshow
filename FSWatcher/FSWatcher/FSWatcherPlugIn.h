//
//  FSWatcherPlugIn.h
//  FSWatcher
//
//  Created by Christian Banse on 17/05/15.
//  Copyright (c) 2015 Christian Banse. All rights reserved.
//

@import CoreServices;

#import <Quartz/Quartz.h>

@interface FSWatcherPlugIn : QCPlugIn

+ (NSMutableArray *)scanDirectory:(NSString *)dir;

@property NSString* inputDirectoryLocation;
@property BOOL outputUpdateSignal;
@property(copy) NSString* outputAddedImage;

@property FSEventStreamRef stream;
@property BOOL eventOccured;
@property BOOL eventStreamCreated;

@property NSMutableArray* imagesAdded;
@property NSMutableArray* images;

@end
