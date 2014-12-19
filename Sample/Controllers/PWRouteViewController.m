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
@property (weak, nonatomic) IBOutlet UIButton *reversalButton;
@property (weak, nonatomic) IBOutlet UITextField *startPointTextField;
@property (weak, nonatomic) IBOutlet UITextField *endPointTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *accessibilityButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (strong, nonatomic) NSArray *results;

@property (strong, nonatomic) NSMutableDictionary *imageCache;

@property (strong, nonatomic) UIImage *emptyImage;

- (IBAction)toggleAccessibility;

@end

@implementation PWRouteViewController

@synthesize routeStartPoint;
@synthesize routeEndPoint;

#pragma mark - UIViewController

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
    
    __weak __typeof(&*self)weakSelf = self;
    
    [[PWBuildingManager sharedManager] getBuildingAnnotationsWithBuildingID:self.mapView.buildingID completion:^(NSArray *annotations, NSError *error) {
        weakSelf.annotations = [annotations sortedArrayWithOptions:NSSortStable
                                                   usingComparator:^(id<PWBuildingAnnotationProtocol> obj1,id<PWBuildingAnnotationProtocol> obj2){
                                                       return [obj1.title compare:obj2.title];
                                                   }];
        
        [weakSelf.tableView reloadData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidShow:)
												 name:UIKeyboardDidShowNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - User Actions

- (IBAction)toggleAccessibility
{
	self.accessibilityButton.selected = !self.accessibilityButton.selected;
	self.shouldUseAccessibleRoutes = !self.shouldUseAccessibleRoutes;
}

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
    NSString *cellIdentifier = @"Identifier_Route_TableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    id<PWBuildingAnnotationProtocol> annotation = nil;
    if (([_startPointTextField isFirstResponder] && _startPointTextField.text.length > 0)
        || ([_endPointTextField isFirstResponder] && (_startPointTextField.text.length > 0 || _endPointTextField.text.length > 0))
        ) {
        annotation = _results[indexPath.row];
    } else {
        annotation = _annotations[indexPath.row];
    }
    
    if (_imageCache == nil) {
        _imageCache = [[NSMutableDictionary alloc] init];
    }
    
    NSString *url = annotation.imageURL.absoluteString;
    
    UIImage *image = [_imageCache objectForKey:url];
    if (image == nil) {
        cell.imageView.image = _emptyImage;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageDataFromURL = [NSData dataWithContentsOfURL:annotation.imageURL];
            if (imageDataFromURL != nil) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // check if cell is visible
                    if ([[_tableView visibleCells] containsObject: cell]) {
                        UIImage *img = [UIImage imageWithData:imageDataFromURL];
                        img = [self imageWithImage:img scaledToSize:CGSizeMake(30, 30)];
                        [_imageCache setObject:img forKey:url];
                        cell.imageView.image = img;
                    }
                });
            }
        });
    } else {
        cell.imageView.image = image;
    }
    
    cell.textLabel.text = annotation.title;
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
    
    id<PWBuildingAnnotationProtocol> annotation = nil;
    if (([_startPointTextField isFirstResponder] && _startPointTextField.text.length > 0)
        || ([_endPointTextField isFirstResponder] && (_startPointTextField.text.length > 0 || _endPointTextField.text.length > 0))
        ) {
        annotation = _results[indexPath.row];
    } else {
        annotation = _annotations[indexPath.row];
    }
    
    if ([_startPointTextField isFirstResponder]) {
        _startPointTextField.text = cell.textLabel.text;
        routeStartPoint = annotation;
        [_endPointTextField becomeFirstResponder];
    } else if ([_endPointTextField isFirstResponder]) {
        _endPointTextField.text = cell.textLabel.text;
        routeEndPoint = annotation;
    } else {
        if ([_startPointTextField.text isEqualToString:@""]) {
            _startPointTextField.text = cell.textLabel.text;
            routeStartPoint = annotation;
            [_endPointTextField becomeFirstResponder];
        } else if ([_endPointTextField.text isEqualToString:@""]) {
            _endPointTextField.text = cell.textLabel.text;
            routeEndPoint = annotation;
        }
    }
    
    [self searchByPrefix:_endPointTextField.text ignoreItem:_startPointTextField.text];
    [self.tableView reloadData];
}

#pragma mark - UIKeyboard

- (void)keyboardDidShow:(NSNotification *)notification
{
    if ([self.startPointTextField isFirstResponder] ||
        [self.endPointTextField isFirstResponder]) {
        NSDictionary *info = [notification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        [UIView animateWithDuration:duration
                         animations:^{
                             self.tableView.contentInset = UIEdgeInsetsMake(0, self.tableView.contentInset.left, kbSize.height, 0);
                             self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, self.tableView.scrollIndicatorInsets.left, kbSize.height, 0);
                         }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if ([self.startPointTextField isFirstResponder] ||
        [self.endPointTextField isFirstResponder]) {
        NSDictionary *info = [notification userInfo];
        CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        [UIView animateWithDuration:duration
                         animations:^{
                             self.tableView.contentInset = UIEdgeInsetsMake(0, self.tableView.contentInset.left, 0, 0);
                             self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, self.tableView.scrollIndicatorInsets.left, 0, 0);
                         }];
    }
}

#pragma mark - Internal

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

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
