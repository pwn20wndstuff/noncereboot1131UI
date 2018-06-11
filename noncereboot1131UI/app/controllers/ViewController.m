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

@end
