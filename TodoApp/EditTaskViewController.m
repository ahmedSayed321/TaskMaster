//
//  EditTaskViewController.m
//  TodoApp
//
//  Created by JETSMobileLabMini8 on 01/04/2026.
//

#import "EditTaskViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface EditTaskViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *descField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySelector;

@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSelector;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateSelector;

@end

@implementation EditTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dateSelector.minimumDate = [NSDate date];
    
    _titleField.text = _myTask.title;
    _descField.text = _myTask.taskDescription;
    _prioritySelector.selectedSegmentIndex = _myTask.priority;
    if(_myTask == nil){
        _statusSelector.selectedSegmentIndex = 0;
    }else{
        _statusSelector.selectedSegmentIndex = _myTask.status;
    }
    
    
}
- (IBAction)editBtn:(id)sender {
        
        Task *newTask = [[Task alloc] initWithName:self.titleField.text
                                              desc:self.descField.text
                                          priority:self.prioritySelector.selectedSegmentIndex
                                            status:self.statusSelector.selectedSegmentIndex
                                            date:self.dateSelector.date];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSInteger newStatus = self.statusSelector.selectedSegmentIndex;
        
        NSString *key;
        if (newStatus == 0) {
            key = @"todos";
        } else if (newStatus == 1) {
            key = @"inprogress";
        } else {
            key = @"done";
        }
        
        NSString *oldKey;
        if (_myTask.status == 0) {
            oldKey = @"todos";
        } else if (_myTask.status == 1) {
            oldKey = @"inprogress";
        } else {
            oldKey = @"done";
        }
        
        NSData *oldSavedData = [defaults objectForKey:oldKey];
        if (oldSavedData != nil) {
            NSMutableArray *oldArray = [[NSKeyedUnarchiver unarchiveObjectWithData:oldSavedData] mutableCopy];
            if (!oldArray) oldArray = [NSMutableArray new];
            
            for (int i = 0; i < oldArray.count; i++) {
                Task *t = oldArray[i];
                if ([t.title isEqualToString:_myTask.title] && t.priority == _myTask.priority) {
                    [oldArray removeObjectAtIndex:i];
                    break;
                }
            }
            
            NSData *updatedOldData = [NSKeyedArchiver archivedDataWithRootObject:oldArray];
            [defaults setObject:updatedOldData forKey:oldKey];
        }
        
        NSData *newSavedData = [defaults objectForKey:key];
        NSMutableArray *newArray;
        if (newSavedData != nil) {
            newArray = [[NSKeyedUnarchiver unarchiveObjectWithData:newSavedData] mutableCopy];
            if (!newArray) newArray = [NSMutableArray new];
        } else {
            newArray = [NSMutableArray new]; 
        }
        
        [newArray addObject:newTask];
        
        NSData *updatedData = [NSKeyedArchiver archivedDataWithRootObject:newArray];
        [defaults setObject:updatedData forKey:key];
        [defaults synchronize];
        
        [_delegate loadData];
            [self scedueleNotification:newTask];
        [self dismissModalViewControllerAnimated:YES];
    
}

    -(void) scedueleNotification :(Task * )task{
        if (task.date == nil){
            return;
        }
        
        
        
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            content.title = @"Task reminder";
            content.body = task.title;
            content.sound = [UNNotificationSound defaultSound];
            
            NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear |NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute)fromDate:task.date];
                
            UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];
        
        UNNotificationRequest *request =[UNNotificationRequest requestWithIdentifier:[[NSUUID UUID]UUIDString] content:content trigger:trigger];
        
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
    }


@end
