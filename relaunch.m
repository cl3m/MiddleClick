/*
Copyright (c) 2006 Andy Matuschak
 
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/ 

#import <AppKit/AppKit.h>

#include <unistd.h>

@interface TerminationListener : NSObject
{
	const char *executablePath;
	pid_t parentProcessId;
}

- (void) relaunch;

@end

@implementation TerminationListener

- (id) initWithExecutablePath:(const char *)execPath parentProcessId:(pid_t)ppid
{
	self = [super init];
	if (self != nil)
	{
		executablePath = execPath;
		parentProcessId = ppid;
		if (getppid() == 1) // ppid is launchd (1) => parent terminated already
			[self relaunch];
		[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(watchdog:) userInfo:nil repeats:YES];
	}
	return self;
}

- (void)watchdog:(NSTimer *)timer
{
	ProcessSerialNumber psn;
	if (GetProcessForPID(parentProcessId, &psn) == procNotFound)
		[self relaunch];
}

- (void) relaunch
{
	[[NSWorkspace sharedWorkspace] openFile:[[NSFileManager defaultManager] stringWithFileSystemRepresentation:executablePath length:strlen(executablePath)]];
	//[[NSFileManager defaultManager] removeFileAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"relaunch"] handler:nil];
	exit(0);
}

@end

int main (int argc, const char * argv[])
{
	if (argc != 3) return EXIT_FAILURE;
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[NSApplication sharedApplication];
	[[[TerminationListener alloc] initWithExecutablePath:argv[1] parentProcessId:atoi(argv[2])] autorelease];
	[[NSApplication sharedApplication] run];
	
	[pool drain];
	
	return EXIT_SUCCESS;
}
