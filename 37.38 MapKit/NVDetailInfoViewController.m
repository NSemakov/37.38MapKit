//
//  NVEducationViewController.m
//  36. UIPopover
//
//  Created by Admin on 19.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "NVDetailInfoViewController.h"
#import "ViewController.h"
#import "NVStudent.h"
@interface NVDetailInfoViewController ()

@end

@implementation NVDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.arrayOfEducation=[[NSMutableArray alloc]initWithObjects:@"Low",@"Middle",@"High", nil];
    if (self.student) {
        self.fieldFirstname.text=self.student.firstname;
        self.fieldLastname.text=self.student.lastname;
        if (self.student.isMan) {
            self.fieldSex.text=@"Man";
        } else {
            self.fieldSex.text=@"Woman";
        }
        NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd.MM.yyyy"];
        self.fieldDateOfBirth.text=[formatter stringFromDate:self.student.dateOfBirth];
    }
    if (self.dictionaryWithAddress) {
        self.fieldAddress.text=[self.dictionaryWithAddress valueForKey:@"name"];
        
    }
}
- (void) dealloc{
    //NSLog(@"popover deallocated");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}
#pragma mark - UITableViewDelegate
#pragma mark - actions
- (IBAction)actionDone:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
