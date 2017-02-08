//
//  ProvinceModel.m
//  Intelligent_Fire
//
//  Created by 高磊 on 2016/11/11.
//  Copyright © 2016年 高磊. All rights reserved.
//

#import "ProvinceModel.h"
#import "CityModel.h"
#import "DistrictModel.h"

@implementation ProvinceModel

- (void)setData:(NSArray *)newdata
{
    NSMutableArray *reArray = [NSMutableArray arrayWithCapacity:newdata.count];
    for (NSDictionary *dic in newdata)
    {
        CityModel *record = [CityModel modelObjectWithDictionary:dic];
        [reArray addObject:record];
    }
    _data = [reArray copy];
}


+(NSMutableArray *)provinceModelsWithDataList:(NSArray *)datalist
{
    NSMutableArray *reArray = [NSMutableArray arrayWithCapacity:datalist.count];
    for (NSDictionary *dic in datalist)
    {
        ProvinceModel *record = [ProvinceModel modelObjectWithDictionary:dic];
        [reArray addObject:record];
    }
    
    NSMutableArray *resultArray = [reArray mutableCopy];
    
    return resultArray;
}

+(NSMutableArray *)provinceModels
{
    NSMutableArray *array = [ProvinceModel provinceModelsWithDataList:[ProvinceModel cityList]];

    return array;
}

+(NSArray *)cityList
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"city" ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    NSArray *array = dic[@"city"];
    
    return array;
}


+ (NSString *)areaNameWithAreaId:(NSString *)areaId
{
    NSString *areaName = @"";
    NSMutableArray *array = [ProvinceModel provinceModelsWithDataList:[ProvinceModel cityList]];
    for (ProvinceModel *provincemodel in array)
    {
        for (CityModel *cityModel in provincemodel.data)
        {
            for (DistrictModel *distructModel in cityModel.data)
            {
                if ([distructModel.s_id isEqualToString:areaId])
                {
                    areaName = distructModel.name;
                    break;
                }
            }
        }
    }
    return areaName;
}



@end
