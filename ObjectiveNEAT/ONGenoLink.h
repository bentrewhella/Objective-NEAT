//
//  ONGenoLink.h
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 27/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONInnovation.h"

/**
 * A GenoLink is a connection from one node to another in the Genotype.
 *
 * It will have an associated weight, which modifies the strength of the signal through the link.
 *
 */

@interface ONGenoLink : NSObject <ONInnovationInformationProtocol>{
    int linkID;
    int fromNode;
    int toNode;
    double weight;
    bool isEnabled;
}

/** 
 * A unique reference for the link, also known as the innovation number.
 * Should be set from the global innovation database via getInnovationID.
 */
@property int linkID;

/** A literal (i.e. non pointer) reference to the links originating node. */
@property int fromNode;

/** A literal (i.e. non pointer) reference to the links terminating node. */
@property int toNode;

/** The weight connection of the link. */
@property double weight;

/** Indicates if the link is active or should be ignored. */
@property bool isEnabled;

/** Initialiser that takes an input and output node along with a weight. */
- (id)initNewlyInnovatedLinkFromNode: (int) fNode toNode: (int) tNode withWeight: (double) wght;

@end
