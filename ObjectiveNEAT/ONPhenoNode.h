/*
 * ObjectiveNEAT 0.1.0
 * Author: Ben Trewhella
 *
 * Copyright (c) 2011 OpposableIntelligence.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import <Foundation/Foundation.h>
#import "ONGenoNode.h"

/**
 * A PhenoNode represents a Neural Node within the Phenotype / Network
 *  
 * It is either a sensor (INPUT or BIAS) or a neuron (HIDDEN or OUTPUT):
 *  - If it's a sensor, it can be loaded with a value for output
 *  - If it's a neuron, it has a mutable array of incoming input signals
 *
 * There will be a first layer of INPUT sensors including at least one BIAS sensor
 * The remaining neurons will consist of HIDDEN or OUTPUT nodes
 * 
 * Each PhenoNode has an array of incoming and outgoing PhenoLinks.
 * These allow a neuron to evaluate the incoming signals and update it's own 
 * activation value.
 *
 * At this stage the outgoingPhenoLinks are not used a great deal however 
 * it makes sense to record them for debugging and future purpose.
 *
 * Note that nodes in a network may be added out of sensible execution order, 
 * or even be recursive.  Because of this it makes sense to run a network a number of times
 * at least until the activation values settle.
 *
 * One use of the outgoing links would be to pre-order or unroll the network to ensure 
 * more efficient traversal, however unless massively high performance is required
 * this should do for most uses.
 */

@interface ONPhenoNode : NSObject {
    int nodeID;
    NodeType nodeType; 
    
    NSMutableArray * incomingPhenoLinks;
    NSMutableArray * outgoingPhenoLinks;
    
    double activationValue;
    double lastActivationValue;
    bool hasChangedSinceLastTraversal;
}

/** The unique identifier of the ONGenoNode
 *  Note the node may also be referred to with an innovation number which will be different
 *  All references in the Genotype are literal (i.e. no pointers)
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


/** An array of incoming links, i.e. whose weighted output will be evaluated as input to the node. */
@property (assign) NSMutableArray * incomingPhenoLinks;

/** An array of outgoing links, i.e. the value of this neural node will be passed as input to these links. */
@property (assign) NSMutableArray * outgoingPhenoLinks;

/** The value of the node.
 *
 *  If the node is a sensor, this may be loaded immediately
 *  If a Neuron, this will be calculated by activating the network
 */
@property double activationValue;

/** The previous value of the node as calculated on the last run through
 *  As the network grows it is not always possible to evaluate the nodes in correct order
 *  particularly when recursion is added.  
 *  To get around this problem, we traverse the network a number of times
 *  and only stop after a set number of iterations, 
 *  or when no node has changed value on the most recent traversal.
 */
@property double lastActivationValue;

/** A boolean to indicate if the value has changed since the last traversal */
@property bool hasChangedSinceLastTraversal;


/** Activates the node
 *
 * Sums up the incoming link values and runs through it's own activation function
 * At this stage this is just the sigmoid function
 */
-(void) activate;

-(void) clearLinks;

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

double gaussrand();

@end
