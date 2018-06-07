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
    multi_path_go();
    start(tfp0);
    unlocknvram();
    NSString *currentGenerator = [NSString stringWithUTF8String:getgen()];
    _generatorLabel.text = [currentGenerator length] < 2 ? @"-unavailable-" : currentGenerator;
    locknvram();
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)generatorInputActionTriggered:(id)sender {
    const char *generator = [_generatorInput.text UTF8String];
    unlocknvram();
    setgen(generator);
    char *c = getgen();
    locknvram();
    if (!strcmp(generator, c)) {
        UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:@"Success"                                                   message:@"The generator has been set" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK"                                     style:UIAlertActionStyleDefault handler:nil];
        [AlertController addAction:OK];
        [self presentViewController:AlertController animated:YES completion:nil];
        _generatorLabel.text = [NSString stringWithUTF8String:c];
    } else {
        UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:@"Error"                                                   message:@"Failed to validate generator" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK"                                     style:UIAlertActionStyleDefault handler:nil];
        [AlertController addAction:OK];
        [self presentViewController:AlertController animated:YES completion:nil];
    }
}

@end
