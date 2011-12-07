//
//  ONGenoNode.m
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 27/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import "ONGenoNode.h"
#import "ONGenoLink.h"
#import "ONInnovationDB.h"

@implementation ONGenoNode
@synthesize nodeID, nodeType, nodePosition;

-(int) getInnovationID {
    return nodeID;
}

-(NSComparisonResult) compareIDWith: (ONGenoNode *) anotherNode {
    if (self.nodeID < anotherNode.nodeID) {
        return NSOrderedDescending;
    }
    if (self.nodeID == anotherNode.nodeID) {
        return NSOrderedSame;
    }
    return NSOrderedAscending;
}

-(NSString *) description {
       
    NSString * nodePositionString;
    switch (nodeType) {
        case HIDDEN: 
            nodePositionString = @"Hidden"; 
            break;
        case INPUT:
            nodePositionString = @"Input";
            break;
        case OUTPUT:
            nodePositionString = @"Output";
            break;
        case BIAS:
            nodePositionString = @"Bias";
            break;
        default:
            nodePositionString = @"Unknown"; // error
            break;
    }
    
    return [NSString stringWithFormat:@"%@ Node %i at (%1.1f, %1.1f)",
            nodePositionString, nodeID, nodePosition.x, nodePosition.y];
}

-(ONGenoNode *) copyWithZone: (NSZone *) zone {
    ONGenoNode * copiedGenoNode = [[ONGenoNode alloc] init];
    copiedGenoNode.nodeID = nodeID;
    copiedGenoNode.nodeType = nodeType;
    copiedGenoNode.nodePosition = nodePosition;
    return copiedGenoNode;
}

@end
