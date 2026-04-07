//
//  EditTaskViewController.h
//  TodoApp
//
//  Created by JETSMobileLabMini8 on 01/04/2026.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "MyDelegation.h"
NS_ASSUME_NONNULL_BEGIN

@interface EditTaskViewController : UIViewController

@property Task * myTask;
@property id<MyDelegation> delegate;

@end

NS_ASSUME_NONNULL_END
