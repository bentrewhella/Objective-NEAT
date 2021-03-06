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

#import "ONGenome.h"
#import "ONGenoLink.h"
#import "ONGenoNode.h"
#import "ONUtilities.h"
#import "ONNetwork.h"
#import "ONInnovationDB.h"
#import "ONParameterController.h"

@implementation ONGenome
@synthesize genomeID, genoNodes, genoLinks;

static int genomeCounter = 0;
static bool genesisOccurred = false;

- (id)init
{
    self = [super init];
    if (self) {
        genoNodes = [[NSMutableArray alloc] init];
        genoLinks = [[NSMutableArray alloc] init];
        genomeID = genomeCounter++;
    }
    return self;
}

-(ONGenoNode *) getNodeWithID: (int) nodeID {
    for (ONGenoNode * nextNode in genoNodes) {
        if (nextNode.nodeID == nodeID) {
            return nextNode;
        }
    }
    return nil;
}

-(ONGenoLink *) getLinkFromNodeID: (int) fNodeID toNodeID: (int) tNodeID {
    for (ONGenoLink * nextLink in genoLinks) {
        if (nextLink.fromNode == fNodeID &&
            nextLink.toNode == tNodeID) {
            return nextLink;
        }
    }
    return nil;
}

-(ONGenome *) randomiseWeights {
    for (ONGenoLink * nextLink in genoLinks) {
        nextLink.weight = randomClampedDouble();
    }
    return self;
}

double gaussrand() {
	static int iset=0;
	static double gset;
	double fac,rsq,v1,v2;
    
	if (iset==0) {
		do {
			v1=2.0*(randomDouble())-1.0;
			v2=2.0*(randomDouble())-1.0;
			rsq=v1*v1+v2*v2;
		} while (rsq>=1.0 || rsq==0.0);
		fac=sqrt(-2.0*log(rsq)/rsq);
		gset=v1*fac;
		iset=1;
		return v2*fac;
	}
	else {
		iset=0;
		return gset;
	}
}


-(void) perturbSingleLinkWeight {
    ONGenoLink * randomLink = [genoLinks objectAtIndex:rand() % genoLinks.count];
    if (randomDouble() < [ONParameterController mutationProbabilityReplaceWeight]) {
        randomLink.weight = gaussrand();
    }
    else {
        randomLink.weight += gaussrand() * [ONParameterController mutationMaximumPerturbation];
    }
}

-(void) perturbAllLinkWeights {
    for (ONGenoLink * nextLink in genoLinks) {
        if (randomDouble() < [ONParameterController mutationProbabilityReplaceWeight]) {
            nextLink.weight = gaussrand();
        }
        else {
            nextLink.weight += gaussrand() * [ONParameterController mutationMaximumPerturbation];
        }
    }
}

-(void) reEnableRandomLink {
    NSMutableArray * disabledLinks = [NSMutableArray array];
    for (ONGenoLink * nextLink in genoLinks) {
        if (!nextLink.isEnabled) {
            [disabledLinks addObject: nextLink];
        }
    }
    if (disabledLinks.count > 0) {
        ONGenoLink * randomLink = [disabledLinks objectAtIndex:rand() % disabledLinks.count];
        randomLink.isEnabled = true;
    }
}

-(void) toggleRandomLink {
    ONGenoLink * randomLink = [genoLinks objectAtIndex:rand() % genoLinks.count];
    if (randomLink.isEnabled) {
        randomLink.isEnabled = false;
    }
    else {
        randomLink.isEnabled = true;
    }
}

