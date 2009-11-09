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
#import "Controller.h"

Controller *con;

int main(int argc, char *argv[]) {
	con = [[Controller alloc] init];
	[con start];
    
    return EXIT_SUCCESS;
}