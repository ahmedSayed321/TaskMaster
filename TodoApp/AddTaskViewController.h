//
//  AddTaskViewController.h
//  TodoApp
//
//  Created by JETSMobileLabMini8 on 01/04/2026.
//

#import "ViewController.h"
#import "MyDelegation.h"
NS_ASSUME_NONNULL_BEGIN

@interface AddTaskViewController : ViewController <NSCoding>

@property id<MyDelegation> delegate;

@end

NS_ASSUME_NONNULL_END
