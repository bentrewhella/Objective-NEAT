//
//  ONPhenoLink.h
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 29/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ONPhenoNode;

/**
 * A PhenoLink is a connection from one node to another in the Phenotype / Network
 *
 * It will have an associated weight, which modifies the strength of the signal through the link
 *
 */


@interface ONPhenoLink : NSObject {
    ONPhenoNode * fromNode;
    ONPhenoNode *  toNode;
    double weight;
    bool isEnabled;
}


/** A pointer to the links originating node */
@property (retain) ONPhenoNode *  fromNode;

/** A pointer to the links terminating node */
@property (retain) ONPhenoNode *  toNode;

/** The weight connection of the link */
@property double weight;

/** Indicates if the link is active or should be ignored */
@property bool isEnabled;



@end
