//
//  Gene.m
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 27/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import "ONGene.h"
#import "ONLink.h"
#import "ONNNode.h"

@implementation ONGene
@synthesize link, innovationNumber, enabled, frozen;

static int innovationCounter = 0;


- (id)initGeneFromNode: (ONNNode *) fromNode toNode: (ONNNode *) toNode weight:(double) wght {
    self = [super init];
    if (self) {
        innovationNumber = innovationCounter++;
        enabled = true;
        frozen = false;
        link = [[ONLink alloc] initLinkFromNode:fromNode toNode:toNode withWeight:wght];
    }
    return self;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"Gene %d: %@ %@", 
            innovationNumber,
            (enabled)?@"Enabled":@"Disabled",
            [link description]];
}


@end
