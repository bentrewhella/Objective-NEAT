//
//  ONGenome.m
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 27/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

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

-(void) perturbLinkWeight {
    for (ONGenoLink * nextLink in genoLinks) {
        if (randomDouble() < [ONParameterController mutationProbabilityReplaceWeight]) {
            nextLink.weight = randomClampedDouble();
        }
        else {
            nextLink.weight += randomClampedDouble() * [ONParameterController mutationMaximumPerturbation];
        }
    }
}

-(void) reEnableRandomWeight {
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
        // we can be sure this is a new link so add to innovation database
        [[ONInnovationDB sharedDB] insertNewLink:newGenoLink fromNode:randomFromNode.nodeID toNode:randomToNode.nodeID];
    }
    else {
        [genoLinks addObject:existingLink];
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
        // we can be sure this is a new node so add to innovation database
        [[ONInnovationDB sharedDB] insertNewNode:newNode fromNode:randomLink.fromNode toNode:randomLink.toNode];
        
        // now create two new links
        ONGenoLink * newPrecursorLink = [[ONGenoLink alloc] initNewlyInnovatedLinkFromNode: fromNode.nodeID 
                                                                                    toNode: newNode.nodeID 
                                                                                withWeight:1.0];
        [genoLinks addObject:newPrecursorLink];
        // we can be sure this is a new link so add to innovation database
        [[ONInnovationDB sharedDB] insertNewLink:newPrecursorLink fromNode:fromNode.nodeID toNode:newNode.nodeID];
        
        ONGenoLink * newSuccessorLink = [[ONGenoLink alloc] initNewlyInnovatedLinkFromNode: newNode.nodeID 
                                                                                    toNode: toNode.nodeID 
                                                                                withWeight: randomLink.weight];
        [genoLinks addObject:newSuccessorLink];
        // we can be sure this is a new link so add to innovation database
        [[ONInnovationDB sharedDB] insertNewLink:newSuccessorLink fromNode:newNode.nodeID toNode:toNode.nodeID];
        
        // and finally deactivate the old link
        randomLink.isEnabled = false;
    }
    else {
        // in some cases this already exists - make sure it doesn't
        if ([self getNodeWithID:existingNode.nodeID] == nil) {
            
            [genoNodes addObject:existingNode];
            
            ONGenoLink * precursorLink = [[ONInnovationDB sharedDB] possibleLinkExistsFromNode:fromNode.nodeID toNode:existingNode.nodeID];
            NSAssert(precursorLink != nil, @"Have picked up an existing node from innovations DB without an existing link");
            precursorLink.weight = 1.0;
            [genoLinks addObject:precursorLink];
            
            ONGenoLink * successorLink = [[ONInnovationDB sharedDB] possibleLinkExistsFromNode:existingNode.nodeID toNode:toNode.nodeID];
            NSAssert(successorLink != nil, @"Have picked up an existing node from innovations DB without an existing link");
            successorLink.weight = randomLink.weight;
            [genoLinks addObject:successorLink];
            
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
        [self perturbLinkWeight];
    }
    else if (randomDouble() < [ONParameterController chanceToggleLinks]) {
        [self toggleRandomLink];
    }
    else if (randomDouble() < [ONParameterController changeReenableLinks]) {
        [self reEnableRandomWeight];
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
                [childGenome.genoLinks addObject:[dadNextLink copy]];
            }
            else {
                [childGenome.genoLinks addObject:[mumNextLink copy]];
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
            [childGenome.genoLinks addObject:[dadNextLink copy]];
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
            [childGenome.genoLinks addObject:[mumNextLink copy]];  // should do this but it seems to get good results
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
        [childGenome.genoLinks addObject:[dadNextLink copy]];
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
        }
        if ([childGenome getNodeWithID: nextLink.toNode] == nil) {
            ONGenoNode * nodeToAdd = [[ONInnovationDB sharedDB] getNodeWithID:nextLink.toNode];
            NSAssert(nodeToAdd != nil, @"Error - have created a link with a node that does not exist in the Innovation DB");
            [childGenome.genoNodes addObject: nodeToAdd];
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
        [copiedGenome.genoNodes addObject: [nextNode copy]];
    }
    for (ONGenoLink * nextLink in genoLinks) {
        [copiedGenome.genoLinks addObject: [nextLink copy]];
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
        // we can be sure this is a new node so add to innovation database
        [[ONInnovationDB sharedDB] insertNewNode:inputNode fromNode:0 toNode:0];
    }
    
    // set up bias node
    ONGenoNode * biasNode = [[ONGenoNode alloc] init];
    biasNode.nodeID = [ONInnovationDB getNextGenoNodeID];
    biasNode.nodeType = BIAS;
    biasNode.nodePosition = CGPointMake(0.9, 0.1);
    [newGenome.genoNodes addObject: biasNode];
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
        // we can be sure this is a new node so add to innovation database
        [[ONInnovationDB sharedDB] insertNewNode:inputNode fromNode:0 toNode:0];
    }
    
    // set up hidden nodes
    ONGenoNode * hiddenNode = [[ONGenoNode alloc] init];
    hiddenNode.nodeID = [ONInnovationDB getNextGenoNodeID];
    hiddenNode.nodeType = HIDDEN;
    hiddenNode.nodePosition = CGPointMake(0.5, 0.5);
    [newGenome.genoNodes addObject: hiddenNode];
    // we can be sure this is a new node so add to innovation database
    [[ONInnovationDB sharedDB] insertNewNode:hiddenNode fromNode:0 toNode:4];
    
    // set up hidden nodes
    ONGenoNode * hiddenNode2 = [[ONGenoNode alloc] init];
    hiddenNode2.nodeID = [ONInnovationDB getNextGenoNodeID];
    hiddenNode2.nodeType = HIDDEN;
    hiddenNode2.nodePosition = CGPointMake(0.5, 0.5);
    [newGenome.genoNodes addObject: hiddenNode2];
    // we can be sure this is a new node so add to innovation database
    [[ONInnovationDB sharedDB] insertNewNode:hiddenNode2 fromNode:1 toNode:4];
    
    // set up output nodes
    positionXOffset = 1/(double)(1+1);
    ONGenoNode * outputNode = [[ONGenoNode alloc] init];
    outputNode.nodeID = [ONInnovationDB getNextGenoNodeID];
    outputNode.nodeType = OUTPUT;
    outputNode.nodePosition = CGPointMake(positionXOffset, 0.9);
    [newGenome.genoNodes addObject: outputNode];
    // we can be sure this is a new node so add to innovation database
    [[ONInnovationDB sharedDB] insertNewNode:outputNode fromNode:0 toNode:0];
    

    ONGenoNode * fNode = [newGenome.genoNodes objectAtIndex:0];
    ONGenoNode * tNode = [newGenome.genoNodes objectAtIndex:2];
    ONGenoLink * link1 = [[ONGenoLink alloc] initNewlyInnovatedLinkFromNode: fNode.nodeID
                                                                           toNode: tNode.nodeID
                                                                       withWeight:1];
    [newGenome.genoLinks addObject:link1];
    // we can be sure this is a new link so add to innovation database
    [[ONInnovationDB sharedDB] insertNewLink:link1 fromNode:fNode.nodeID toNode:tNode.nodeID];
    
    fNode = [newGenome.genoNodes objectAtIndex:0];
    tNode = [newGenome.genoNodes objectAtIndex:3];
    ONGenoLink * link2 = [[ONGenoLink alloc] initNewlyInnovatedLinkFromNode: fNode.nodeID
                                                                           toNode: tNode.nodeID
                                                                       withWeight:-1];
    [newGenome.genoLinks addObject:link2];
    // we can be sure this is a new link so add to innovation database
    [[ONInnovationDB sharedDB] insertNewLink:link2 fromNode:fNode.nodeID toNode:tNode.nodeID];
    
    fNode = [newGenome.genoNodes objectAtIndex:1];
    tNode = [newGenome.genoNodes objectAtIndex:2];
    ONGenoLink * link3 = [[ONGenoLink alloc] initNewlyInnovatedLinkFromNode: fNode.nodeID
                                                                     toNode: tNode.nodeID
                                                                 withWeight:-1];
    [newGenome.genoLinks addObject:link3];
    // we can be sure this is a new link so add to innovation database
    [[ONInnovationDB sharedDB] insertNewLink:link3 fromNode:fNode.nodeID toNode:tNode.nodeID];

    
    fNode = [newGenome.genoNodes objectAtIndex:1];
    tNode = [newGenome.genoNodes objectAtIndex:3];
    ONGenoLink * link4 = [[ONGenoLink alloc] initNewlyInnovatedLinkFromNode: fNode.nodeID
                                                                     toNode: tNode.nodeID
                                                                 withWeight: 1];
    [newGenome.genoLinks addObject:link4];
    // we can be sure this is a new link so add to innovation database
    [[ONInnovationDB sharedDB] insertNewLink:link4 fromNode:fNode.nodeID toNode:tNode.nodeID];
    
    fNode = [newGenome.genoNodes objectAtIndex:2];
    tNode = [newGenome.genoNodes objectAtIndex:4];
    ONGenoLink * link5 = [[ONGenoLink alloc] initNewlyInnovatedLinkFromNode: fNode.nodeID
                                                                     toNode: tNode.nodeID
                                                                 withWeight: 1];
    [newGenome.genoLinks addObject:link5];
    // we can be sure this is a new link so add to innovation database
    [[ONInnovationDB sharedDB] insertNewLink:link5 fromNode:fNode.nodeID toNode:tNode.nodeID];
    
    fNode = [newGenome.genoNodes objectAtIndex:3];
    tNode = [newGenome.genoNodes objectAtIndex:4];
    ONGenoLink * link6 = [[ONGenoLink alloc] initNewlyInnovatedLinkFromNode: fNode.nodeID
                                                                     toNode: tNode.nodeID
                                                                 withWeight: 1];
    [newGenome.genoLinks addObject:link6];
    // we can be sure this is a new link so add to innovation database
    [[ONInnovationDB sharedDB] insertNewLink:link6 fromNode:fNode.nodeID toNode:tNode.nodeID];
    
    NSLog(@"%@", [newGenome description]);
    return newGenome;
}


@end
