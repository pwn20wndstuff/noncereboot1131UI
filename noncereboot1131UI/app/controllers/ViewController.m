//
//  ViewController.m
//  noncereboot1131UI
//
//  Created by Pwn20wnd on 6/30/18.
//  Copyright © 2018 Pwn20wnd. All rights reserved.
//

#import "ViewController.h"
#include "multi_path_sploit.h"
#include "vfs_sploit.h"
#include "offsets.h"
#include "noncereboot.h"
#include "kmem.h"
#include "unlocknvram.h"
#include "nonce.h"

@interface ViewController ()

@end

@implementation ViewController

#define localize(key) NSLocalizedString(key, @"")

#define MY_TWITTER_HANDLE "Pwn20wnd"
#define K_GENERATOR "generator"

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    switch (offsets_init()) {
        case ERR_NOERR: {
            break;
        }
        case ERR_VERSION: {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:localize(@"Status") message:localize(@"Version Error") preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertController animated:YES completion:nil];
            });
            return;
        }
            
        default: {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:localize(@"Error") message:localize(@"Offsets") preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertController animated:YES completion:nil];
            });
            return;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:localize(@"Please wait (1/3)") message:localize(@"Starting noncereboot1131") preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
#if WANT_VFS
        int exploitstatus = vfs_sploit();
#else /* !WANT_VFS */
        int exploitstatus = multi_path_go();
#endif /* !WANT_VFS */
        
        switch (exploitstatus) {
            case ERR_NOERR: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:NO completion:nil];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:localize(@"Please wait (2/3)") message:localize(@"Starting noncereboot1131") preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:alertController animated:YES completion:nil];
                });
                break;
            }
            case ERR_EXPLOIT: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:NO completion:nil];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:localize(@"Error") message:localize(@"Exploit") preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:alertController animated:YES completion:nil];
                });
                return;
            }
            case ERR_UNSUPPORTED: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:NO completion:nil];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:localize(@"Error") message:localize(@"Unsupported") preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:alertController animated:YES completion:nil];
                });
                return;
            }
            default:
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:NO completion:nil];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:localize(@"Status") message:localize(@"Error Exploiting") preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:alertController animated:YES completion:nil];
                });
                return;
        }
        
        int postexploitationstatus = start_noncereboot(tfp0);
        
        switch (postexploitationstatus) {
            case ERR_NOERR: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:NO completion:nil];
                });
                break;
            }
            case ERR_TFP0: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:NO completion:nil];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:localize(@"Error") message:localize(@"tfp0") preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:alertController animated:YES completion:nil];
                });
                break;
            }
            default: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:NO completion:nil];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:localize(@"Status") message:localize(@"Error Post-exploitation") preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:alertController animated:YES completion:nil];
                });
                break;
            }
        }
        bool ret = dump_apticket([[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"apticket.der"].UTF8String);
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedOnSetGenerator:(id)sender {
    const char *generatorInput = [_generatorInput.text UTF8String];
    char compareString[22];
    uint64_t rawGeneratorValue;
    sscanf(generatorInput, "0x%16llx",&rawGeneratorValue);
    sprintf(compareString, "0x%016llx", rawGeneratorValue);
    if(strcmp(compareString, generatorInput) == 0) {
        unlocknvram();
        if (setgen(generatorInput) == 0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:localize(@"Success") message:localize(@"The generator has been set") preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:localize(@"OK") style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        locknvram();
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:localize(@"Error") message:localize(@"Failed to validate generator") preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:localize(@"OK") style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

NSString *getURLForUsername(NSString *user) {
    UIApplication *application = [UIApplication sharedApplication];
    if ([application canOpenURL:[NSURL URLWithString:@"tweetbot://"]]) {
        return [@"tweetbot:///user_profile/" stringByAppendingString:user];
    } else if ([application canOpenURL:[NSURL URLWithString:@"twitterrific://"]]) {
        return [@"twitterrific:///profile?screen_name=" stringByAppendingString:user];
    } else if ([application canOpenURL:[NSURL URLWithString:@"tweetings://"]]) {
        return [@"tweetings:///user?screen_name=" stringByAppendingString:user];
    } else if ([application canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
        return [@"twitter://user?screen_name=" stringByAppendingString:user];
    } else {
        return [@"https://mobile.twitter.com/" stringByAppendingString:user];
    }
    return nil;
}

- (IBAction)tappedOnMe:(id)sender {
    UIApplication *application = [UIApplication sharedApplication];
    NSString *str = getURLForUsername(@MY_TWITTER_HANDLE);
    NSURL *URL = [NSURL URLWithString:str];
    [application openURL:URL options:@{} completionHandler:nil];
}

@end
