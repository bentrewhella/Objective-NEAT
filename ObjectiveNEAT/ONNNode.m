//
//  NNode.m
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 27/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import "ONNNode.h"
#import "ONLink.h"

@implementation ONNNode
@synthesize inComing, outGoing, nodeType, nodePosition, activation;

static int nodeCounter = 0;

- (id)init
{
    self = [super init];
    if (self) {
        inComing = [[NSMutableArray alloc] init];
        outGoing = [[NSMutableArray alloc] init];
        nodeID = nodeCounter++;
        nodeType = SENSOR; // set to sensor to begin
        nodePosition = INPUT;  // set to input to begin
    }
    return self;
}

double fsigmoid(double activesum, double slope, double constant) {
	//RIGHT SHIFTED ---------------------------------------------------------
	return (1/(1+(exp(-(slope*activesum-constant))))); //ave 3213 clean on 40 runs of p2m and 3468 on another 40 
	//41394 with 1 failure on 8 runs
    
	//LEFT SHIFTED ----------------------------------------------------------
	//return (1/(1+(exp(-(slope*activesum+constant))))); //original setting ave 3423 on 40 runs of p2m, 3729 and 1 failure also
    
	//PLAIN SIGMOID ---------------------------------------------------------
	//return (1/(1+(exp(-activesum)))); //3511 and 1 failure
    
	//LEFT SHIFTED NON-STEEPENED---------------------------------------------
	//return (1/(1+(exp(-activesum-constant)))); //simple left shifted
    
	//NON-SHIFTED STEEPENED
	//return (1/(1+(exp(-(slope*activesum))))); //Compressed
}

-(void) activate {
    double activeSum = 0.0;
    for (ONLink * nextIncomingLink in inComing) {
        activeSum += (nextIncomingLink.fromNode.activation * nextIncomingLink.weight);
    }
    activation = activeSum;//fsigmoid(activeSum, 4.924273, 2.4621365);
}

- (NSString *)description {
        
    return [NSString stringWithFormat:@"%@ has activation value %1.3f, with %d inputs and %d outputs", 
            [self shortDescription], activation, [inComing count], [outGoing count]]; 
}

-(NSString *) shortDescription {
    NSString * nodeTypeString = (nodeType == SENSOR) ? @"Sensor" : @"Neuron"; 
    
    NSString * nodePositionString;
    switch (nodePosition) {
        case HIDDEN: {
            nodePositionString = @"Hidden"; 
            break;
        }
        case INPUT:
            nodePositionString = @"Input";
            break;
        case OUTPUT:
            nodePositionString = @"Output";
            break;
        case BIAS:
            nodePositionString = @"Bias";
            break;
        default:
            nodePositionString = @"Unknown"; // error
            break;
    }
    
    return [NSString stringWithFormat:@"%@ %@ Node %i",
            nodePositionString, nodeTypeString, nodeID];
}



@end
