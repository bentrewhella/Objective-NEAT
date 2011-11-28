//
//  Link.h
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 27/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ONNNode;

/**
 * A Link is a connection from one node to another with an associated weight.
 *
 */

@interface ONLink : NSObject {
    double weight;
    ONNNode * fromNode;
    ONNNode * toNode;
    Boolean isRecurrent;
}

/** The weight connection of the link */
@property double weight;

/** NNode inputting into the link */
@property (retain) ONNNode * fromNode;

/** NNode that the link affects */
@property (retain) ONNNode * toNode;

/** Is the link recurrent 
 *
 *  Not yet used
 */
@property Boolean isRecurrent;

/** Initialiser that takes an input and output node along with a weight */
- (id)initLinkFromNode: (ONNNode *) fNode toNode: (ONNNode *) tNode withWeight: (double) wght;

@end