-(void) addLink {
    // select 2 nodes at random
    ONGenoNode * randomFromNode = [genoNodes objectAtIndex:rand() % [genoNodes count]];
    ONGenoNode * randomToNode = [genoNodes objectAtIndex:rand() % [genoNodes count]];
    
    // make sure the link is valid
    
    // cannot link to itself
    if (randomFromNode == randomToNode) {
        return;
    }
    // cannot link to an input or bias
    if (randomToNode.nodeType == INPUT || randomToNode.nodeType == BIAS) {
        return;
    }
    // do not link if already linked
    if ([self getLinkFromNodeID:randomFromNode.nodeID toNodeID:randomToNode.nodeID] != nil) {
        return;
    }
    // do not link if links backwards in the network 
    if (randomFromNode.nodePosition.y > randomToNode.nodePosition.y) {
        return;
    }
    // cannot create a link where there is a reverse link existing
    if ([self getLinkFromNodeID:randomToNode.nodeID toNodeID:randomFromNode.nodeID] != nil) {
        return;
    }
    
    
    // all clear - we can link these nodes

    // check to see if the link already exists in the innovation DB
    ONGenoLink * existingLink = [[ONInnovationDB sharedDB] 
                                 possibleLinkExistsFromNode:randomFromNode.nodeID 
                                                     toNode:randomToNode.nodeID];
    if (existingLink == nil) {
        //create a new link
        ONGenoLink * newGenoLink = [[ONGenoLink alloc] initNewlyInnovatedLinkFromNode: randomFromNode.nodeID
                                                                               toNode: randomToNode.nodeID
                                                                           withWeight:randomClampedDouble()];
        [genoLinks addObject:newGenoLink];
        [newGenoLink release];
        // we can be sure this is a new link so add to innovation database
        [[ONInnovationDB sharedDB] insertNewLink:newGenoLink fromNode:randomFromNode.nodeID toNode:randomToNode.nodeID];
    }
    else {
        [genoLinks addObject:existingLink];
        [existingLink release];
    }
}

-(void) addNode {
    // select link at random
    ONGenoLink * randomLink = [genoLinks objectAtIndex:rand() % [genoLinks count]];
    if (!randomLink.isEnabled) {
        // don't create a new node with a disabled link
        return;
    }
    ONGenoNode * fromNode = [self getNodeWithID:randomLink.fromNode];
    ONGenoNode * toNode = [self getNodeWithID:randomLink.toNode];
    
    // find out if a neuron already exists between the from and to nodes
    ONGenoNode * existingNode = [[ONInnovationDB sharedDB] possibleNodeExistsFromNode:randomLink.fromNode toNode:randomLink.toNode];
    
    if (existingNode == nil) {
        // if not, create a new one
        ONGenoNode * newNode = [[ONGenoNode alloc] init];
        newNode.nodeID = [ONInnovationDB getNextGenoNodeID];
        newNode.nodeType = HIDDEN;
        newNode.nodePosition = CGPointMake(fromNode.nodePosition.x + ((toNode.nodePosition.x - fromNode.nodePosition.x) / 2),
                                           fromNode.nodePosition.y + ((toNode.nodePosition.y - fromNode.nodePosition.y) / 2));
        [genoNodes addObject: newNode];
        [newNode release];
        // we can be sure this is a new node so add to innovation database
        [[ONInnovationDB sharedDB] insertNewNode:newNode fromNode:randomLink.fromNode toNode:randomLink.toNode];
        
        // now create two new links
        ONGenoLink * newPrecursorLink = [[ONGenoLink alloc] initNewlyInnovatedLinkFromNode: fromNode.nodeID 
                                                                                    toNode: newNode.nodeID 
                                                                                withWeight:1.0];
        [genoLinks addObject:newPrecursorLink];
        [newPrecursorLink release];
        // we can be sure this is a new link so add to innovation database
        [[ONInnovationDB sharedDB] insertNewLink:newPrecursorLink fromNode:fromNode.nodeID toNode:newNode.nodeID];
        
        ONGenoLink * newSuccessorLink = [[ONGenoLink alloc] initNewlyInnovatedLinkFromNode: newNode.nodeID 
                                                                                    toNode: toNode.nodeID 
                                                                                withWeight: randomLink.weight];
        [genoLinks addObject:newSuccessorLink];
        [newSuccessorLink release];
        // we can be sure this is a new link so add to innovation database
        [[ONInnovationDB sharedDB] insertNewLink:newSuccessorLink fromNode:newNode.nodeID toNode:toNode.nodeID];
        
        // and finally deactivate the old link
        randomLink.isEnabled = false;
    }
    else {
        // in some cases this already exists - make sure it doesn't
        if ([self getNodeWithID:existingNode.nodeID] == nil) {
            
            [genoNodes addObject:existingNode];
            [existingNode release];
            
            ONGenoLink * precursorLink = [[ONInnovationDB sharedDB] possibleLinkExistsFromNode:fromNode.nodeID toNode:existingNode.nodeID];
            NSAssert(precursorLink != nil, @"Have picked up an existing node from innovations DB without an existing link");
            precursorLink.weight = 1.0;
            [genoLinks addObject:precursorLink];
            [precursorLink release];
            
            ONGenoLink * successorLink = [[ONInnovationDB sharedDB] possibleLinkExistsFromNode:existingNode.nodeID toNode:toNode.nodeID];
            NSAssert(successorLink != nil, @"Have picked up an existing node from innovations DB without an existing link");
            successorLink.weight = randomLink.weight;
            [genoLinks addObject:successorLink];
            [successorLink release];
            
            randomLink.isEnabled = false;
        }
    }
}

