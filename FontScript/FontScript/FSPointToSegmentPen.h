//
//  FSPointToSegmentPen.h
//  FontScript
//
//  Created by David Schweinsberg on 7/9/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSPointPen.h"
#import "FSPen.h"

NS_SWIFT_NAME(PointToSegmentPen)
@interface FSPointToSegmentPen : NSObject <FSPointPen>

- (nonnull instancetype)initWithPen:(nonnull NSObject<FSPen> *)pen NS_DESIGNATED_INITIALIZER;
- (instancetype)init __attribute__((unavailable));

@end
