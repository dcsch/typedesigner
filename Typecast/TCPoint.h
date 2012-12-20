//
//  TCPoint.h
//  Type Designer
//
//  Created by David Schweinsberg on 20/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCPoint : NSObject

@property int x;
@property int y;
@property (getter = isOnCurve) BOOL onCurve;
@property (getter = isEndOfContoure) BOOL endOfContour;
@property (getter = isTouched) BOOL touched;

@end
