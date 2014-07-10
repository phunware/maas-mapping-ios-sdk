//
//  PWRouteViewController.m
//  PWMapKitSample
//
//  Created by Jay on 5/22/14.
//  Copyright (c) 2014 Phunware, Inc. All rights reserved.
//

#import "PWRouteViewController.h"

@interface PWRouteViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *routeButton;
@property (weak, nonatomic) IBOutlet UITextField *startPointTextField;
@property (weak, nonatomic) IBOutlet UITextField *endPointTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *annotations;
@property (strong, nonatomic) NSArray *results;

@property (strong, nonatomic) NSMutableDictionary *imageCache;

@property (strong, nonatomic) UIImage *emptyImage;

@end

@implementation PWRouteViewController

@synthesize routeStartPoint;
@synthesize routeEndPoint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), NO, 0.0);
    _emptyImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Do any additional setup after loading the view.
    _annotations = [_mapView.annotations sortedArrayWithOptions:NSSortStable
                                                usingComparator:^(PWBuildingAnnotation *obj1,PWBuildingAnnotation *obj2){
                                                    return [obj1.title compare:obj2.title];
                                                }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (IBAction)cancel
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
- (IBAction)textFieldDidChange: (UITextField *)textField
{
    if (textField == _endPointTextField && _startPointTextField.text.length > 0) {
        [self searchByPrefix:textField.text ignoreItem:_startPointTextField.text];
    } else {
        [self searchByPrefix:textField.text];
    }

    [_tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    // Use the first match in the list??
    
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (([_startPointTextField isFirstResponder] && _startPointTextField.text.length > 0)
        || ([_endPointTextField isFirstResponder] && (_startPointTextField.text.length > 0 || _endPointTextField.text.length > 0))
        ) {
        return _results.count;
    } else {
        return _annotations.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = @"Identifier_Route_TableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    PWBuildingAnnotation* annotaion = nil;
    if (([_startPointTextField isFirstResponder] && _startPointTextField.text.length > 0)
        || ([_endPointTextField isFirstResponder] && (_startPointTextField.text.length > 0 || _endPointTextField.text.length > 0))
        ) {
        annotaion = _results[indexPath.row];
    } else {
        annotaion = _annotations[indexPath.row];
    }

    if (_imageCache == nil) {
        _imageCache = [[NSMutableDictionary alloc] init];
    }
    
    NSString * url = annotaion.imageURL.absoluteString;

    UIImage *image = [_imageCache objectForKey:url];
    if (image == nil) {
        cell.imageView.image = _emptyImage;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageDataFromURL = [NSData dataWithContentsOfURL:annotaion.imageURL];
            if (imageDataFromURL != nil) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // check if cell is visible
                    if ([[_tableView visibleCells] containsObject: cell]) {
                        UIImage *img = [UIImage imageWithData:imageDataFromURL];
                        img = [self imageWithImage:img scaledToSize:CGSizeMake(30, 30)];
                        [_imageCache setObject:img forKey:url];
                        cell.imageView.image = img;
                        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                });
            }
        });
    } else {
        cell.imageView.image = image;
    }
    
    cell.textLabel.text = annotaion.title;
    if (_startPointTextField.text != nil && _startPointTextField.text.length > 0)
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"from %@", _startPointTextField.text];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    PWBuildingAnnotation* annotaion = nil;
    if (([_startPointTextField isFirstResponder] && _startPointTextField.text.length > 0)
        || ([_endPointTextField isFirstResponder] && (_startPointTextField.text.length > 0 || _endPointTextField.text.length > 0))
        ) {
        annotaion = _results[indexPath.row];
    } else {
        annotaion = _annotations[indexPath.row];
    }
    
    if ([_startPointTextField isFirstResponder]) {
        _startPointTextField.text = cell.textLabel.text;
        routeStartPoint = annotaion;
        [_endPointTextField becomeFirstResponder];
    } else if ([_endPointTextField isFirstResponder]) {
        _endPointTextField.text = cell.textLabel.text;
        routeEndPoint = annotaion;
    } else {
        if ([_startPointTextField.text isEqualToString:@""]) {
            _startPointTextField.text = cell.textLabel.text;
            routeStartPoint = annotaion;
            [_endPointTextField becomeFirstResponder];
        } else if ([_endPointTextField.text isEqualToString:@""]) {
            _endPointTextField.text = cell.textLabel.text;
            routeEndPoint = annotaion;
        }
    }
    
    [self searchByPrefix:_endPointTextField.text ignoreItem:_startPointTextField.text];
    [self.tableView reloadData];
}

#pragma mark - Private methods
- (void) searchByPrefix: (NSString *)prefix ignoreItem: (NSString *) ignore
{
    _results = nil;
    
    NSPredicate *resultsPredicate = nil;
    
    if (ignore && ignore.length > 0) {
        if (prefix && prefix.length > 0) {
            resultsPredicate = [NSPredicate predicateWithFormat:@"NOT (title in %@) AND (title beginswith[c] %@)", ignore, prefix];
        } else {
            resultsPredicate = [NSPredicate predicateWithFormat:@"NOT (title in %@)", ignore];
        }
    } else {
        if (prefix && prefix.length > 0) {
            resultsPredicate = [NSPredicate predicateWithFormat:@"title beginswith[c] %@", prefix];
        } else {
            // nothing to do
        }
    }

    if (resultsPredicate) {
        _results = [_annotations filteredArrayUsingPredicate:resultsPredicate];
    } else {
        _results = _annotations;
    }
}

- (void) searchByPrefix: (NSString *)prefix
{
    [self searchByPrefix:prefix ignoreItem:nil];
}

- (IBAction)onSwapTouchDown:(UIButton *)sender
{
    NSString *startPointText = _startPointTextField.text;
    _startPointTextField.text = _endPointTextField.text;
    _endPointTextField.text = startPointText;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
