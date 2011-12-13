/*
 * ObjectiveNEAT 0.1.0
 * Author: Ben Trewhella
 *
 * Copyright (c) 2011 OpposableIntelligence.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

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
    [newInnovation release];
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
    [newInnovation release];
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

-(void) dealloc {
    [linkInnovations release];
    [nodeRecord release];
    [super dealloc];
}

+(ONInnovationDB *) sharedDB {
    if (sharedInnovationDB == nil) {
        sharedInnovationDB = [[ONInnovationDB alloc] init];
    }
    return sharedInnovationDB;
}

@end
