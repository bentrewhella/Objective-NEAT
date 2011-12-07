//
//  ONGenoLink.m
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 27/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import "ONGenoLink.h"
#import "ONGenoNode.h"
#import "ONInnovationDB.h"

@implementation ONGenoLink
@synthesize linkID, weight, fromNode, toNode, isEnabled;


- (id)initNewlyInnovatedLinkFromNode: (int) fNode toNode: (int) tNode withWeight: (double) wght {
    self = [super init];
    if (self) {
        linkID = [ONInnovationDB getNextInnovationID]; 
        fromNode = fNode;
        toNode = tNode;
        weight = wght;
        isEnabled = true;
        
    }
    return self;
}

-(int) getInnovationID {
    return linkID;
}

-(NSComparisonResult) compareIDWith: (ONGenoLink *) anotherLink {
    if (self.linkID < anotherLink.linkID) {
        return NSOrderedAscending;
    }
    if (self.linkID == anotherLink.linkID) {
        return NSOrderedSame;
    }
    return NSOrderedDescending;
}


-(NSString *) description {
    return [NSString stringWithFormat:@"Link %d connecting %d to %d with weight: %1.3f %@", 
            linkID, fromNode, toNode, weight, (isEnabled)?@"":@"(disabled)"];
}

-(ONGenoLink *) copyWithZone: (NSZone *) zone {
    ONGenoLink * copiedGenoLink = [[ONGenoLink alloc] init];
    copiedGenoLink.linkID = linkID;
    copiedGenoLink.fromNode = fromNode;
    copiedGenoLink.toNode = toNode;
    copiedGenoLink.isEnabled = isEnabled;
    copiedGenoLink.weight = weight;
    return copiedGenoLink;
}

@end
