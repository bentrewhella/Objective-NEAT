//
//  ONPhenoNode.m
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 29/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import "ONPhenoNode.h"
#import "ONPhenoLink.h"

@implementation ONPhenoNode
@synthesize nodeID, nodeType, incomingPhenoLinks, outgoingPhenoLinks, activationValue, lastActivationValue, hasChangedSinceLastTraversal;



- (id)init
{
    self = [super init];
    if (self) {
        incomingPhenoLinks = [[NSMutableArray alloc] init];
        outgoingPhenoLinks = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSString *) description {
    
    NSString * nodePositionString;
    switch (nodeType) {
        case HIDDEN: 
            nodePositionString = @"Hidden"; 
            break;
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
    
    return [NSString stringWithFormat:@"%@ Node %i with %d incoming links and %d outgoing links",
            nodePositionString, nodeID,
            [incomingPhenoLinks count], [outgoingPhenoLinks count]];
}


-(void) activate {
    double activeSum = 0.0;
    for (ONPhenoLink * nextIncomingLink in incomingPhenoLinks) {
        if (nextIncomingLink.isEnabled) {
            activeSum += (nextIncomingLink.fromNode.activationValue * nextIncomingLink.weight);
            //NSLog(@"+%1.3f = %1.3f",(nextIncomingLink.fromNode.activationValue * nextIncomingLink.weight), activeSum);
        }
    }
    lastActivationValue = activationValue;
    activationValue = fsigmoid(activeSum, 4.924273,2.4621365);
    
    // I suspect a more forgiving test will be required here in the future
    hasChangedSinceLastTraversal = (activationValue == lastActivationValue) ? false : true;
}

double fsigmoid(double activesum, double slope, double constant) {
	//RIGHT SHIFTED ---------------------------------------------------------
	//return (1/(1+(exp(-(slope*activesum-constant))))); //ave 3213 clean on 40 runs of p2m and 3468 on another 40 
	//41394 with 1 failure on 8 runs
    
	//LEFT SHIFTED ----------------------------------------------------------
	//return (1/(1+(exp(-(slope*activesum+constant))))); //original setting ave 3423 on 40 runs of p2m, 3729 and 1 failure also
    
	//PLAIN SIGMOID ---------------------------------------------------------
	//return (1/(1+(exp(-activesum)))); //3511 and 1 failure
    
	//LEFT SHIFTED NON-STEEPENED---------------------------------------------
	//return (1/(1+(exp(-activesum-constant)))); //simple left shifted
    
	//NON-SHIFTED STEEPENED
	return (1/(1+(exp(-(slope*activesum))))); //Compressed
}

@end
