//
//  Controller.h
//  MiddleClick
//
//  Created by Alex Galonsky on 11/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Controller : NSObject {

}

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

NSDate *touchStartTime;
float middleclickX, middleclickY;
float middleclickX2, middleclickY2;
MTDeviceRef dev;

BOOL needToClick;
BOOL maybeMiddleClick;
BOOL pressed;

int callback(int device, Finger *data, int nFingers, double timestamp, int frame);
- (void) start;
- (void) toggleMode;
- (BOOL)getClickMode;

@end
