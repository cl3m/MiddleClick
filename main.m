//
//  MiddleClick
//  main.m
//
//  Created by Clem on 21.06.09.
//

#import <Cocoa/Cocoa.h>
#import "TrayMenu.h"
#include <math.h>
#include <unistd.h>
#include <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h> 
#import "WakeObserver.h"

typedef struct { float x,y; } mtPoint;
typedef struct { mtPoint pos,vel; } mtReadout;

typedef struct {
	int frame;
	double timestamp;
	int identifier, state, foo3, foo4;
	mtReadout normalized;
	float size;
	int zero1;
	float angle, majorAxis, minorAxis; // ellipsoid
	mtReadout mm;
	int zero2[2];
	float unk2;
} Finger;

typedef int MTDeviceRef;
typedef int (*MTContactCallbackFunction)(int,Finger*,int,double,int);

MTDeviceRef MTDeviceCreateDefault();
void MTRegisterContactFrameCallback(MTDeviceRef, MTContactCallbackFunction);
void MTDeviceStart(MTDeviceRef);
CFMutableArrayRef MTDeviceCreateList(void); //returns a CFMutableArrayRef array of all multitouch devices

BOOL maybeMiddleClick;
NSDate *touchStartTime;
float middleclickX, middleclickY;
float middleclickX2, middleclickY2;
MTDeviceRef dev;
BOOL pressed = NO;

int callback(int device, Finger *data, int nFingers, double timestamp, int frame) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	

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

	[pool release];
	return 0;
}

int main(int argc, char *argv[]) {
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
    TrayMenu *menu = [[TrayMenu alloc] init];
    [NSApp setDelegate:menu];
    [NSApp run];
	
	[pool release];
    return EXIT_SUCCESS;
}