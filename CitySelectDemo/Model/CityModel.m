//
//  CityModel.m
//  Intelligent_Fire
//
//  Created by 高磊 on 2016/11/11.
//  Copyright © 2016年 高磊. All rights reserved.
//

#import "CityModel.h"
#import "DistrictModel.h"

@implementation CityModel

- (void)setData:(NSArray *)newdata
{
    NSMutableArray *reArray = [NSMutableArray arrayWithCapacity:newdata.count];
    for (NSDictionary *dic in newdata)
    {
        DistrictModel *record = [DistrictModel modelObjectWithDictionary:dic];
        [reArray addObject:record];
    }
    _data = [reArray copy];
}

@end
