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
#import "ONInnovation.h"

/**
 * A GenoLink is a connection from one node to another in the Genotype.
 *
 * It will have an associated weight, which modifies the strength of the signal through the link.
 *
 */

@interface ONGenoLink : NSObject <ONInnovationInformationProtocol>{
    int linkID;
    int fromNode;
    int toNode;
    double weight;
    bool isEnabled;
}

/** 
 * A unique reference for the link, also known as the innovation number.
 * Should be set from the global innovation database via getInnovationID.
 */
@property int linkID;

/** A literal (i.e. non pointer) reference to the links originating node. */
@property int fromNode;

/** A literal (i.e. non pointer) reference to the links terminating node. */
@property int toNode;

/** The weight connection of the link. */
@property double weight;

/** Indicates if the link is active or should be ignored. */
@property bool isEnabled;

/** Initialiser that takes an input and output node along with a weight. */
- (id)initNewlyInnovatedLinkFromNode: (int) fNode toNode: (int) tNode withWeight: (double) wght;

@end
