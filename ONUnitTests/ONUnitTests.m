//
//  ONUnitTests.m
//  ONUnitTests
//
//  Created by Ben Trewhella on 27/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import "ONUnitTests.h"
#import "ONParameterController.h"
#import "ONGenome.h"
#import "ONNetwork.h"
#import "ONOrganism.h"
#import "ONxorExperiment.h"

@implementation ONUnitTests

- (void)setUp
{
    [super setUp];
        
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}



-(void) testParameterLoader
{
    STAssertTrue([ONParameterController loadParametersFromPList:@"p2blank"], 
                 @"Failed to load specified parameters file");
    STAssertEquals(2, [ONParameterController numRuns], @"Number of Runs value not set to test case - specified parameters file not loaded properly");
    
    STAssertTrue([ONParameterController loadParametersFromPList:@"p2blank.plist"], 
                 @"Failed to load file with filename extension passed in (albeit incorrectly)");
    
    STAssertTrue([ONParameterController loadParametersFromPList:nil], 
                 @"Failed to load default parameters file");
    STAssertEquals(1, [ONParameterController numRuns], @"Number of Runs value not loaded correctly");
}

/*
-(void) testSimpleNeuron {
    // check that we create simple genomes correctly
    STAssertNotNil(genome2by2, @"Failed to create 2x2 Genome correctly");
    
    STAssertEquals((NSUInteger) 5, [genome2by2.genoNodes count], @"Incorrect number of nodes created");
    STAssertEquals((NSUInteger) 6, [genome2by2.genoLinks count], @"Incorrect number of links created");
}

-(void) testSimpleNetwork {
    ONNetwork * network2by2 = [[ONNetwork alloc] initWithGenome:genome2by2];
    
    STAssertNotNil(network2by2, @"Failed to create 2x2 Netowrk correctly");
    
    STAssertEquals((NSUInteger) 5, [network2by2.allNodes count], @"Incorrect number of nodes created in network");
}
*/
-(void) testAddNodeDoesNotChangeValue {
    [ONParameterController loadParametersFromPList:nil];
    genome2by2 = [ONGenome createSimpleGenomeWithInputs:2 outputs:2];
    ONOrganism * firstOrganism = [[ONOrganism alloc] initWithGenome:genome2by2];
    [firstOrganism developNetwork];
    ONxorExperiment *xorExperiment = [[ONxorExperiment alloc] init];
    [xorExperiment evaluateOrganism:firstOrganism];
    
    ONOrganism * childOrganism = [firstOrganism reproduceChildOrganism];
    [childOrganism developNetwork];
    [xorExperiment evaluateOrganism:childOrganism];

    STAssertEquals(firstOrganism.fitness, childOrganism.fitness, @"Child Organism should have same fitness as Parent");
}

@end
