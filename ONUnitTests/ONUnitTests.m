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
    STAssertTrue([ONParameterController loadParametersFromPList:nil], 
                 @"Failed to load default parameters file");
    STAssertEquals(1.0, [ONParameterController weightMutationPower], @"Weight mutation value not loaded correctly");
    
    STAssertTrue([ONParameterController loadParametersFromPList:@"p2blank"], 
                 @"Failed to load specified parameters file");
    STAssertEquals(1.5, [ONParameterController weightMutationPower], @"Weight mutation value not set to tes case - specified parameters file not loaded properly");
    
    STAssertTrue([ONParameterController loadParametersFromPList:@"p2blank.plist"], 
                 @"Failed to load file with filename extension passed in (albeit incorrectly)");
}

-(void) testSimpleNeuron {
    // check that we create simple genomes correctly
    ONGenome * genome2by2 = [ONGenome createSimpleGenomeWithInputs:2 outputs:2];
    STAssertNotNil(genome2by2, @"Failed to create 2x2 Genome correctly");
    
    STAssertEquals((NSUInteger) 5, [genome2by2.nodes count], @"Incorrect number of nodes created");
    STAssertEquals((NSUInteger) 6, [genome2by2.genes count], @"Incorrect number of genes created");
}

@end