-(ONGenome *) mutateGenome {
    
    
    if (genoNodes.count < [ONParameterController maximumNeurons] &&
        randomDouble() < [ONParameterController chanceAddNode]) {
        [self addNode];
    }
    else if (randomDouble() < [ONParameterController chanceAddLink]) {
        [self addLink];
    }
    
    else if (randomDouble() < [ONParameterController chanceMutateWeight]) {
        [self perturbAllLinkWeights];
    }
    else if (randomDouble() < [ONParameterController chanceToggleLinks]) {
        [self toggleRandomLink];
    }
    else if (randomDouble() < [ONParameterController changeReenableLinks]) {
        [self reEnableRandomLink];
    } 
    return self;
}

-(ONGenome *) offspringWithGenome: (ONGenome *) mumGenome {
    ONGenome * childGenome = [[ONGenome alloc] init];
    
    [genoLinks sortUsingSelector:@selector(compareIDWith:)];
    [mumGenome.genoLinks sortUsingSelector:@selector(compareIDWith:)];
    
    int dadIndex = 0;
    int mumIndex = 0;
    
    bool dadHasLinksLeft = true;
    bool mumHasLinksLeft = true;
    
    ONGenoLink * dadNextLink = [genoLinks objectAtIndex:dadIndex];
    ONGenoLink * mumNextLink = [mumGenome.genoLinks objectAtIndex:mumIndex];
    
    while (dadHasLinksLeft && mumHasLinksLeft) {
        if (dadNextLink.linkID == mumNextLink.linkID) {
            // shared gene, choose one at random
            if (randomDouble() < 0.5) {
                ONGenoLink * dadLink = [dadNextLink copy];
                [childGenome.genoLinks addObject:dadLink];
                [dadLink release];
            }
            else {
                ONGenoLink * mumLink = [mumNextLink copy];
                [childGenome.genoLinks addObject:mumLink];
                [mumLink release];
            }
            dadIndex++;
            if (dadIndex == genoLinks.count) {
                dadHasLinksLeft = false;
            }
            else {
                dadNextLink = [genoLinks objectAtIndex:dadIndex];
            }
            mumIndex++;
            if (mumIndex == mumGenome.genoLinks.count) {
                mumHasLinksLeft = false;
            }
            else {
                mumNextLink = [mumGenome.genoLinks objectAtIndex:mumIndex];
            }
        }
        // disjoint gene
        else if (dadNextLink.linkID < mumNextLink.linkID) {
            ONGenoLink * dadLink = [dadNextLink copy];
            [childGenome.genoLinks addObject:dadLink];
            [dadLink release];
            dadIndex++;
            if (dadIndex == genoLinks.count) {
                dadHasLinksLeft = false;
            }
            else {
                dadNextLink = [genoLinks objectAtIndex:dadIndex];
            }

        }
        // disjoint gene
        else if (mumNextLink.linkID < dadNextLink.linkID) {
            // don't do anything - we ignore the less fit link
            ONGenoLink * mumLink = [mumNextLink copy];
            [childGenome.genoLinks addObject:mumLink];  // should do this but it seems to get good results
            [mumLink release];
            mumIndex++;
            if (mumIndex == mumGenome.genoLinks.count) {
                mumHasLinksLeft = false;
            }
            else {
                mumNextLink = [mumGenome.genoLinks objectAtIndex:mumIndex];
            }
        }
    }
    while (dadHasLinksLeft) {
        ONGenoLink * dadLink = [dadNextLink copy];
        [childGenome.genoLinks addObject:dadLink];
        [dadLink release];
        dadIndex++;
        if (dadIndex == genoLinks.count) {
            dadHasLinksLeft = false;
        }
        else {
            dadNextLink = [genoLinks objectAtIndex:dadIndex];
        }
    }
    /* Do not add excess Genes from less fit Genome
    while (mumHasLinksLeft) {
        [childGenome.genoLinks addObject:[mumNextLink copy]];
        mumIndex++;
        if (mumIndex == mumGenome.genoLinks.count) {
            mumHasLinksLeft = false;
        }
        else {
            mumNextLink = [mumGenome.genoLinks objectAtIndex:mumIndex];
        }
    }
     */
    
    for (ONGenoLink * nextLink in childGenome.genoLinks) {
        if ([childGenome getNodeWithID: nextLink.fromNode] == nil) {
            ONGenoNode * nodeToAdd = [[ONInnovationDB sharedDB] getNodeWithID:nextLink.fromNode];
            NSAssert(nodeToAdd != nil, @"Error - have created a link with a node that does not exist in the Innovation DB");
            [childGenome.genoNodes addObject: nodeToAdd];
            [nodeToAdd release];
        }
        if ([childGenome getNodeWithID: nextLink.toNode] == nil) {
            ONGenoNode * nodeToAdd = [[ONInnovationDB sharedDB] getNodeWithID:nextLink.toNode];
            NSAssert(nodeToAdd != nil, @"Error - have created a link with a node that does not exist in the Innovation DB");
            [childGenome.genoNodes addObject: nodeToAdd];
            [nodeToAdd release];
        }

    }
    [childGenome.genoLinks sortUsingSelector:@selector(compareIDWith:)];
    
    [childGenome verifyGenome];
    
    return childGenome;
}

