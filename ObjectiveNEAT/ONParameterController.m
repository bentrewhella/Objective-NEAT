//
//  ONParameterController.m
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 27/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import "ONParameterController.h"

@implementation ONParameterController 

static double weightMutationPower;

+(Boolean) loadParametersFromPList: (NSString *) filename {
    if (filename == nil) {
        NSLog(@"No PList name provided, using p2test as a default");
        filename = @"p2test";
    }
    // just in case the user passed in a filename with extension .plist, remove this
    filename = [filename stringByReplacingOccurrencesOfString:@".plist" withString:@""];
    
    NSString * errorDesc = nil;
    NSPropertyListFormat format;
    NSString *pListPath = [[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:@"plist"];
    
    NSData * plistXML = [[NSFileManager defaultManager] contentsAtPath:pListPath];
    NSDictionary *temp = (NSDictionary *) [NSPropertyListSerialization propertyListFromData:plistXML 
                                                                           mutabilityOption:NSPropertyListMutableContainersAndLeaves 
                                                                                     format:&format 
                                                                           errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading parameters %@.plist: %@, format: %lu", filename, errorDesc, format);
        return FALSE;
    }
    
    NSLog(@"Parameters file %@.plist loaded ok", filename);
    
    // now we have the file - set the parameters 
    weightMutationPower = [(NSNumber *) [temp objectForKey:@"weight_mut_power"] doubleValue];
    return TRUE;
}

+(double) weightMutationPower {
    return weightMutationPower;
}


@end
