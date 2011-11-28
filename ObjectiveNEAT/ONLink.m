//
//  Link.m
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 27/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import "ONLink.h"
#import "ONNNode.h"

@implementation ONLink
@synthesize weight, fromNode, toNode, isRecurrent;


- (id)initLinkFromNode: (ONNNode *) fNode toNode: (ONNNode *) tNode withWeight: (double) wght {
    self = [super init];
    if (self) {
        // the link has an from node
        fromNode = fNode;
        // the from node has the link in it's outgoing array
        [fromNode.outGoing addObject:self];
        
        // the link connects to an to node
        toNode = tNode;
        // the to node has the link in it's incoming array
        [toNode.inComing addObject:self];
        
        weight = wght;
    }
    return self;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"Link connecting %@ to %@ with weight: %f", 
            [fromNode shortDescription],
            [toNode shortDescription],
            weight];
}

@end
