//
//  GLCoderObject.m
//  Consulting
//
//  Created by 高磊 on 16/3/29.
//  Copyright © 2016年 高磊. All rights reserved.
//

#import "GLCoderObject.h"
#import <objc/runtime.h>

@implementation GLCoderObject

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    id obj = [[self alloc] init];
    
    [obj setValuesForKeysWithDictionary:dict];
    
    return obj;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count;
    Ivar* ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char* name = ivar_getName(ivar);
        NSString* strName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:strName];
        [aCoder encodeObject:value forKey:strName];
    }
    free(ivars);
}

//解档
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        unsigned int count;
        Ivar *ivars = class_copyIvarList([self class], &count);
        
        for (int i = 0; i < count; i ++)
        {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *strName = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:strName];
            [self setValue:value forKey:strName];
        }
        free(ivars);
    }
    return self;
}


- (id)copyWithZone:(NSZone *)zone
{
    return nil;
}



/**
 描述信息

 @return 返回描述信息  利于我们在debug 的时候方便查看
 */
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@",[self getObjectData:self]];
}



/**
 将对象转为NSDictionary

 @param obj 对象
 @return 返回的NSDictionary
 */
- (NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];
        }
        
        [dic setObject:value forKey:propName];
    }
    return dic;
}


/**
 针对对象里面属性的不同属性 进行转换

 @param obj 对象
 @return 返回
 */
- (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}

@end
