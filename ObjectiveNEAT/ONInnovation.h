//
//  ONInnovation.h
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 29/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ONGenoNode;
@class ONGenoLink;


/**
 * An Innovation represents a new Node or Link in the global poputlation
 *  
 * It stores a COPY of the ONGenoNode or ONGenoType for reference, 
 * as well as noting the nodes at either end (for both node or link).
 *
 * This means that when attempting to add a new node between two existing nodes 
 * we can check to see if the same mutation has occurred elsewhere, and if so
 * make use of the same reference numbers.
 *
 * Similiarly if a link has been already added between two nodes we want to refer 
 * to the original rather than create a new link
 *
 */

@protocol ONInnovationInformationProtocol <NSObject>
-(int) getInnovationID;
@end

@interface ONInnovation : NSObject {
    // a record of the node or link
    id <ONInnovationInformationProtocol> nodeOrLink;
    
    // for Link innovations
    int fromNodeID;
    int toNodeID;
}

@property (copy) id nodeOrLink;

/** The literal (non-pointer) reference to the node preceeding this node / acting as input to the link */
@property int fromNodeID;

/** The literal (non-pointer) reference to the node succeeding this node / acting as output from the link */
@property int toNodeID;

@end
