#import "TFViewController.h"
#import "TFBall.h"
#import "TFPaddle.h"
#import "TFModel.h"

static NSString *TFViewControllerBoundaryIdentifierTop = @"top";
static NSString *TFViewControllerBoundaryIdentifierBottom = @"bottom";
static NSUInteger TFScoreWin = 4;


@implementation TFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.model = [[TFModel alloc] init];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    // Rotate the first player's instructions and score
    self.playerOneInstructions.transform = CGAffineTransformMakeRotation(M_PI);
    self.score1Label.transform = CGAffineTransformMakeRotation(M_PI);
    self.score1Label.center = self.view.center;
    self.score2Label.center = self.view.center;
    // Set up collision detection
    self.collider = [[UICollisionBehavior alloc] initWithItems:@[self.ball, self.playerOnePaddle, self.playerTwoPaddle]];
    self.collider.collisionMode = UICollisionBehaviorModeEverything;
    self.collider.translatesReferenceBoundsIntoBoundary = YES;
    self.collider.collisionDelegate = self;
    [self.collider addBoundaryWithIdentifier:TFViewControllerBoundaryIdentifierTop
                              fromPoint:CGPointZero
                                toPoint:CGPointMake(CGRectGetMaxX(self.view.frame),0 )];
    [self.collider addBoundaryWithIdentifier:TFViewControllerBoundaryIdentifierBottom
                              fromPoint:CGPointMake(0, CGRectGetMaxY(self.view.frame))
                                toPoint:CGPointMake(CGRectGetMaxX(self.view.frame), CGRectGetMaxY(self.view.frame))];
    [self.animator addBehavior:self.collider];


    // Add each object's movement behavior
    [self.animator addBehavior:self.ball.dynamicBehavior];
    [self.animator addBehavior:self.playerOnePaddle.dynamicBehavior];
    [self.animator addBehavior:self.playerTwoPaddle.dynamicBehavior];


    // Register event handlers for moving the paddles
    for (TFPaddle *paddle in @[self.playerOnePaddle, self.playerTwoPaddle]) {
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didMovePaddle:)];
        [paddle addGestureRecognizer:panGesture];
    }

    // When enabled, this tap recognizer will handle tapping the screen to
    // start the ball moving again
    self.tapToStartRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startGame)];
    [self.view addGestureRecognizer:self.tapToStartRecognizer];
    self.tapToStartRecognizer.enabled = NO;
    self.wellDone.hidden = YES;
    self.wellDoneNormalWayUp = YES;
    // Show the 'tap to start' prompt
    [self promptNextBall];
}

// This is responsible for moving the ball back to the center,
// and telling players to tap for a new game
- (void)promptNextBall {

    self.ball.paused = YES;
    self.ball.center = self.view.center;
    [self.animator updateItemUsingCurrentState:self.ball];

    self.tapToStartRecognizer.enabled = YES;
}
#pragma mark - UICollisionDelegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {

    // Only end the current game if the ball hit either the top or bottom screen edge
    if ([@[TFViewControllerBoundaryIdentifierBottom,TFViewControllerBoundaryIdentifierTop] containsObject:identifier]) {
            if ([@[TFViewControllerBoundaryIdentifierBottom] containsObject:identifier]) {
                self.model.score1++;
            } else {
                self.model.score2++;
            }
        self.score1Label.text = [NSString stringWithFormat:@" %lu - %lu",(unsigned long)self.model.score1,(unsigned long)self.model.score2];
        self.score2Label.text = [NSString stringWithFormat:@" %lu - %lu",(unsigned long)self.model.score1,(unsigned long)self.model.score2];
        if (self.model.score1==TFScoreWin || self.model.score2==TFScoreWin) {
            self.wellDone.hidden = NO;
            if (self.wellDoneNormalWayUp && self.model.score1==TFScoreWin) {
                self.wellDone.transform = CGAffineTransformMakeRotation(M_PI);
                self.wellDoneNormalWayUp=NO;
            } else if (!self.wellDoneNormalWayUp && self.model.score2==TFScoreWin) {
                self.wellDoneNormalWayUp=YES;
                self.wellDone.transform = CGAffineTransformMakeRotation(M_PI);
            }
            self.wellDone.center = self.view.center;
            [self.model resetScores];
        } else {
            self.startInstructions.hidden = NO;
        }
        [self promptNextBall];
    }
}

#pragma mark - Event handlers
- (void)startGame {
    self.tapToStartRecognizer.enabled = NO;
    self.startInstructions.hidden = YES;
    self.wellDone.hidden = YES;

    self.ball.paused = NO;

    // Give the ball a gentle push to get started in a random direction
    UIPushBehavior *initialBallForce = [[UIPushBehavior alloc] initWithItems:@[self.ball]
                                                             mode:UIPushBehaviorModeInstantaneous];

    // Set the direction to randomly go up or down at a pseudo-random angle.
    CGFloat vectorX = arc4random_uniform(3)/10.f; // One of [0, 0.1, 0.2, or 0.2]
    CGFloat vectorY = (arc4random_uniform(2) == 1 ? 0.2 : -0.2); // 0.2 or -0.2
    initialBallForce.pushDirection = CGVectorMake(vectorX,
                                                  vectorY);
    initialBallForce.active = YES;
    [self.animator addBehavior:initialBallForce];
}

- (void)didMovePaddle:(UIPanGestureRecognizer *)gestureRecognizer {
    // This event handler gets called every time either paddle is moved.
    // However, since there are two different gesture recognizers, we can make
    // sure we're always moving the right paddle by only adjusting the view that
    // is attached to that specific gesture recognizer.
    TFPaddle *paddle = (TFPaddle *)gestureRecognizer.view;
    CGPoint point = [gestureRecognizer locationInView:self.view];
    CGRect frame = paddle.frame;

    // Only move the paddle if its new position wouldn't be part-way off-screen
    if (point.x > CGRectGetWidth(frame)/2 &&
        point.x < CGRectGetWidth(self.view.frame) - CGRectGetWidth(frame)/2) {

        paddle.center = CGPointMake(point.x, paddle.center.y);

        // Since the paddles are controlled by UIKit Dynamics, this is necessary
        // to get UIKit Dynamics to accept that they were moved by something
        // other than itself.
        [self.animator updateItemUsingCurrentState:paddle];
    }

}



@end