-(double) similarityScoreWithGenome: (ONGenome *) otherGenome {
    int disjointLinks = 0;
    int excessLinks = 0;
    int matchingLinks = 0;
    double weightDifference = 0.0;
    
    int myIndex = 0;
    int otherIndex = 0;
    
    bool iHaveLinksLeft = true;
    bool otherHasLinksLeft = true;
    
    ONGenoLink * myNextLink = [genoLinks objectAtIndex:myIndex];
    ONGenoLink * otherNextLink = [otherGenome.genoLinks objectAtIndex:otherIndex];
    
    while (iHaveLinksLeft && otherHasLinksLeft) {
        if (myNextLink.linkID == otherNextLink.linkID) {
            matchingLinks++;
            weightDifference += fabs(myNextLink.weight - otherNextLink.weight);
            
            myIndex++;
            if (myIndex >= genoLinks.count) {
                iHaveLinksLeft = false;
            }
            else {
                myNextLink = [genoLinks objectAtIndex:myIndex];
            }
            
            otherIndex++;
            if (otherIndex >= otherGenome.genoLinks.count) {
                otherHasLinksLeft = false;
            }
            else {
                otherNextLink = [otherGenome.genoLinks objectAtIndex:otherIndex];
            }
        }
        else if (myNextLink.linkID < otherNextLink.linkID) {
            disjointLinks++;
            myIndex++;
            if (myIndex >= genoLinks.count) {
                iHaveLinksLeft = false;
            }
            else {
                myNextLink = [genoLinks objectAtIndex:myIndex];
            }
        }
        else if (otherNextLink.linkID < myNextLink.linkID) {
            disjointLinks++;
            otherIndex++;
            if (otherIndex >= otherGenome.genoLinks.count) {
                otherHasLinksLeft = false;
            }
            else {
                otherNextLink = [otherGenome.genoLinks objectAtIndex:otherIndex];
            }
        }
    }
    if (iHaveLinksLeft) {
        excessLinks++;
        myIndex++;
        if (myIndex >= genoLinks.count) {
            iHaveLinksLeft = false;
        }
    }
    if (otherHasLinksLeft) {
        excessLinks++;
        otherIndex++;
        if (otherIndex >= otherGenome.genoLinks.count) {
            otherHasLinksLeft = false;
        }
    }
    
    double longest = MAX([genoLinks count], [otherGenome.genoLinks count]);

    double excessScore = ([ONParameterController c1ExcessCoefficient] * excessLinks) / longest;
    double disjointScore = ([ONParameterController c2DisjointCoefficient] * disjointLinks) / longest;
    double weightScore = ([ONParameterController c3weightCoefficient] * weightDifference) / matchingLinks;
    
    double score = excessScore + disjointScore + weightScore;
    return score;
}

