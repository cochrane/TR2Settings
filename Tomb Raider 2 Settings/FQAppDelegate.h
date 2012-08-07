//
//  FQAppDelegate.h
//  Tomb Raider 2 Settings
//
//  Created by Torsten Kammer on 09.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FQAppDelegate : NSObject <NSApplicationDelegate>
{
	NSObjectController *gameSettingsController;
}

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, readonly) NSObjectController *trProperties;

@property (nonatomic, assign) BOOL wideScreen;
@property (nonatomic, assign) NSUInteger fsaaExponent;
@property (nonatomic, assign) NSUInteger linearAdjustExponent;
@property (nonatomic, assign) NSUInteger nearestAdjustExponent;

- (IBAction)startGame:(NSButton *)sender;
- (IBAction)revertSettings:(NSButton *)sender;

@end
