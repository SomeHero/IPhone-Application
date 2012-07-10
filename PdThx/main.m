//
//  main.m
//  PdThx
//
//  Created by James Rhodes on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retVal = 0;
    @try {
    
        retVal = UIApplicationMain(argc, argv, nil, nil);
    }
    @catch (NSException* e) {
        NSLog(@"Exception - %@", [e description]);
        exit(EXIT_FAILURE);
    }
        
    [pool release];
    return retVal;
}