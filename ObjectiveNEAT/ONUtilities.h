//
//  ONUtilities.h
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 29/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Utility functions to be shared across all classes */

@interface ONUtilities : NSObject

/* returns a random double in the range 0 < n < 1 */
double randomDouble (void);

/** returns a random double in the range -1 < n < 1 */
double randomClampedDouble (void);



@end
