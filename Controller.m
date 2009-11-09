//
//  Controller.m
//  MiddleClick
//
//  Created by Alex Galonsky on 11/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Controller.h"
#import <Cocoa/Cocoa.h>
#import "TrayMenu.h"
#include <math.h>
#include <unistd.h>
#include <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h> 
#import "WakeObserver.h"




@implementation Controller

- (void) start
{
	pressed = NO;
	needToClick = YES;
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	
    [NSApplication sharedApplication];
	
	
	//Get list of all multi touch devices
	NSMutableArray* deviceList = (NSMutableArray*)MTDeviceCreateList(); //grab our device list
	
	
	//Iterate and register callbacks for multitouch devices.
	for(int i = 0; i<[deviceList count]; i++) //iterate available devices
	{
		MTRegisterContactFrameCallback((MTDeviceRef)[deviceList objectAtIndex:i], callback); //assign callback for device
		MTDeviceStart((MTDeviceRef)[deviceList objectAtIndex:i]); //start sending events
	}
	
	
	//register a callback to know when osx come back from sleep
	WakeObserver *wo = [[WakeObserver alloc] init];
	[[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: wo selector: @selector(receiveWakeNote:) name: NSWorkspaceDidWakeNotification object: NULL];
	
	
	//add traymenu
    TrayMenu *menu = [[TrayMenu alloc] initWithController:self];
    [NSApp setDelegate:menu];
    [NSApp run];
	
	[pool release];
}

- (BOOL)getClickMode
{
	return needToClick;
}

- (void)setMode:(BOOL)click
{
	needToClick = click;
}

int callback(int device, Finger *data, int nFingers, double timestamp, int frame) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	
	
	if(needToClick)
	{
		
		if(nFingers == 3)
		{
			if(!pressed)
			{
				CGPostKeyboardEvent( (CGCharCode)0, (CGKeyCode)55, true );
				pressed = YES;
			}
			
		}
		else {
			if(pressed)
			{
				CGPostKeyboardEvent( (CGCharCode)0, (CGKeyCode)55, false );
				pressed = NO;
			}
		}
	}
	else 
	{
		if (nFingers==0){
			touchStartTime = NULL;
			if(middleclickX+middleclickY) {
				float delta = ABS(middleclickX-middleclickX2)+ABS(middleclickY-middleclickY2); 
				if (delta < 0.4f) {
					// Emulate a middle click
					
					// get the current pointer location
					CGEventRef ourEvent = CGEventCreate(NULL);
					CGPoint ourLoc = CGEventGetLocation(ourEvent);
					
					/*
					 // CMD+Click code
					 CGPostKeyboardEvent( (CGCharCode)0, (CGKeyCode)55, true );
					 CGPostMouseEvent( ourLoc, 1, 1, 1);
					 CGPostMouseEvent( ourLoc, 1, 1, 0);
					 CGPostKeyboardEvent( (CGCharCode)0, (CGKeyCode)55, false );
					 */
					
					// Real middle click
					CGPostMouseEvent( ourLoc, 1, 3, 0, 0, 1);
					CGPostMouseEvent( ourLoc, 1, 3, 0, 0, 0);
					
				}
			}
			
		} else if (nFingers>0 && touchStartTime == NULL){		
			NSDate *now = [[NSDate alloc] init];
			touchStartTime = [now retain];
			[now release];
			
			maybeMiddleClick = YES;
			middleclickX = 0.0f;
			middleclickY = 0.0f;
		} else {
			if (maybeMiddleClick==YES){
				NSTimeInterval elapsedTime = -[touchStartTime timeIntervalSinceNow];  
				if (elapsedTime > 0.5f)
					maybeMiddleClick = NO;
			}
		}
		
		if (nFingers>3) {
			maybeMiddleClick = NO;
			middleclickX = 0.0f;
			middleclickY = 0.0f;
		}
		
		if (nFingers==3) {
			Finger *f1 = &data[0];
			Finger *f2 = &data[1];
			Finger *f3 = &data[2];
			
			if (maybeMiddleClick==YES) {
				middleclickX = (f1->normalized.pos.x+f2->normalized.pos.x+f3->normalized.pos.x);
				middleclickY = (f1->normalized.pos.y+f2->normalized.pos.y+f3->normalized.pos.y);
				middleclickX2 = middleclickX;
				middleclickY2 = middleclickY;
				maybeMiddleClick=NO;
			} else {
				middleclickX2 = (f1->normalized.pos.x+f2->normalized.pos.x+f3->normalized.pos.x);
				middleclickY2 = (f1->normalized.pos.y+f2->normalized.pos.y+f3->normalized.pos.y);
			}
		}
	}

	
	[pool release];
	return 0;
}

@end
