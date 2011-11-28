//
//  ONNNode.h
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 27/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//



#import <Foundation/Foundation.h>

typedef enum NodeType {
    NEURON = 0,
    SENSOR = 1
} NodeType;

typedef enum NodePosition {
    HIDDEN = 0,
    INPUT,
    OUTPUT,
    BIAS
} NodePosition;


/**
 * A Neural Node is either a NEURON or a SENSOR.
 *
 *  - If it's a sensor, it can be loaded with a value for output
 *  - If it's a neuron, it has a mutable array of incoming input signals
 */
@interface ONNNode : NSObject {
    NSMutableArray * inComing;
    NSMutableArray * outGoing;
    int nodeID;
    NodeType nodeType; 
    NodePosition nodePosition;
    
    double activation;
}

/** An array of incoming links 
 *
 *  i.e. whose weighted output will be evaluated as input to the node. 
 */
@property (retain) NSMutableArray * inComing;

/** An array of outgoing links, i.e. the value of this neural node will be passed as input to these links. */
@property (retain) NSMutableArray * outGoing;

/** The type of Node, i.e. a Neuron or a Sensor 
 *  - Neuron = 0
 *  - Sensor = 1
 */
@property NodeType nodeType;

/** The Node's position within the network
 *  - Hidden = 0
 *  - Input  = 1
 *  - Output = 2
 *  - Bias   = 3
 */
@property NodePosition nodePosition;

/** The value of the node.
 *
 *  If the node is a sensor, this may be loaded immediately
 *  If a Neuron, this will be calculated by activating the network
 */
@property double activation;


/** Sigmoid Function
 *
 *  This is a signmoidal activation function, which is an S-shaped squashing function
 *  It smoothly limits the amplitude of the output of a neuron to between 0 and 1
 *  It is a helper to the neural-activation function get_active_out
 *  It is made inline so it can execute quickly since it is at every non-sensor 
 *  node in a network.
 *
 *  NOTE:  In order to make node insertion in the middle of a link possible,
 *  the signmoid can be shifted to the right and more steeply sloped:
 *  - slope    = 4.924273
 *  - constant = 2.4621365
 *
 *  These parameters optimize mean squared error between the old output,
 *  and an output of a node inserted in the middle of a link between
 *  the old output and some other node. 
 *
 *  When not right-shifted, the steepened slope is closest to a linear
 *  ascent as possible between -0.5 and 0.5
 */ 
double fsigmoid(double activesum, double slope, double constant);

/** Activates the node
 *
 * Sums up the incoming link values and rusn through it's own activation function
 * At this stage this is just the sigmoid function
 */
-(void) activate;

-(NSString *) shortDescription;

@end
