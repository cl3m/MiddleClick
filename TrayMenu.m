//
//  TrayMenu.m
//
//  Created by Clem on 21.06.09.
//

#import "TrayMenu.h"
#import "Controller.h"

@implementation TrayMenu

- (id)initWithController:(Controller *)ctrl
{
	[super init];
	myController = ctrl;
	return self;
}
	

- (void) openWebsite:(id)sender {
	NSURL *url = [NSURL URLWithString:@"http://clement.beffa.org/labs/projects/middleclick/"];
	[[NSWorkspace sharedWorkspace] openURL:url];
	//[url release];
}

- (void)setClick:(id)sender
{
	[myController setMode:YES];
	[self setChecks];
}

- (void)setTap:(id)sender
{
	[myController setMode:NO];
	[self setChecks];
}

- (void)setChecks
{
	if([myController getClickMode])
	{
		[clickItem setState:NSOnState];
		[tapItem setState:NSOffState];
	}
	else {
		[clickItem setState:NSOffState];
		[tapItem setState:NSOnState];
	}
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
	
/*	clickItem = [menu addItemWithTitle:@"3 Finger Click" action:@selector(setClick:) keyEquivalent:@""];
	[clickItem setTarget:self];
	
	tapItem = [menu addItemWithTitle:@"3 Finger Tap" action:@selector(setTap:) keyEquivalent:@""];
	[tapItem setTarget:self];
	[self setChecks];
	
	// Add Separator
	[menu addItem:[NSMenuItem separatorItem]];*/
	
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