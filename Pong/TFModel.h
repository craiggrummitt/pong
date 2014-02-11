//
//  TFModel.h
//  Pong
//
//  Created by CraigGrummitt on 10/02/2014.
//  Copyright (c) 2014 Thinkful. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFModel : NSObject

@property (assign, nonatomic) NSUInteger score1;
@property (assign, nonatomic) NSUInteger score2;
- (void)resetScores;
@end