-(ONGenome *) copyWithZone: (NSZone *) zone {
    ONGenome * copiedGenome = [[ONGenome alloc] init];
    for (ONGenoNode * nextNode in genoNodes) {
        ONGenoNode * newNode = [nextNode copy];
        [copiedGenome.genoNodes addObject: newNode];
        [newNode release];
    }
    for (ONGenoLink * nextLink in genoLinks) {
        ONGenoLink * newLink = [nextLink copy];
        [copiedGenome.genoLinks addObject: newLink];
        [newLink release];
    }
    return copiedGenome;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"\nGenome %d\nNodes: %@\nGenes: %@", 
            genomeID,
            genoNodes,
            genoLinks];
}

-(void) verifyGenome {
    NSMutableArray * checkedInnovations = [NSMutableArray array];
    
    for (ONGenoLink * nextLink in genoLinks) {
        bool foundMatch = false;
        for (ONGenoLink * nextCheckedLink in checkedInnovations) {
            if (nextLink.linkID == nextCheckedLink.linkID) {
                foundMatch = true;
                NSAssert(false, @"Error - the same link has been added twice");
            }
        }
        if (!foundMatch) {
            [checkedInnovations addObject:nextLink];
        }
    }
}

-(void) dealloc {
    if (genoNodes != nil) {
        [genoNodes release];
        genoNodes = nil;
    }
    if (genoLinks != nil) {
        [genoLinks release];
        genoLinks = nil;
    }
    [super dealloc];
}

+(ONGenome *) createSimpleGenomeWithInputs: (int) nInputs outputs: (int) nOutputs {
    NSAssert (!genesisOccurred, @"Genesis cannot occur more than once! "
              "This would really screw up the innovation database. "
              "Instead create once and duplicate");
    genesisOccurred = true;
    
    ONGenome * newGenome = [[ONGenome alloc] init];
    
    // set up input nodes
    double positionXOffset = 0.8/(double)nInputs;  // Method 'borrowed' from Mat Buckland's WindowsNeat implementation (thanks Mat!)
    
    for (int i = 0; i < nInputs; i++) {
        ONGenoNode * inputNode = [[ONGenoNode alloc] init];
        inputNode.nodeID = [ONInnovationDB getNextGenoNodeID];
        inputNode.nodeType = INPUT;
        inputNode.nodePosition = CGPointMake(0.1+i*positionXOffset, 0.1);
        [newGenome.genoNodes addObject: inputNode];
        [inputNode release];
        // we can be sure this is a new node so add to innovation database
        [[ONInnovationDB sharedDB] insertNewNode:inputNode fromNode:0 toNode:0];
    }
    
    // set up bias node
    ONGenoNode * biasNode = [[ONGenoNode alloc] init];
    biasNode.nodeID = [ONInnovationDB getNextGenoNodeID];
    biasNode.nodeType = BIAS;
    biasNode.nodePosition = CGPointMake(0.9, 0.1);
    [newGenome.genoNodes addObject: biasNode];
    [biasNode release];
    // we can be sure this is a new node so add to innovation database
    [[ONInnovationDB sharedDB] insertNewNode:biasNode fromNode:0 toNode:0];
    nInputs++; // we want to include this as an input node from now on
    
    // set up output nodes
    positionXOffset = 1/(double)(nOutputs+1);
    for (int i = 0; i < nOutputs; i++) {
        ONGenoNode * outputNode = [[ONGenoNode alloc] init];
        outputNode.nodeID = [ONInnovationDB getNextGenoNodeID];
        outputNode.nodeType = OUTPUT;
        outputNode.nodePosition = CGPointMake((i+1)*positionXOffset, 0.9);
        [newGenome.genoNodes addObject: outputNode];
        [outputNode release];
        // we can be sure this is a new node so add to innovation database
        [[ONInnovationDB sharedDB] insertNewNode:outputNode fromNode:0 toNode:0];
    }
    
    // link all input / bias nodes to all output nodes
    for (int i = 0; i < nInputs; i++) {
        for (int j = 0; j < nOutputs; j++) {
            ONGenoNode * fNode = [newGenome.genoNodes objectAtIndex:i];
            ONGenoNode * tNode = [newGenome.genoNodes objectAtIndex:nInputs + j];
            ONGenoLink * newGenoLink = [[ONGenoLink alloc] initNewlyInnovatedLinkFromNode: fNode.nodeID
                                                                                   toNode: tNode.nodeID
                                                                               withWeight:randomClampedDouble()];
            [newGenome.genoLinks addObject:newGenoLink];
            [newGenoLink release];
            // we can be sure this is a new link so add to innovation database
            [[ONInnovationDB sharedDB] insertNewLink:newGenoLink fromNode:fNode.nodeID toNode:tNode.nodeID];
            
        }
    }
    
    return newGenome;
}

