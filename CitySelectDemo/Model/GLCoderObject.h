//
//  GLCoderObject.h
//  Consulting
//
//  Created by 高磊 on 16/3/29.
//  Copyright © 2016年 高磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLCoderObject : NSObject<NSCoding, NSCopying>

//动态映射 将字典里的数据 赋值到模型

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;

@end
