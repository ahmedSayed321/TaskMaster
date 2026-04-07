//
//  Task.m
//  TodoApp
//
//  Created by JETSMobileLabMini8 on 01/04/2026.
//

#import "Task.h"

@implementation Task

- (instancetype)initWithName:(NSString *)name desc:(NSString *)desc priority:(NSInteger)priority status:(NSInteger)status date:(NSDate*)date{
    self = [super init];
    if (self) {
        _title = name;
        _taskDescription = desc;
        _priority = priority;
        _status = status;
        _date = date;
        
        
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.taskDescription forKey:@"taskDescription"];
    [coder encodeInteger:self.priority forKey:@"priority"];
    [coder encodeInteger:self.status forKey:@"status"];
    [coder encodeObject:self.date forKey:@"date"];
    
}
 
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _title = [coder decodeObjectForKey:@"title"];
        _taskDescription = [coder decodeObjectForKey:@"taskDescription"];
        _priority = [coder decodeIntegerForKey:@"priority"];
        _status = [coder decodeIntegerForKey:@"status"];
        _date = [coder decodeObjectForKey:@"date"];
    }
    return self;
    
}



@end
