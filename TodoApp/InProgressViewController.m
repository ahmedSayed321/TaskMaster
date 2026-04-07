//
//  InProgressViewController.m
//  TodoApp
//
//  Created by JETSMobileLabMini8 on 01/04/2026.
//

#import "InProgressViewController.h"
#import "Task.h"
#import "EditTaskViewController.h"

@interface InProgressViewController (){
    NSMutableArray *allInProgressArray;
    NSMutableArray *lowArray;
    NSMutableArray *mediumArray;
    NSMutableArray *highArray;
    NSMutableArray *filteredArray;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *piroritySelector;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL isSearching;
@end

@implementation InProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _searchBar.delegate = self;
    self.piroritySelector.selectedSegmentIndex = 0;
    
    UITextField *searchTextField = [self.searchBar valueForKey:@"searchField"];
    searchTextField.textColor = [UIColor whiteColor];

    searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search..."
                                                                            attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    UIImageView *iconView = (UIImageView *)[searchTextField leftView];
    iconView.image = [iconView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    iconView.tintColor = [UIColor whiteColor];

    searchTextField.tintColor = [UIColor whiteColor];
    
    self.searchBar.backgroundImage = [UIImage new];
    self.searchBar.barTintColor = [UIColor clearColor];
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.tableView.layer.cornerRadius = 15.0; // You can change 15.0 to make it more or less round
        self.tableView.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
    [_tableView reloadData];
}

- (void)loadData {
    allInProgressArray = [NSMutableArray new];
    lowArray           = [NSMutableArray new];
    mediumArray        = [NSMutableArray new];
    highArray          = [NSMutableArray new];
    filteredArray      = [NSMutableArray new];

    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    NSData         *savedData = [defaults objectForKey:@"inprogress"];

    if (savedData != nil) {
        NSArray *allTasks = [NSKeyedUnarchiver unarchiveObjectWithData:savedData];
        [allInProgressArray addObjectsFromArray:allTasks];

        for (Task *task in allTasks) {
            if (task.priority == 0) {
                [lowArray addObject:task];
            } else if (task.priority == 1) {
                [mediumArray addObject:task];
            } else if (task.priority == 2) {
                [highArray addObject:task];
            }
        }
    } else {
        NSLog(@"No inprogress data found in UserDefaults");
    }

    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearching) return filteredArray.count;
    switch (self.piroritySelector.selectedSegmentIndex) {
        case 0: return lowArray.count;
        case 1: return mediumArray.count;
        case 2: return highArray.count;
        default: return allInProgressArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    Task *task;
    if (self.isSearching) {
        task = filteredArray[indexPath.row];
    } else {
        switch (self.piroritySelector.selectedSegmentIndex) {
            case 0: task = lowArray[indexPath.row]; break;
            case 1: task = mediumArray[indexPath.row]; break;
            case 2: task = highArray[indexPath.row]; break;
            default: task = allInProgressArray[indexPath.row]; break;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (self.piroritySelector.selectedSegmentIndex) {
        case 0: return @"Low Priority";
        case 1: return @"Medium Priority";
        case 2: return @"High Priority";
        default: return @"All Priority";
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 30)];
    
    if(self.piroritySelector.selectedSegmentIndex == 0) {
        label.text = @"Low Pirority";
    } else if (self.piroritySelector.selectedSegmentIndex == 1) {
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {

        Task *taskToDelete;
        NSInteger selectedSegment = self.piroritySelector.selectedSegmentIndex;

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
            [allInProgressArray removeObject:taskToDelete];

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
                    taskToDelete = allInProgressArray[indexPath.row];
                    [allInProgressArray removeObjectAtIndex:indexPath.row];
                    break;
            }
            if (selectedSegment != UISegmentedControlNoSegment) {
                [allInProgressArray removeObject:taskToDelete];
            }
        }

        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:allInProgressArray];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:data forKey:@"inprogress"];
        [defaults synchronize];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EditTaskViewController *editTask = [self.storyboard instantiateViewControllerWithIdentifier:@"EditTaskViewController"];

    Task *selectedTask;
    if (self.isSearching) {
        selectedTask = filteredArray[indexPath.row];
    } else {
        switch (self.piroritySelector.selectedSegmentIndex) {
            case 0: selectedTask = lowArray[indexPath.row]; break;
            case 1: selectedTask = mediumArray[indexPath.row]; break;
            case 2: selectedTask = highArray[indexPath.row]; break;
            default: selectedTask = allInProgressArray[indexPath.row]; break;
        }
    }

    editTask.myTask = selectedTask;
    editTask.delegate = self;
    [self presentViewController:editTask animated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.isSearching = NO;
        [filteredArray removeAllObjects];
    } else {
        self.isSearching = YES;
        [filteredArray removeAllObjects];

        NSMutableArray *currentArray;
        switch (self.piroritySelector.selectedSegmentIndex) {
            case 0: currentArray = lowArray; break;
            case 1: currentArray = mediumArray; break;
            case 2: currentArray = highArray; break;
            default: currentArray = allInProgressArray; break;
        }

        for (Task *task in currentArray) {
            if ([task.title localizedCaseInsensitiveContainsString:searchText]) {
                [filteredArray addObject:task];
            }
        }
    }
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.isSearching = NO;
    searchBar.text = @"";
    [filteredArray removeAllObjects];
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

@end
