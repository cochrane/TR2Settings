//
//  FQAppDelegate.m
//  Tomb Raider 2 Settings
//
//  Created by Torsten Kammer on 09.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FQAppDelegate.h"

@interface FQAppDelegate ()

- (void)loadDataFromPlist;
- (NSString *)pathToPlist;
- (void)saveData;

@end

@implementation FQAppDelegate

@synthesize window = _window;

- (void)saveData
{
	NSError *error = nil;
	NSData *propertyList = [NSPropertyListSerialization dataWithPropertyList:self.trProperties.content format:NSPropertyListBinaryFormat_v1_0 options:0 error:&error];
	if (!propertyList)
	{
		[[NSApplication sharedApplication] presentError:error];
		return;
	}
	
	if (![propertyList writeToFile:self.pathToPlist options:NSDataWritingAtomic error:&error])
	{
		[[NSApplication sharedApplication] presentError:error];
		return;
	}
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	[self saveData];
}

- (IBAction)startGame:(NSButton *)sender
{
	// Dirty hack: End editing if user is editing a text field.
	[self.window makeFirstResponder:self.window];
	
	[self saveData];
	
	[[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:@"com.aspyr.tombraider2" options:NSWorkspaceLaunchDefault additionalEventParamDescriptor:NULL launchIdentifier:NULL];
	
	// Terminate on next run through the run loop
	[[NSApplication sharedApplication] performSelector:@selector(terminate:) withObject:self afterDelay:0.0];
}

- (IBAction)revertSettings:(NSButton *)sender
{
	[self loadDataFromPlist];
}

- (NSObjectController *)trProperties
{
	if (!gameSettingsController)
	{
		gameSettingsController = [[NSObjectController alloc] init];
		[self loadDataFromPlist];
	}
	return gameSettingsController;
}

- (NSString *)pathToPlist;
{
	// Ugly. Find better way to find that.
	NSString *preferencesFolder = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences"];
	
	return [preferencesFolder stringByAppendingPathComponent:@"com.aspyr.tombraider2.plist"];
}

- (void)loadDataFromPlist;
{
	NSError *error = nil;
	NSData *fileData = [NSData dataWithContentsOfFile:self.pathToPlist options:0 error:&error];
	
	if (!fileData)
	{
		[[NSApplication sharedApplication] presentError:error];
		return;
	}
	
	id propertyList = [NSPropertyListSerialization propertyListWithData:fileData options:NSPropertyListMutableContainersAndLeaves format:NULL error:&error];
	
	if (!propertyList)
	{
		[[NSApplication sharedApplication] presentError:error];
		return;
	}
	
	gameSettingsController.content = propertyList;
}

#pragma mark - Derived properties

// Necessary to invert the wide screen selection. The NSValueTransformer simply does not work, which is very annoying.
- (BOOL)wideScreen
{
	return ![[self.trProperties.content objectForKey:@"nAspectMode"] boolValue];
}
- (void)setWideScreen:(BOOL)wideScreen
{
	[self.trProperties.content setObject:[NSNumber numberWithInt:!wideScreen] forKey:@"nAspectMode"];
}

- (NSUInteger)fsaaExponent
{
	return (NSUInteger) log2([[self.trProperties.content objectForKey:@"nFSAA"] doubleValue]);
}
- (void)setFsaaExponent:(NSUInteger)fsaaExponent
{
	NSUInteger fsaaValue = 1 << fsaaExponent;
	[self.trProperties.content setObject:[NSNumber numberWithUnsignedInteger:fsaaValue] forKey:@"nFSAA"];
}

- (NSUInteger)linearAdjustExponent
{
	return (NSUInteger) log2([[self.trProperties.content objectForKey:@"nLinearAdjustment"] doubleValue]);
}
- (void)setLinearAdjustExponent:(NSUInteger)linearAdjustExponent
{
	NSUInteger linearAdjustValue = 1 << linearAdjustExponent;
	[self.trProperties.content setObject:[NSNumber numberWithUnsignedInteger:linearAdjustValue] forKey:@"nLinearAdjustment"];
}

- (NSUInteger)nearestAdjustExponent
{
	return (NSUInteger) log2([[self.trProperties.content objectForKey:@"nNearestAdjustment"] doubleValue]);
}
- (void)setNearestAdjustExponent:(NSUInteger)nearestAdjustExponent
{
	NSUInteger nearestAdjustValue = 1 << nearestAdjustExponent;
	[self.trProperties.content setObject:[NSNumber numberWithUnsignedInteger:nearestAdjustValue] forKey:@"nNearestAdjustment"];
}

@end
