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

@property NSString* inputDirectoryLocation;
@property BOOL outputUpdateSignal;

@property FSEventStreamRef stream;
@property BOOL eventOccured;
@property BOOL eventStreamCreated;

@end
