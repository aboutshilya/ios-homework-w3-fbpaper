//
//  MainViewController.m
//  Papper
//
//  Created by Shilya Lee on 6/22/14.
//  Copyright (c) 2014 Shilya Lee. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()


@property (weak, nonatomic) IBOutlet UIView *sectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *articlesView;
- (IBAction)onPan:(UIPanGestureRecognizer *)sender;
- (void)createNewsTiles;
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;

@end

@implementation MainViewController

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
    [self createNewsTiles];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)createNewsTiles{
    for (int i = 1; i < 6; i++) {
        
        NSMutableString* imgName = [NSMutableString stringWithFormat:@"news%d", i];
        
        UIImage *img = [UIImage imageNamed:imgName];
        
        UIImageView *newsView = [[UIImageView alloc] initWithFrame:CGRectMake((i-1)*145, 0, 143, 254)];
        
        [newsView setImage:img];
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        newsView.userInteractionEnabled = YES;
        [newsView addGestureRecognizer:singleFingerTap];
        
        [self.articlesView addSubview:newsView];
    }
    
    self.articlesView.clipsToBounds = YES;
    self.articlesView.contentSize = CGSizeMake(5*145,254);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPan:(UIPanGestureRecognizer *)gestureRecognizer {
    //CGPoint point = [panGestureRecognizer locationInView:self.view];
    CGPoint velocity = [gestureRecognizer velocityInView:self.view];
    //NSLog(@"velocity Y = %f", velocity.y);
    
    CGPoint translation;
    
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan){
        
    }else if([gestureRecognizer state] == UIGestureRecognizerStateChanged ){
        //CGPoint current = [gestureRecognizer locationInView:self.view];
        
        translation = [gestureRecognizer translationInView:[self.sectionView superview]];
        NSLog(@"translation y = %f", translation.y );
        float pointY = 0.0;
        if(velocity.y < 0){
            pointY =  (self.sectionView.center.y + translation.y * fabsf(1/velocity.y));
            if(pointY < 230) pointY = 230;
        }else{
            pointY = self.sectionView.center.y + translation.y;
        }
        
        [self.sectionView setCenter:CGPointMake(self.sectionView.center.x, pointY)];
    
        
    }else if([gestureRecognizer state] == UIGestureRecognizerStateEnded ){
      
        if( velocity.y > 400 || (velocity.y > 0 && self.sectionView.center.y > self.sectionView.frame.size.height + 100)){
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.sectionView setCenter:CGPointMake(self.sectionView.center.x , 810)];
            } completion:nil];
        }else if(velocity.y <= 400){
            if(velocity.y < 0 ){
                [UIView animateWithDuration: 0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.sectionView setCenter:CGPointMake(self.sectionView.center.x , self.view.frame.size.height / 2)];
                } completion:nil];
            }
        }
        
    }
    

}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    //NSLog(@"target = %@", recognizer.view );
   
    [self.sectionView removeGestureRecognizer:self.panGesture];
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
        
        // NSLog(@"original: %f", [recognizer.view superview].frame.origin.x);
        [recognizer.view superview].transform = CGAffineTransformMakeScale(self.view.frame.size.width/recognizer.view.frame.size.width, self.view.frame.size.width/recognizer.view.frame.size.width);
        
        [recognizer.view superview].layer.position = CGPointMake(358.41954, self.view.frame.size.height/2);
        
       // NSLog(@"After scale: %f", [recognizer.view superview].frame.origin.x);
        
        [self.articlesView setContentOffset:CGPointMake(recognizer.view.frame.origin.x , 0)];
        
        [self.articlesView setContentSize:CGSizeMake(self.articlesView.frame.size.width+184, self.articlesView.frame.size.height)];
        
        self.articlesView.clipsToBounds = YES;
        
        
    } completion:^(BOOL finished) {
        
    }];
}

@end
