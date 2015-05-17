//
//  FSWatcherPlugIn.m
//  FSWatcher
//
//  Created by Christian Banse on 17/05/15.
//  Copyright (c) 2015 Christian Banse. All rights reserved.
//

// It's highly recommended to use CGL macros instead of changing the current context for plug-ins that perform OpenGL rendering
#import <OpenGL/CGLMacro.h>

#import "FSWatcherPlugIn.h"

#define	kQCPlugIn_Name				@"FSWatcher"
#define	kQCPlugIn_Description		@"Watches a directory for changes"


@implementation FSWatcherPlugIn

@dynamic inputDirectoryLocation;
@dynamic outputUpdateSignal;

void callbackFunction(ConstFSEventStreamRef streamRef, void *clientCallBackInfo, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags eventFlags[], const FSEventStreamEventId eventIds[]) {

    CFArrayRef paths = eventPaths;
    
    for(int i = 0; i < numEvents; i++) {
        if(clientCallBackInfo != NULL) {
            FSWatcherPlugIn *plugin = (__bridge FSWatcherPlugIn*) clientCallBackInfo;
            plugin.eventOccured = YES;
            
            CFStringRef path = CFArrayGetValueAtIndex(paths, i);
            NSLog(@"Callback called with path %@!", path);
        }
    }
}

// Here you need to declare the input / output properties as dynamic as Quartz Composer will handle their implementation
//@dynamic inputFoo, outputBar;

+ (NSDictionary *)attributes
{
	// Return a dictionary of attributes describing the plug-in (QCPlugInAttributeNameKey, QCPlugInAttributeDescriptionKey...).
    return @{QCPlugInAttributeNameKey:kQCPlugIn_Name, QCPlugInAttributeDescriptionKey:kQCPlugIn_Description};
}

+ (NSDictionary *)attributesForPropertyPortWithKey:(NSString *)key
{
    /* Return the attributes for the plug-in property ports */
    if([key isEqualToString:@"inputDirectoryLocation"])
        return @{QCPortAttributeNameKey:@"Directory Location", QCPortAttributeDefaultValueKey:@"~/Desktop/Bilder"};
    
    if([key isEqualToString:@"outputUpdateSignal"])
        return @{QCPortAttributeNameKey:@"Update Signal"};
    
    return nil;
}

+ (QCPlugInExecutionMode)executionMode
{
	return kQCPlugInExecutionModeProvider;
}

+ (QCPlugInTimeMode)timeMode
{
	// Return the time dependency mode of the plug-in: kQCPlugInTimeModeNone, kQCPlugInTimeModeIdle or kQCPlugInTimeModeTimeBase.
	return kQCPlugInTimeModeIdle;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		// Allocate any permanent resource required by the plug-in.
	}
	
	return self;
}

@end

@implementation FSWatcherPlugIn (Execution)

- (BOOL)startExecution:(id <QCPlugInContext>)context
{
	// Called by Quartz Composer when rendering of the composition starts: perform any required setup for the plug-in.
	// Return NO in case of fatal failure (this will prevent rendering of the composition to start).
    
	return YES;
}

- (void)enableExecution:(id <QCPlugInContext>)context
{
	// Called by Quartz Composer when the plug-in instance starts being used by Quartz Composer.
}

- (BOOL)execute:(id <QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary *)arguments
{
    // we need to do lazy intialisation, since the value
    if(!_eventStreamCreated) {
        NSString *path = self.inputDirectoryLocation.stringByStandardizingPath;
        
        NSLog(@"Input direction location is: %@", path);
        
        CFStringRef directory = (__bridge CFStringRef) path;
        CFArrayRef pathsToWatch = CFArrayCreate(NULL, (const void **) &directory, 1, NULL);
        
        CFAbsoluteTime latency = 1.0;
        
        FSEventStreamContext ctx;
        ctx.version = 0;
        ctx.info = (__bridge void *)(self);
        ctx.release = NULL;
        ctx.retain = NULL;
        
        NSLog(@"Creating FSEventStream...");
        
        self.stream = FSEventStreamCreate(NULL, &callbackFunction, &ctx, pathsToWatch, kFSEventStreamEventIdSinceNow, latency, kFSEventStreamCreateFlagUseCFTypes);
        
        FSEventStreamScheduleWithRunLoop(self.stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
        FSEventStreamStart(self.stream);
        
        _eventStreamCreated = YES;
    }
    
    // signal the composer
    self.outputUpdateSignal = self.eventOccured;

    // and reset the event tracker
    if(self.eventOccured) {
        self.eventOccured = NO;
    }
	
	return YES;
}

- (void)disableExecution:(id <QCPlugInContext>)context
{
	// Called by Quartz Composer when the plug-in instance stops being used by Quartz Composer.
}

- (void)stopExecution:(id <QCPlugInContext>)context
{
	// Called by Quartz Composer when rendering of the composition stops: perform any required cleanup for the plug-in.
    if(_eventStreamCreated) {
        NSLog(@"Stopping and releasing FSEventStream...");
        FSEventStreamStop(self.stream);
        FSEventStreamUnscheduleFromRunLoop(self.stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
        FSEventStreamInvalidate(self.stream);
        FSEventStreamRelease(self.stream);
        _eventStreamCreated = NO;
    }
}

@end
