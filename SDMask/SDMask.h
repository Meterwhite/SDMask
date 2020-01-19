#import "SDMaskProtocol.h"
#import "SDMaskInterface.h"
#import "SDMaskController.h"
#import "SDMaskView.h"
#import "SDMaskBindingEvent.h"
#import "SDMaskModel.h"
#import "UIResponder+SDMask.h"
#import "SDMaskNotificationName.h"
#import "SDMaskGuidController.h"

#pragma mark - Notification name for user
/**
 * Dismiss specified or all mask view.
 * object = nil : dismiss all mask view.
 * object = Specified mask view or user view.
*/
#define SDMaskDismissNotification \
SDMaskNotificationName.needDismiss
/**
 * Get event object using nofication.
 * userInfo[@"event"] = SDMaskBindingEvent
*/
#define SDMaskUserInteractionNotification \
SDMaskNotificationName.userInteraction

