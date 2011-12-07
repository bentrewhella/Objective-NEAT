//
//  ONInnovationDB.m
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 29/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import "ONInnovationDB.h"
#import "ONInnovation.h"
#import "ONGenoNode.h"
#import "ONGenoLink.h"

@implementation ONInnovationDB

static int nodeCounter = 0;
static int innovationCounter = 0;

static ONInnovationDB * sharedInnovationDB;


- (id)init
{
    self = [super init];
    if (self) {
        linkInnovations = [[NSMutableArray alloc] init];
        nodeRecord = [[NSMutableArray alloc] init];
    }
    return self;
}

-(ONGenoNode *) getNodeWithID: (int) nodeID {
    for (ONInnovation * nextNode in nodeRecord) {
        if ([nextNode.nodeOrLink getInnovationID] == nodeID) {
            return [nextNode.nodeOrLink copy];
        }
    }
    return nil; 
}

-(ONGenoNode *) possibleNodeExistsFromNode: (int) fNode toNode: (int) tNode {
    for (ONInnovation * nextInnovation in nodeRecord) {
        if (nextInnovation.fromNodeID == fNode &&
            nextInnovation.toNodeID == tNode) {
            return [nextInnovation.nodeOrLink copy];
        }
    }
    return nil;
}

-(void) insertNewNode:(ONGenoNode *) newNode fromNode:(int) fNode toNode: (int) tNode {
    ONInnovation * newInnovation = [[ONInnovation alloc] init];
    newInnovation.nodeOrLink = [newNode copy];
    newInnovation.fromNodeID = fNode;
    newInnovation.toNodeID = tNode;
    [nodeRecord addObject:newInnovation];
}


-(ONGenoLink *) possibleLinkExistsFromNode: (int) fNode toNode: (int) tNode {
    for (ONInnovation * nextInnovation in linkInnovations) {
        if (nextInnovation.fromNodeID == fNode &&
            nextInnovation.toNodeID == tNode) {
            return [nextInnovation.nodeOrLink copy];
        }
    }
    return nil;
}

-(void) insertNewLink:(ONGenoLink *) newLink fromNode:(int) fNode toNode: (int) tNode {
    ONInnovation * newInnovation = [[ONInnovation alloc] init];
    newInnovation.nodeOrLink = [newLink copy];
    newInnovation.fromNodeID = fNode;
    newInnovation.toNodeID = tNode;
    [linkInnovations addObject:newInnovation];
}



-(NSString *) description {
    return [NSString stringWithFormat:@"%@%@", [nodeRecord description], [linkInnovations description]];
}

+(int) getNextGenoNodeID {
    return nodeCounter++;
}

+(int) getNextInnovationID {
    return innovationCounter++;
}

+(ONInnovationDB *) sharedDB {
    if (sharedInnovationDB == nil) {
        sharedInnovationDB = [[ONInnovationDB alloc] init];
    }
    return sharedInnovationDB;
}

@end
