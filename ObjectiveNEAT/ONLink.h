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
    ONNNode * inNode;
    ONNNode * outNode;
    Boolean isRecurrent;
}

/** The weight connection of the link */
@property double weight;

/** NNode inputing into the link */
@property (retain) ONNNode * inNode;

/** NNode that the link affects */
@property (retain) ONNNode * outNode;

/** Is the link recurrent 
 *
 *  Not yet used
 */
@property Boolean isRecurrent;

/** Initialiser that takes an input and output node along with a weight */
- (id)initWithInputNode: (ONNNode *) inputNode OutputNode: (ONNNode *) outputNode weight: (double) wght;

@end
