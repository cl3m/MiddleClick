//
//  TrayMenu.m
//
//  Created by Clem on 21.06.09.
//

#import "TrayMenu.h"


@implementation TrayMenu

- (void) openWebsite:(id)sender {
	NSURL *url = [NSURL URLWithString:@"http://clement.beffa.org/labs/projects/middleclick/"];
	[[NSWorkspace sharedWorkspace] openURL:url];
	//[url release];
}

- (void) openFinder:(id)sender {
	[[NSWorkspace sharedWorkspace] launchApplication:@"Finder"];
}

- (void) actionQuit:(id)sender {
	[NSApp terminate:sender];
}

- (NSMenu *) createMenu {
	NSZone *menuZone = [NSMenu menuZone];
	NSMenu *menu = [[NSMenu allocWithZone:menuZone] init];
	NSMenuItem *menuItem;
	
	// Add About
	menuItem = [menu addItemWithTitle:@"About MiddleClick"
							   action:@selector(openWebsite:)
						keyEquivalent:@""];
	[menuItem setTarget:self];
	// Add Separator
	[menu addItem:[NSMenuItem separatorItem]];
	
	// Add Quit Action
	menuItem = [menu addItemWithTitle:@"Quit"
							   action:@selector(actionQuit:)
						keyEquivalent:@""];
	[menuItem setTarget:self];
	
	return menu;
}

- (void) applicationDidFinishLaunching:(NSNotification *)notification {
	NSMenu *menu = [self createMenu];
	
	_statusItem = [[[NSStatusBar systemStatusBar]
					statusItemWithLength:NSSquareStatusItemLength] retain];
	[_statusItem setMenu:menu];
	[_statusItem setHighlightMode:YES];
	[_statusItem setToolTip:@"MiddleClick"];
	[_statusItem setImage:[NSImage imageNamed:@"mouse.png"]];
	
	[menu release];
}

@end