+(ONGenome *) createXORGenome {
    NSAssert (!genesisOccurred, @"Genesis cannot occur more than once! "
              "This would really screw up the innovation database. "
              "Instead create once and duplicate");
    genesisOccurred = true;
    
    ONGenome * newGenome = [[ONGenome alloc] init];
    
    // set up input nodes
    double positionXOffset = 0.8/(double)2;  // Method 'borrowed' from Mat Buckland's WindowsNeat implementation (thanks Mat!)
    
    for (int i = 0; i < 2; i++) {
        ONGenoNode * inputNode = [[ONGenoNode alloc] init];
        inputNode.nodeID = [ONInnovationDB getNextGenoNodeID];
        inputNode.nodeType = INPUT;
        inputNode.nodePosition = CGPointMake(0.1+i*positionXOffset, 0.1);
        [newGenome.genoNodes addObject: inputNode];
        [inputNode release];
        // we can be sure this is a new node so add to innovation database
        [[ONInnovationDB sharedDB] insertNewNode:inputNode fromNode:0 toNode:0];
    }
    
    // set up bias node
    ONGenoNode * biasNode = [[ONGenoNode alloc] init];
    biasNode.nodeID = [ONInnovationDB getNextGenoNodeID];
    biasNode.nodeType = BIAS;
    biasNode.nodePosition = CGPointMake(0.9, 0.1);
    [newGenome.genoNodes addObject: biasNode];
    [biasNode release];
    // we can be sure this is a new node so add to innovation database
    [[ONInnovationDB sharedDB] insertNewNode:biasNode fromNode:0 toNode:0];
    
    // set up hidden node
    ONGenoNode * hiddenNode = [[ONGenoNode alloc] init];
    hiddenNode.nodeID = [ONInnovationDB getNextGenoNodeID];
    hiddenNode.nodeType = HIDDEN;
    hiddenNode.nodePosition = CGPointMake(0.5, 0.5);
    [newGenome.genoNodes addObject: hiddenNode];
    [hiddenNode release];
    // we can be sure this is a new node so add to innovation database
    [[ONInnovationDB sharedDB] insertNewNode:hiddenNode fromNode:0 toNode:4];
    
    // set up output nodes
    positionXOffset = 1/(double)(1+1);
    ONGenoNode * outputNode = [[ONGenoNode alloc] init];
    outputNode.nodeID = [ONInnovationDB getNextGenoNodeID];
    outputNode.nodeType = OUTPUT;
    outputNode.nodePosition = CGPointMake(positionXOffset, 0.9);
    [newGenome.genoNodes addObject: outputNode];
    [outputNode release];
    // we can be sure this is a new node so add to innovation database
    [[ONInnovationDB sharedDB] insertNewNode:outputNode fromNode:0 toNode:0];
    

    ONGenoNode * fNode = [newGenome.genoNodes objectAtIndex:0];
    ONGenoNode * tNode = [newGenome.genoNodes objectAtIndex:3];
    ONGenoLink * link1 = [[ONGenoLink alloc] initNewlyInnovatedLinkFromNode: fNode.nodeID
                                                                           toNode: tNode.nodeID
                                                                       withWeight:1];
    [newGenome.genoLinks addObject:link1];
    [link1 release];
    // we can be sure this is a new link so add to innovation database
    [[ONInnovationDB sharedDB] insertNewLink:link1 fromNode:fNode.nodeID toNode:tNode.nodeID];
    
    fNode = [newGenome.genoNodes objectAtIndex:0];
    tNode = [newGenome.genoNodes objectAtIndex:4];
    ONGenoLink * link2 = [[ONGenoLink alloc] initNewlyInnovatedLinkFromNode: fNode.nodeID
                                                                           toNode: tNode.nodeID
                                                                       withWeight:1];
    [newGenome.genoLinks addObject:link2];
    [link2 release];
    // we can be sure this is a new link so add to innovation database
    [[ONInnovationDB sharedDB] insertNewLink:link2 fromNode:fNode.nodeID toNode:tNode.nodeID];
    
    fNode = [newGenome.genoNodes objectAtIndex:1];
    tNode = [newGenome.genoNodes objectAtIndex:3];
    ONGenoLink * link3 = [[ONGenoLink alloc] initNewlyInnovatedLinkFromNode: fNode.nodeID
                                                                     toNode: tNode.nodeID
                                                                 withWeight:1];
    [newGenome.genoLinks addObject:link3];
    [link3 release];
    // we can be sure this is a new link so add to innovation database
    [[ONInnovationDB sharedDB] insertNewLink:link3 fromNode:fNode.nodeID toNode:tNode.nodeID];

    
    fNode = [newGenome.genoNodes objectAtIndex:1];
    tNode = [newGenome.genoNodes objectAtIndex:4];
    ONGenoLink * link4 = [[ONGenoLink alloc] initNewlyInnovatedLinkFromNode: fNode.nodeID
                                                                     toNode: tNode.nodeID
                                                                 withWeight: 1];
    [newGenome.genoLinks addObject:link4];
    [link4 release];
    // we can be sure this is a new link so add to innovation database
    [[ONInnovationDB sharedDB] insertNewLink:link4 fromNode:fNode.nodeID toNode:tNode.nodeID];
    
    fNode = [newGenome.genoNodes objectAtIndex:2];
    tNode = [newGenome.genoNodes objectAtIndex:3];
    ONGenoLink * link5 = [[ONGenoLink alloc] initNewlyInnovatedLinkFromNode: fNode.nodeID
                                                                     toNode: tNode.nodeID
                                                                 withWeight: 1];
    [newGenome.genoLinks addObject:link5];
    [link5 release];
    // we can be sure this is a new link so add to innovation database
    [[ONInnovationDB sharedDB] insertNewLink:link5 fromNode:fNode.nodeID toNode:tNode.nodeID];
    
    fNode = [newGenome.genoNodes objectAtIndex:2];
    tNode = [newGenome.genoNodes objectAtIndex:4];
    ONGenoLink * link6 = [[ONGenoLink alloc] initNewlyInnovatedLinkFromNode: fNode.nodeID
                                                                     toNode: tNode.nodeID
                                                                 withWeight: 1];
    [newGenome.genoLinks addObject:link6];
    [link6 release];
    
    fNode = [newGenome.genoNodes objectAtIndex:3];
    tNode = [newGenome.genoNodes objectAtIndex:4];
    ONGenoLink * link7 = [[ONGenoLink alloc] initNewlyInnovatedLinkFromNode: fNode.nodeID
                                                                     toNode: tNode.nodeID
                                                                 withWeight: 1];
    [newGenome.genoLinks addObject:link7];
    [link7 release];

    // we can be sure this is a new link so add to innovation database
    [[ONInnovationDB sharedDB] insertNewLink:link6 fromNode:fNode.nodeID toNode:tNode.nodeID];
    
    NSLog(@"%@", [newGenome description]);
    return newGenome;
}


@end
