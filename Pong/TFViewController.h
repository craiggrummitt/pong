#import <UIKit/UIKit.h>


@class TFBall;
@class TFPaddle;
@class TFModel;

@interface TFViewController : UIViewController<UICollisionBehaviorDelegate>
@property (weak, nonatomic) IBOutlet UILabel *score1Label;
@property (weak, nonatomic) IBOutlet UILabel *score2Label;
@property (weak, nonatomic) IBOutlet TFPaddle *playerOnePaddle;
@property (weak, nonatomic) IBOutlet TFPaddle *playerTwoPaddle;
@property (strong, nonatomic) IBOutlet TFBall *ball;
@property (weak, nonatomic) IBOutlet UILabel *playerOneInstructions;
@property (weak, nonatomic) IBOutlet UILabel *playerTwoInstructions;
@property (weak, nonatomic) IBOutlet UIView *startInstructions;
@property (weak, nonatomic) IBOutlet UIView *wellDone;

@property (strong, nonatomic) UIPushBehavior *initialBallForce;
@property (strong, nonatomic) UICollisionBehavior *collider;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UITapGestureRecognizer *tapToStartRecognizer;
@property (strong, nonatomic) TFModel *model;
- (void)promptNextBall;
@property (nonatomic) BOOL wellDoneNormalWayUp;
@end
