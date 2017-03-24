//
//  LGMusic.m
//  LGMusic
//
//  Created by SHERMAN on 2017/3/16.
//  Copyright © 2017年 sherman. All rights reserved.
//

#import "LGMusic.h"

@implementation LGMusic

-(instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)musicWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
@end
