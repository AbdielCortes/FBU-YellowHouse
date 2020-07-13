//
//  SignUpViewController.m
//  YellowHouse
//
//  Created by zurken on 7/13/20.
//  Copyright © 2020 Abdiel Cortes. All rights reserved.
//

#import "SignUpViewController.h"
#import "Utilities.h"
#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create progress pop up
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    self.hud.label.text = @"Signing Up";
    self.hud.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:self.hud];
}

- (IBAction)tappedSignUp:(id)sender {
    [self.hud showAnimated:YES]; // show progress pop up
    
    if ([self.emailField.text isEqual:@""]) { // email field has no text
        [Utilities showOkAlert:self withTitle:@"Email Required" withMessage:@"In order to create an account you must provide an email address."];
    }
    else if ([self.usernameField.text isEqual:@""]) { // username has no text
        [Utilities showOkAlert:self withTitle:@"Username Required" withMessage:@"In order to create an account you must provide a username."];
    }
    else if ([self.passwordField.text isEqual:@""] || [self.confirmPasswordField.text isEqual:@""]) { // password or confirmPass word have no text
        [Utilities showOkAlert:self withTitle:@"Password Required" withMessage:@"In order to create an account you must provide a password."];
    }
    else if (![self.passwordField.text isEqual:self.confirmPasswordField.text]){ // pasword and confirm password don't match
        [Utilities showOkAlert:self withTitle:@"Passwords Don't Match" withMessage:@"Both password must be the same."];
    }
    else {
        [self registerUser];
    }
}

-(void)registerUser {
    PFUser *newUser = [PFUser user];
    
    newUser.email = self.emailField.text;
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            
            if (error.code == 203) { // account already exists with this email
                [Utilities showOkAlert:self withTitle:@"Account Error" withMessage:@"Account already exists for this email address."];
            }
            else if (error.code == 202) { // account already exists with this username
                [Utilities showOkAlert:self withTitle:@"Account Error" withMessage:@"Account already exists for this username."];
            }
        }
        else {
            [self performSegueWithIdentifier:@"SignUpSegue" sender:nil];
        }
        
        // hide progress pop up
        // outside if/else because we want it to always hide no matter the result
        [self.hud hideAnimated:YES];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
