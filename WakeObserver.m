//
//  WakeObserver.m
//
//  Created by Clem on 18.10.09.
//

#import "WakeObserver.h"


@implementation WakeObserver

- (void) receiveWakeNote: (NSNotification*) note
{
	[NSThread sleepForTimeInterval:10.0]; //wait 10 sec before restarting to be sure everthing is up
	
	NSString *relaunch = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"relaunch"];
	int procid = [[NSProcessInfo processInfo] processIdentifier];
	[NSTask launchedTaskWithLaunchPath:relaunch arguments:[NSArray arrayWithObjects:[[NSBundle mainBundle] bundlePath], [NSString stringWithFormat:@"%d",procid], nil]];
	[NSApp terminate:NULL];
}


@end
