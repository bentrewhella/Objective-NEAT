//
//  ONInnovation.m
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 29/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import "ONInnovation.h"
#import "ONInnovationDB.h"
#import "ONGenoLink.h"
#import "ONGenoNode.h"

@implementation ONInnovation
@synthesize nodeOrLink, fromNodeID, toNodeID;


-(NSString *) description {
    if ([nodeOrLink isMemberOfClass: [ONGenoLink class]]) {
        return [NSString stringWithFormat: @"Link Innovation %d between node %d and node %d", 
                [nodeOrLink getInnovationID], fromNodeID, toNodeID];
    }
    if ([nodeOrLink isMemberOfClass: [ONGenoNode class]]) {
        return [NSString stringWithFormat: @"Node Innovation %d between node %d and node %d", 
                [nodeOrLink getInnovationID], fromNodeID, toNodeID];
    }
    return @"unknown";
}


@end
