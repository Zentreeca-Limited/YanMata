<?php

namespace App\Services;

use App\Mail\TransactionalNotificationMail;
use App\Models\ProductOrder;
use App\Models\SupportRequest;
use App\Models\User;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;

class MemberMailService
{
    public function sendWelcome(User $user): void
    {
        $this->deliver(
            $user->email,
            new TransactionalNotificationMail(
                subjectLine: 'Welcome to YanMata — Your Private Health Companion',
                heading: 'Welcome to YanMata, '.$user->name,
                badge: 'Onboarding Complete',
                paragraphs: [
                    'Your private YanMata account is ready. Whether you are exploring health education across every stage of womanhood, tracking your cycle privately on your device, or reaching out to an in-platform specialist, your space belongs to you.',
                    'By default, your personal journal entries stay on your phone unless you explicitly enable encrypted cloud backup in your profile settings.',
                ],
                highlights: [
                    'Account Email' => $user->email,
                    'Privacy Mode' => 'Local-first device storage active',
                    'Next Step' => 'Complete your health profile in the YanMata app for tailored educational insights',
                ],
                ctaLabel: 'Explore YanMata',
                ctaUrl: config('app.url', 'https://yanmata.zentreeca.org'),
            ),
            'welcome_member'
        );
    }

    public function sendProfileCompleted(User $user): void
    {
        $this->deliver(
            $user->email,
            new TransactionalNotificationMail(
                subjectLine: 'YanMata — Your Personalised Health Space Is Ready',
                heading: 'Your health profile is set up, '.$user->name,
                badge: 'Profile Ready',
                paragraphs: [
                    'Thank you for completing your YanMata onboarding profile. We have prepared age-appropriate educational guidance and preventive screening reminders tailored to your life stage.',
                    'For your privacy, none of your health answers are included in this email. Open the YanMata mobile app at any time to review or update your profile.',
                ],
                highlights: [
                    'Status' => 'Personalised insights unlocked',
                    'Privacy' => 'Zero clinical details included in email notifications',
                ],
                ctaLabel: 'Open YanMata Web',
                ctaUrl: config('app.url', 'https://yanmata.zentreeca.org'),
            ),
            'profile_completed'
        );
    }

    public function sendCareRequestCreated(User $user, SupportRequest $request): void
    {
        $statusLabel = $request->status === 'assigned'
            ? 'Assigned to an in-platform specialist'
            : 'Queued for the next available verified specialist';

        $this->deliver(
            $user->email,
            new TransactionalNotificationMail(
                subjectLine: 'YanMata Care — We Received Your Specialist Support Request',
                heading: 'Your private care request has been received',
                badge: 'YanMata Care',
                paragraphs: [
                    'Hello '.$user->name.', your request for specialist guidance inside YanMata has been logged safely.',
                    'To protect your confidentiality, the topic and details of your question are never shown in email notifications. You will receive a discreet notification as soon as a verified specialist responds inside your private YanMata Care inbox.',
                ],
                highlights: [
                    'Request Reference' => substr((string) $request->id, 0, 8),
                    'Routing Status' => $statusLabel,
                ],
                ctaLabel: 'Visit YanMata',
                ctaUrl: config('app.url', 'https://yanmata.zentreeca.org'),
            ),
            'care_request_created'
        );
    }

    public function sendCareSpecialistAssigned(User $user, SupportRequest $request, string $specialistName): void
    {
        $this->deliver(
            $user->email,
            new TransactionalNotificationMail(
                subjectLine: 'YanMata Care — A Specialist Is Connected to Your Request',
                heading: 'A verified specialist has joined your care thread',
                badge: 'Specialist Assigned',
                paragraphs: [
                    'Hello '.$user->name.', '.$specialistName.' has been connected to your support request inside YanMata.',
                    'Open the Care tab in your YanMata mobile app to view updates and continue your private conversation.',
                ],
                highlights: [
                    'Request Reference' => substr((string) $request->id, 0, 8),
                    'Specialist' => $specialistName,
                ],
                ctaLabel: 'Open YanMata',
                ctaUrl: config('app.url', 'https://yanmata.zentreeca.org'),
            ),
            'care_specialist_assigned'
        );
    }

    public function sendCareUpdateNotification(User $recipient, string $conversationId): void
    {
        $this->deliver(
            $recipient->email,
            new TransactionalNotificationMail(
                subjectLine: 'YanMata — You Have a New Update in Your Private Space',
                heading: 'A new message is waiting for you in YanMata',
                badge: 'Discreet Care Alert',
                paragraphs: [
                    'Hello '.$recipient->name.', there is a new reply in your private YanMata Care conversation.',
                    'To keep your personal health information strictly confidential, message contents are never sent over email. Please sign in to the YanMata app to read and reply.',
                ],
                highlights: [
                    'Conversation Reference' => substr($conversationId, 0, 8),
                    'Security' => 'End-to-end discreet notification (no message body in email)',
                ],
                ctaLabel: 'Open YanMata',
                ctaUrl: config('app.url', 'https://yanmata.zentreeca.org'),
            ),
            'care_message_update'
        );
    }

    public function sendOrderConfirmation(User $user, ProductOrder $order): void
    {
        $itemCount = is_array($order->items) ? count($order->items) : 1;

        $this->deliver(
            $user->email,
            new TransactionalNotificationMail(
                subjectLine: 'YanMata — Your Essential Order Is Confirmed',
                heading: 'We have confirmed your order, '.$user->name,
                badge: 'Order Confirmed',
                paragraphs: [
                    'Your order through YanMata has been confirmed and routed for discreet fulfilment.',
                    'For your privacy, individual product names are omitted from this email summary. You can view your full order details inside the YanMata app.',
                ],
                highlights: [
                    'Order Reference' => strtoupper(substr((string) $order->id, 0, 8)),
                    'Items' => $itemCount.' item(s)',
                    'Total' => 'NGN '.number_format((int) $order->total_ngn),
                    'Status' => ucfirst((string) $order->status),
                ],
                ctaLabel: 'Open YanMata',
                ctaUrl: config('app.url', 'https://yanmata.zentreeca.org'),
            ),
            'order_confirmed'
        );
    }

    public function sendAccountDeleted(string $email, string $name): void
    {
        $this->deliver(
            $email,
            new TransactionalNotificationMail(
                subjectLine: 'YanMata — Your Account and Data Have Been Permanently Deleted',
                heading: 'Account deletion confirmed',
                badge: 'Data Erasure Complete',
                paragraphs: [
                    'Hello '.$name.', as requested, your YanMata account, cloud-synced records, and personal profile have been permanently erased from our servers.',
                    'If you ever wish to return in the future, you are always welcome to create a new space.',
                ],
                highlights: [
                    'Account Status' => 'Permanently deleted',
                    'Timestamp' => now()->toIso8601String(),
                ],
            ),
            'account_deleted'
        );
    }

    private function deliver(?string $email, TransactionalNotificationMail $mailable, string $context): void
    {
        if (! $email) {
            return;
        }

        try {
            Mail::to($email)->send($mailable);
        } catch (\Throwable $e) {
            Log::warning('YanMata transactional email delivery failed', [
                'context' => $context,
                'error' => $e->getMessage(),
            ]);
        }
    }
}
