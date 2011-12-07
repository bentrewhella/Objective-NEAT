//
//  ONPhenoLink.m
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 29/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import "ONPhenoLink.h"
#import "ONPhenoNode.h"

@implementation ONPhenoLink
@synthesize weight, fromNode, toNode, isEnabled;


-(NSString *) description {
    return [NSString stringWithFormat:@"Link connecting %d to %d with weight: %1.3f %@", 
            fromNode.nodeID, toNode.nodeID, weight, (isEnabled)?@"":@"(disabled)"];
}


@end
