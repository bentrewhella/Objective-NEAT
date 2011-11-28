//
//  ONNetwork.h
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 27/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A Network is an array of input ONNodes and an array of output ONNodes
 *
 * The point of a netowrk is to describe a single entity which can evolve
 * or learn on it's own, even though it may be part of a larger network
 */

@interface ONNetwork : NSObject {
    int numNodes;
    int numLinks;
    NSMutableArray * allNodes;
    NSMutableArray * inputNodes;
    NSMutableArray * outputNodes;
}


/** The number of ONNode objects in this network */
@property int numNodes;

/** The number of ONLink objects in the network */
@property int numLinks;

/** An array of all nodes in the network */
@property (retain) NSMutableArray * allNodes;

/** An array of the input nodes */
@property (retain) NSMutableArray * inputNodes;

/** An array of the output nodes */
@property (retain) NSMutableArray * outputNodes;

@end
