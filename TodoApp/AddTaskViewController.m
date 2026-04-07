//
//  AddTaskViewController.m
//  TodoApp
//
//  Created by JETSMobileLabMini8 on 01/04/2026.
//

#import "AddTaskViewController.h"
#import "Task.h"
#import <UserNotifications/UserNotifications.h>

@interface AddTaskViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateSelector;
@property (weak, nonatomic) IBOutlet UITextView *descField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegement;
@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dateSelector.minimumDate = [NSDate date];


    
}



- (IBAction)addTaskBtn:(id)sender {
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSData *savedData = [defaults objectForKey:@"todos"];
        NSMutableArray *todos;
        
        if (savedData != nil) {
            todos = [NSKeyedUnarchiver unarchiveObjectWithData:savedData];
        } else {
            todos = [NSMutableArray new];
        }
    
    Task *task = [[Task alloc] initWithName:self.titleField.text
                                          desc:self.descField.text
                                      priority:self.prioritySegement.selectedSegmentIndex
                                        status:0
                                        date:_dateSelector.date];
    
    [todos addObject:task];

    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:todos];

    
    [defaults setObject:data forKey:@"todos"];
        [defaults synchronize];
    
    [_delegate loadData];
    
    [self scedueleNotification:task];
    
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
