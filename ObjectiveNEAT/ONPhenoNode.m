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



-(void) clearLinks {
    [incomingPhenoLinks release];
    incomingPhenoLinks = nil;
    [outgoingPhenoLinks release];
    outgoingPhenoLinks = nil;
}

-(void) dealloc {
    if (incomingPhenoLinks != nil) {
        [incomingPhenoLinks release];
    }
    if (outgoingPhenoLinks != nil) {
        [outgoingPhenoLinks release];
    }
    [super dealloc];
}

@end
