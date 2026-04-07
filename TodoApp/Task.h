//
//  Task.h
//  TodoApp
//
//  Created by JETSMobileLabMini8 on 01/04/2026.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *taskDescription;
@property (assign, nonatomic) NSInteger priority;
@property (assign, nonatomic) NSInteger status;
@property (assign, nonatomic) NSDate *date;

- (instancetype)initWithName:(NSString *)name desc:(NSString *)desc priority:(NSInteger)priority status:(NSInteger)status date:(NSDate*)date;
@end

NS_ASSUME_NONNULL_END
