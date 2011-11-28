//
//  Gene.h
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 27/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ONLink;
@class ONNNode;

/**
 * A Gene is a Link along with an associated innovation number.
 *
 * Could this be merged with ONLink?  Looks like a 1:1 mapping, however there may be a de-coupling later
 */


@interface ONGene : NSObject {
    ONLink * link;
    int innovationNumber;
    Boolean enabled;
    Boolean frozen;
}

/** The Link referenced by the Gene */
@property (retain) ONLink * link;

/** The global innovation number of the Gene */
@property int innovationNumber;

/** Is the Gene enabled */
@property Boolean enabled;

/** Can the link weight be mutated? 
 *  This may not be needed in simplest solution 
 */
@property Boolean frozen;

/** Initialiser 
 *  Takes an input node, an output node, and a weight
 */
- (id)initGeneFromNode: (ONNNode *) fromNode toNode: (ONNNode *) toNode weight:(double) wght;

@end
