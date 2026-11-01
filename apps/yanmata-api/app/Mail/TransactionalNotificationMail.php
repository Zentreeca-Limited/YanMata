<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class TransactionalNotificationMail extends Mailable
{
    use Queueable, SerializesModels;

    /**
     * @param  array<int, string>  $paragraphs
     * @param  array<string, string>  $highlights
     */
    public function __construct(
        public string $subjectLine,
        public string $heading,
        public array $paragraphs,
        public ?string $badge = null,
        public array $highlights = [],
        public ?string $ctaLabel = null,
        public ?string $ctaUrl = null,
        public ?string $signatureName = 'The YanMata Care & Wellbeing Team',
        public ?string $signatureRole = 'Lifelong Women’s Health Companion · Ages 9 through Later Life',
        public ?string $preheader = null,
    ) {}

    public function envelope(): Envelope
    {
        return new Envelope(
            subject: $this->subjectLine,
        );
    }

    public function content(): Content
    {
        return new Content(
            view: 'emails.transactional',
        );
    }
}
