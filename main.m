//
//  MiddleClick
//  main.m
//
//  Created by Clem on 21.06.09.
//


#import "Controller.h"

Controller *con;

int main(int argc, char *argv[]) {
	
	con = [[Controller alloc] init];
	[con start];
    
    return EXIT_SUCCESS;
}