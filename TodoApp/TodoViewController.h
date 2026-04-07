//
//  TodoViewController.h
//  TodoApp
//
//  Created by JETSMobileLabMini8 on 01/04/2026.
//

#import <UIKit/UIKit.h>
#import "MyDelegation.h"
NS_ASSUME_NONNULL_BEGIN

@interface TodoViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,MyDelegation,UISearchBarDelegate>

@end

NS_ASSUME_NONNULL_END
