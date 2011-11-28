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
@synthesize weight, inNode, outNode, isRecurrent;


- (id)initWithInputNode: (ONNNode *) inputNode OutputNode: (ONNNode *) outputNode weight: (double) wght {
    self = [super init];
    if (self) {
        // the link has an innode
        inNode = inputNode;
        // the innode has the link in it's outgoing array
        [inNode.outGoing addObject:self];
        
        // the link connects to an outnode
        outNode = outputNode;
        // the outnode has the link in it's incoming array
        [outNode.inComing addObject:self];
        
        weight = wght;
    }
    return self;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"Link connecting %@ to %@ with weight: %f", 
            [inNode shortDescription],
            [outNode shortDescription],
            weight];
}

@end
