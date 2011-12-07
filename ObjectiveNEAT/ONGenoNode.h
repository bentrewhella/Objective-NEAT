//
//  ONGenoNode.h
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 27/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "ONInnovation.h"

/**
 * A GenoNode represents a Neural Node within the Genotype/Genome.
 *  
 * It is either a sensor (INPUT or BIAS) or a neuron (HIDDEN or OUTPUT):
 *  - If it's a sensor, it can be loaded with a value for output
 *  - If it's a neuron, it has a mutable array of incoming input signals.
 *
 * There will be a first layer of INPUT sensors including at least one BIAS sensor
 * The remaining neurons will consist of HIDDEN or OUTPUT nodes.
 * 
 * Each GenoNode records also records it's {x, y} (range 0-1) within the network
 * Simply because this is easier to work out in creation rather than afterwards
 * This can be used to draw the genome if required.
 */


typedef enum NodeType {
    UNKNOWN = 0,
    INPUT,
    HIDDEN,
    OUTPUT,
    BIAS,
} NodeType;


@interface ONGenoNode : NSObject <ONInnovationInformationProtocol> {
    int nodeID;
    NodeType nodeType; 
    CGPoint nodePosition;
}

/** The unique identifier for this node, which should be set from the global innovation database method getNextGenomeID.
 *  
 *  All references in the Genotype are literal (i.e. no pointers).
 */
@property int nodeID;

/** The type of the node
 *  - Unknown= 0 (i.e. not initialised)
 *  - Hidden = 1
 *  - Input  = 2
 *  - Output = 3
 *  - Bias   = 4
 */
@property NodeType nodeType;

/** The position within the network.
 *  Vales between 0 and 1.
 */
@property CGPoint nodePosition;


@end
