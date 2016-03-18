//
//  test.m
//  PrivateTest
//
//  Created by 刘向宏 on 16/3/18.
//  Copyright © 2016年 刘向宏. All rights reserved.
//

#import "NSObject+methods.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (methods)
-(void)logMethods{
    unsigned int count;
    Method *methods = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *name = NSStringFromSelector(selector);
        //        if ([name hasPrefix:@"test"])
        NSLog(@"方法 名字 ==== %@",name);
        if (name)
        {
            //avoid arc warning by using c runtime
            //            objc_msgSend(self, selector);
        }
        //NSLog(@"Test '%@' completed successfuly", [name substringFromIndex:4]);
    }
}
@end