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
@class ONGenoNode;
@class ONGenoLink;


/**
 * Innovation Protocol just enables both Nodes and Links to be stored in the 
 * Innocation database by providing a single referral mechanism.
 */


@protocol ONInnovationInformationProtocol <NSObject>
/** 
 * Classes implementing this protocol (e.g. ONGenoNode and ONGenoLink) 
 * should return their own ID when called by this method.
 */
-(int) getInnovationID;
@end

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


@interface ONInnovation : NSObject {
    id <ONInnovationInformationProtocol> nodeOrLink;
    
    // for Link innovations
    int fromNodeID;
    int toNodeID;
}
/**
 * A pointer to the ONGenoNode or ONGenoLink, 
 * which in turn can be consulted for more information on the Innovation.
 */
@property (assign) id nodeOrLink;

/** The literal (non-pointer) reference to the node preceeding this node / acting as input to the link */
@property int fromNodeID;

/** The literal (non-pointer) reference to the node succeeding this node / acting as output from the link */
@property int toNodeID;

@end
