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
    
//    Method m1 = class_getInstanceMethod([NSObject class], @selector(test1));
//    Method m2 = class_getInstanceMethod([NSObject class], @selector(test2));
//    method_exchangeImplementations(m1, m2);
}

-(void)chage{
    Class PersionClass = object_getClass([NSArray class]);
    Class toolClass = object_getClass([NSString class]);
    
    ////源方法的SEL和Method
    
    SEL oriSEL = @selector(description);
    Method oriMethod = class_getInstanceMethod(PersionClass, oriSEL);
    
    ////交换方法的SEL和Method
    
    SEL cusSEL = @selector(count);
    Method cusMethod = class_getInstanceMethod(toolClass, cusSEL);
    
    ////先尝试給源方法添加实现，这里是为了避免源方法没有实现的情况
    
    BOOL addSucc = class_addMethod(PersionClass, oriSEL, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
    if (addSucc) {
        // 添加成功：将源方法的实现替换到交换方法的实现
        class_replaceMethod(toolClass, cusSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
        
    }else {
        //添加失败：说明源方法已经有实现，直接将两个方法的实现交换即
        method_exchangeImplementations(oriMethod, cusMethod);
    }
}

@end



//@implementation UIButton (Hook)
//
//+ (void)load {
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        Class selfClass = [self class];
//        
//        SEL oriSEL = @selector(sendAction:to:forEvent:);
//        Method oriMethod = class_getInstanceMethod(selfClass, oriSEL);
//        
//        SEL cusSEL = @selector(mySendAction:to:forEvent:);
//        Method cusMethod = class_getInstanceMethod(selfClass, cusSEL);
//        
//        BOOL addSucc = class_addMethod(selfClass, oriSEL, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
//        if (addSucc) {
//            class_replaceMethod(selfClass, cusSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
//        }else {
//            method_exchangeImplementations(oriMethod, cusMethod);
//        }
//        
//    });
//}
//
//- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
//    [CountTool addClickCount];
//    [self mySendAction:action to:target forEvent:event];
//}
//
//@end