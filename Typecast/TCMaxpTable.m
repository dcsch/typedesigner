//
//  TCMaxpTable.m
//  Typecast
//
//  Created by David Schweinsberg on 3/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCMaxpTable.h"
#import "Type_Designer-Swift.h"

@implementation TCMaxpTable

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry
{
    self = [super init];
    if (self)
    {
        self.directoryEntry = [entry copy];
        _versionNumber = [dataInput readUInt32];

        // CFF fonts use version 0.5, TrueType fonts use version 1.0
        if (_versionNumber == 0x00005000)
        {
            _numGlyphs = [dataInput readUInt16];
        }
        else if (_versionNumber == 0x00010000)
        {
            _numGlyphs = [dataInput readUInt16];
            _maxPoints = [dataInput readUInt16];
            _maxContours = [dataInput readUInt16];
            _maxCompositePoints = [dataInput readUInt16];
            _maxCompositeContours = [dataInput readUInt16];
            _maxZones = [dataInput readUInt16];
            _maxTwilightPoints = [dataInput readUInt16];
            _maxStorage = [dataInput readUInt16];
            _maxFunctionDefs = [dataInput readUInt16];
            _maxInstructionDefs = [dataInput readUInt16];
            _maxStackElements = [dataInput readUInt16];
            _maxSizeOfInstructions = [dataInput readUInt16];
            _maxComponentElements = [dataInput readUInt16];
            _maxComponentDepth = [dataInput readUInt16];
        }
    }
    return self;
}

- (uint32_t)type
{
    return TCTable_maxp;
}

- (NSString *)description
{
    NSString *str = [NSString stringWithFormat:
                     @"'maxp' Table - Maximum Profile\n------------------------------"
                     @"\n        'maxp' version:         %x"
                     @"\n        numGlyphs:              %d",
                     _versionNumber,
                     _numGlyphs];

    if (_versionNumber == 0x00010000)
        str = [str stringByAppendingFormat:
               @"\n        maxPoints:              %d" //).append(maxPoints)
               @"\n        maxContours:            %d" //).append(maxContours)
               @"\n        maxCompositePoints:     %d" //).append(maxCompositePoints)
               @"\n        maxCompositeContours:   %d" //).append(maxCompositeContours)
               @"\n        maxZones:               %d" //).append(maxZones)
               @"\n        maxTwilightPoints:      %d" //).append(maxTwilightPoints)
               @"\n        maxStorage:             %d" //).append(maxStorage)
               @"\n        maxFunctionDefs:        %d" //).append(maxFunctionDefs)
               @"\n        maxInstructionDefs:     %d" //).append(maxInstructionDefs)
               @"\n        maxStackElements:       %d" //).append(maxStackElements)
               @"\n        maxSizeOfInstructions:  %d" //).append(maxSizeOfInstructions)
               @"\n        maxComponentElements:   %d" //).append(maxComponentElements)
               @"\n        maxComponentDepth:      %d",//).append(maxComponentDepth);
               _maxPoints,
               _maxContours,
               _maxCompositePoints,
               _maxCompositeContours,
               _maxZones,
               _maxTwilightPoints,
               _maxStorage,
               _maxFunctionDefs,
               _maxInstructionDefs,
               _maxStackElements,
               _maxSizeOfInstructions,
               _maxComponentElements,
               _maxComponentDepth];
    else
        str = [str stringByAppendingString:@"\n"];
    return str;
}

@end
