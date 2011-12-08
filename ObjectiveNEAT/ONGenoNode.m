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
