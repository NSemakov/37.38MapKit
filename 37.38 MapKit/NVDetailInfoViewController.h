//
//  NVEducationViewController.h
//  36. UIPopover
//
//  Created by Admin on 19.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewController;
@class NVStudent;
@interface NVDetailInfoViewController : UITableViewController <UITextFieldDelegate>
- (IBAction)actionDone:(UIBarButtonItem *)sender;
@property (strong,nonatomic) ViewController* delegate;
@property (strong,nonatomic) NSMutableArray *arrayOfEducation;
@property (strong,nonatomic) NSString* initialEducation;
@property (strong,nonatomic) NSDictionary* dictionaryWithAddress;
@property (strong,nonatomic) NVStudent* student;

@property (weak, nonatomic) IBOutlet UITextField *fieldFirstname;
@property (weak, nonatomic) IBOutlet UITextField *fieldLastname;
@property (weak, nonatomic) IBOutlet UITextField *fieldSex;
@property (weak, nonatomic) IBOutlet UITextField *fieldDateOfBirth;
@property (weak, nonatomic) IBOutlet UITextField *fieldAddress;



@end
