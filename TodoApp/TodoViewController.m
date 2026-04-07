//
//  TodoViewController.m
//  TodoApp
//
//  Created by JETSMobileLabMini8 on 01/04/2026.
//

#import "TodoViewController.h"
#import "Task.h"
#import "AddTaskViewController.h"
#import "EditTaskViewController.h"
@interface TodoViewController (){
        NSMutableArray *allTasksArray;
        NSMutableArray *lowArray;
        NSMutableArray *mediumArray;
        NSMutableArray *highArray;
        NSMutableArray *filteredArray;
    
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) BOOL isSearching;

@end

@implementation TodoViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    _searchBar.delegate = self;
    
    UITextField *searchTextField = [self.searchBar valueForKey:@"searchField"];

       searchTextField.textColor = [UIColor whiteColor];

       searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search..."
       attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

       UIImageView *iconView = [searchTextField leftView];
       iconView.image = [iconView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
       iconView.tintColor = [UIColor whiteColor];

       searchTextField.tintColor = [UIColor whiteColor];
    
    self.searchBar.backgroundImage = [UIImage new];
    self.searchBar.barTintColor = [UIColor clearColor];
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.tableView.layer.cornerRadius = 15.0; // You can change 15.0 to make it more or less round
        self.tableView.clipsToBounds = YES;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    [self loadData];

}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.prioritySegment.selectedSegmentIndex == UISegmentedControlNoSegment) {
           return 3;
       }
       
       return 1;
    
  
}
- (IBAction)addTaskBtn:(id)sender {
    
    AddTaskViewController * addTask = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTaskViewController"];
    
    addTask.delegate = self;
    
    [self presentViewController:addTask animated:YES completion:nil];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearching) return filteredArray.count;
    switch (_prioritySegment.selectedSegmentIndex) {
        case 0: return lowArray.count;
        case 1: return mediumArray.count;
        case 2: return highArray.count;
        default: return allTasksArray.count;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Task *task;
    if (self.isSearching) {
        task = filteredArray[indexPath.row];
    } else {
        switch (self.prioritySegment.selectedSegmentIndex) {
            case 0: task = lowArray[indexPath.row]; break;
            case 1: task = mediumArray[indexPath.row]; break;
            case 2: task = highArray[indexPath.row]; break;
            default: task = allTasksArray[indexPath.row]; break;
        }
    }
    
    cell.textLabel.text = task.title;
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];

    cell.detailTextLabel.text = [formatter stringFromDate:task.date];
    
    
    if (task.priority == 0) {
        [cell setTintColor:[UIColor greenColor]];
    } else if (task.priority == 1) {
        [cell setTintColor:[UIColor yellowColor]];
    } else {
        [cell setTintColor:[UIColor redColor]];
    }
    
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EditTaskViewController *editTask = [self.storyboard instantiateViewControllerWithIdentifier:@"EditTaskViewController"];
    
    Task *selectedTask;
    if (self.isSearching) {
        selectedTask = filteredArray[indexPath.row]; 
    } else {
        switch (self.prioritySegment.selectedSegmentIndex) {
            case 0: selectedTask = lowArray[indexPath.row]; break;
            case 1: selectedTask = mediumArray[indexPath.row]; break;
            case 2: selectedTask = highArray[indexPath.row]; break;
            default: selectedTask = allTasksArray[indexPath.row]; break;
        }
    }
    
    editTask.myTask = selectedTask;
    editTask.delegate = self;
    [self presentViewController:editTask animated:YES completion:nil];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 30)];
    
    if(self.prioritySegment.selectedSegmentIndex == 0) {
        label.text = @"Low Pirority";
    } else if (self.prioritySegment.selectedSegmentIndex == 1) {
        label.text = @"Medium Pirority";
    } else {
        label.text = @"High Pirority";
    }
    
    label.textColor = [UIColor systemYellowColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    
    [view addSubview:label];
    
    return view;
}
- (IBAction)priorityOnClick:(id)sender {
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (void)loadData{
    allTasksArray = [NSMutableArray new];
    lowArray = [NSMutableArray new];
    mediumArray = [NSMutableArray new];
    highArray = [NSMutableArray new];
    filteredArray = [NSMutableArray new];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *savedData = [defaults objectForKey:@"todos"];
    
    if (savedData != nil) {
        NSArray *allTasks = [NSKeyedUnarchiver unarchiveObjectWithData:savedData];
        
        [allTasksArray addObjectsFromArray:allTasks];
        
        for (Task *task in allTasks) {
            if (task.priority == 0) {
                [lowArray addObject:task];
            } else if (task.priority == 1) {
                [mediumArray addObject:task];
            } else if (task.priority == 2) {
                [highArray addObject:task];
            }
        }
    }else{
        printf("Your data array is not found ");
    }

    [self.tableView reloadData];
}


    -(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath {

        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            Task *taskToDelete;
            NSInteger selectedSegment = self.prioritySegment.selectedSegmentIndex;
            
            if (self.isSearching) {
                taskToDelete = filteredArray[indexPath.row];
                [filteredArray removeObjectAtIndex:indexPath.row];
                
                if (taskToDelete.priority == 0) {
                    [lowArray removeObject:taskToDelete];
                } else if (taskToDelete.priority == 1) {
                    [mediumArray removeObject:taskToDelete];
                } else {
                    [highArray removeObject:taskToDelete];
                }
                
                [allTasksArray removeObject:taskToDelete];
                
            } else {
                switch (selectedSegment) {
                    case 0:
                        taskToDelete = lowArray[indexPath.row];
                        [lowArray removeObjectAtIndex:indexPath.row];
                        break;
                    case 1:
                        taskToDelete = mediumArray[indexPath.row];
                        [mediumArray removeObjectAtIndex:indexPath.row];
                        break;
                    case 2:
                        taskToDelete = highArray[indexPath.row];
                        [highArray removeObjectAtIndex:indexPath.row];
                        break;
                    default:
                        taskToDelete = allTasksArray[indexPath.row];
                        [allTasksArray removeObjectAtIndex:indexPath.row];
                        break;
                }
                
                if (selectedSegment != UISegmentedControlNoSegment) {
                    [allTasksArray removeObject:taskToDelete];
                }
            }

            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:allTasksArray];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:data forKey:@"todos"];
            [defaults synchronize];

            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.isSearching = NO;
        [filteredArray removeAllObjects];
    } else {
        self.isSearching = YES;
        [filteredArray removeAllObjects];
        
        // Search in the currently active array based on segment
        NSMutableArray *currentArray;
        switch (self.prioritySegment.selectedSegmentIndex) {
            case 0: currentArray = lowArray; break;
            case 1: currentArray = mediumArray; break;
            case 2: currentArray = highArray; break;
            default: currentArray = allTasksArray; break;
        }
        
        for (Task *task in currentArray) {
            if ([task.title localizedCaseInsensitiveContainsString:searchText]) {
                [filteredArray addObject:task];
            }
        }
    }
    [self.tableView reloadData];
}
@end
