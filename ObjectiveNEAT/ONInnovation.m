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

#import "ONInnovation.h"
#import "ONInnovationDB.h"
#import "ONGenoLink.h"
#import "ONGenoNode.h"

@implementation ONInnovation
@synthesize nodeOrLink, fromNodeID, toNodeID;


-(NSString *) description {
    if ([nodeOrLink isMemberOfClass: [ONGenoLink class]]) {
        return [NSString stringWithFormat: @"Link Innovation %d between node %d and node %d", 
                [nodeOrLink getInnovationID], fromNodeID, toNodeID];
    }
    if ([nodeOrLink isMemberOfClass: [ONGenoNode class]]) {
        return [NSString stringWithFormat: @"Node Innovation %d between node %d and node %d", 
                [nodeOrLink getInnovationID], fromNodeID, toNodeID];
    }
    return @"unknown";
}
-(void) dealloc {
    [nodeOrLink release];
    [super dealloc];
}


@end
