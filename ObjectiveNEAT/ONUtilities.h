//
//  ONUtilities.h
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 29/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ONUtilities : NSObject

/* returns a random float in the ranve 0 < n < 1 */
double randomDouble (void);

/** returns a random float in the range -1 < n < 1 */
double randomClampedDouble (void);



@end
