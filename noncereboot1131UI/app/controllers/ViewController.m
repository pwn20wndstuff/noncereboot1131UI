//
//  ViewController.m
//  noncereboot1131UI
//
//  Created by Pwn20wnd on 6/7/18.
//  Copyright © 2018 Pwn20wnd. All rights reserved.
//

#import "ViewController.h"
#import "noncereboot.h"
#import "sploit.h"
#import "kmem.h"
#import "nonce.h"
#import "unlocknvram.h"
#import <string.h>

@interface ViewController ()

@end

mach_port_t tfp0;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    kern_return_t ret = multi_path_go();
    if (ret != KERN_SUCCESS) {
        exit(-1);
    }
    start(tfp0);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)generatorInputActionTriggered:(id)sender {
    const char *generator = [_generatorInput.text UTF8String];
    if (!_skipUnlockingNvramSwitch.on) {
        unlocknvram();
    }
    setgen(generator);
    char *c = getgen();
    if (!_skipLockingNvramSwitch.on) {
        locknvram();
    }
    if (!strcmp(generator, c)) {
        UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:@"Success"                                                   message:@"The generator has been set" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK"                                     style:UIAlertActionStyleDefault handler:nil];
        [AlertController addAction:OK];
        [self presentViewController:AlertController animated:YES completion:nil];
    } else {
        UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:@"Error"                                                   message:@"Failed to validate generator" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK"                                     style:UIAlertActionStyleDefault handler:nil];
        [AlertController addAction:OK];
        [self presentViewController:AlertController animated:YES completion:nil];
    }
}
- (IBAction)tappedOnDeleteGenerator:(id)sender {
    if (!_skipUnlockingNvramSwitch.on) {
        unlocknvram();
    }
    if (!delgen()) {
        UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:@"Success"                                                   message:@"The generator has been deleted" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK"                                     style:UIAlertActionStyleDefault handler:nil];
        [AlertController addAction:OK];
        [self presentViewController:AlertController animated:YES completion:nil];
    } else {
        UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:@"Error"                                                   message:@"Failed to deleted the generator" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK"                                     style:UIAlertActionStyleDefault handler:nil];
        [AlertController addAction:OK];
        [self presentViewController:AlertController animated:YES completion:nil];
    }
    if (!_skipLockingNvramSwitch.on) {
        locknvram();
    }
}
- (IBAction)tappedOnDumpApticket:(id)sender {
    bool ret = dump_apticket([[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"apticket.der"].UTF8String);
    if(ret)
    {
        UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:@"Success"                                                   message:@"Dumped APTicket" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK"                                     style:UIAlertActionStyleDefault handler:nil];
        [AlertController addAction:OK];
        [self presentViewController:AlertController animated:YES completion:nil];
    }
    else
    {
        UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:@"Error"                                                   message:@"Failed to dump APTicket" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK"                                     style:UIAlertActionStyleDefault handler:nil];
        [AlertController addAction:OK];
        [self presentViewController:AlertController animated:YES completion:nil];
    }
}

void openUser(NSString *name) {
    UIApplication *application = [UIApplication sharedApplication];
    NSString *str = [NSString stringWithFormat:@"%@", _urlForUsername(name)];
    NSURL *URL = [NSURL URLWithString:str];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success != YES) {
        }
    }];
}

NSString *_urlForUsername(NSString *user) {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"aphelion://"]]) {
        return [@"aphelion://profile/" stringByAppendingString:user];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot://"]]) {
        return [@"tweetbot:///user_profile/" stringByAppendingString:user];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific://"]]) {
        return [@"twitterrific:///profile?screen_name=" stringByAppendingString:user];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings://"]]) {
        return [@"tweetings:///user?screen_name=" stringByAppendingString:user];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
        return [@"twitter://user?screen_name=" stringByAppendingString:user];
    } else {
        return [@"https://mobile.twitter.com/" stringByAppendingString:user];
    }
    return nil;
}

- (IBAction)tappedOnPwn20wnd:(id)sender {
    openUser(@"Pwn20wnd");
}
- (IBAction)tappedOnCoolStar:(id)sender {
    openUser(@"coolstarorg");
}
- (IBAction)tappedOnStek29:(id)sender {
    openUser(@"stek29");
}
- (IBAction)tappedOnIanBeer:(id)sender {
    openUser(@"i41nbeer");
}

@end
