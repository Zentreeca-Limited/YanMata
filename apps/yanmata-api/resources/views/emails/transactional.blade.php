<!DOCTYPE html>
<html lang="en" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="color-scheme" content="light">
  <meta name="supported-color-schemes" content="light">
  <title>{{ $subjectLine ?? 'YanMata — Healthy Women. Brighter Futures.' }}</title>
</head>
<body style="margin:0;padding:0;background-color:#FDF7FA;font-family:'Manrope',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Helvetica,Arial,sans-serif;color:#261332;line-height:1.65;-webkit-font-smoothing:antialiased;">
  @php
    $appUrl = rtrim((string) config('app.url', 'https://yanmata.zentreeca.org'), '/');
    $logoEmblemUrl = $appUrl.'/logo.png';
    $logoHorizontalUrl = $appUrl.'/logo_horizontal.png';
    $fromEmail = (string) config('mail.from.address', 'yanmata@zentreeca.org');
  @endphp

  <!-- Preheader text (hidden) -->
  <div style="display:none;max-height:0;overflow:hidden;opacity:0;font-size:1px;line-height:1px;color:#FDF7FA;">
    {{ $preheader ?? ($heading . ' — Private, compassionate wellbeing support from YanMata.') }}
  </div>

  <table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0" style="background-color:#FDF7FA;background-image:radial-gradient(circle at top right, #FCE9F3 0%, #FDF7FA 55%, #F6EEF9 100%);padding:36px 14px;">
    <tr>
      <td align="center">
        <!-- Main Card Container -->
        <table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0" style="max-width:580px;background-color:#FFFFFF;border-radius:28px;border:1px solid #F1DFEC;overflow:hidden;box-shadow:0 16px 40px rgba(74,25,88,0.08);">

          <!-- Top Decorative Floral Ribbon -->
          <tr>
            <td style="height:6px;background:linear-gradient(90deg,#3B1C54 0%,#8B267E 50%,#EC5A96 100%);font-size:0;line-height:0;">&nbsp;</td>
          </tr>

          <!-- Cute Header with YanMata Logo Emblem -->
          <tr>
            <td align="center" style="background:linear-gradient(180deg,#FFF6FA 0%,#FFFFFF 100%);padding:32px 32px 20px 32px;border-bottom:1px dashed #F3E3EE;">
              <a href="{{ $appUrl }}" style="text-decoration:none;display:inline-block;">
                <div style="width:76px;height:76px;margin:0 auto 12px auto;border-radius:999px;background-color:#FDF0F6;border:2px solid #F7D4E6;padding:8px;box-sizing:border-box;box-shadow:0 6px 18px rgba(139,38,126,0.10);">
                  <img src="{{ $logoEmblemUrl }}" alt="YanMata Logo" width="56" height="56" style="display:block;width:56px;height:56px;margin:0 auto;border:0;outline:none;object-fit:contain;">
                </div>
                <div style="font-family:Georgia,'Times New Roman',serif;font-size:27px;font-weight:700;color:#3B1C54;letter-spacing:-0.02em;line-height:1.15;">
                  YanMata
                </div>
                <div style="font-size:12px;font-weight:600;color:#B03A84;letter-spacing:0.06em;text-transform:uppercase;margin-top:4px;">
                  Healthy Women &bull; Brighter Futures
                </div>
              </a>
            </td>
          </tr>

          <!-- Main Body Content -->
          <tr>
            <td style="padding:32px 36px 24px 36px;">
              @if(!empty($badge))
                <div style="margin-bottom:16px;">
                  <span style="display:inline-block;background-color:#FCEEF6;border:1px solid #F5D0E6;color:#8B267E;font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:0.09em;padding:6px 14px;border-radius:999px;">
                    &#10024; {{ $badge }}
                  </span>
                </div>
              @endif

              <h1 style="margin:0 0 18px 0;font-family:Georgia,'Times New Roman',serif;font-size:24px;line-height:1.32;color:#261332;font-weight:700;">
                {{ $heading }}
              </h1>

              @foreach($paragraphs as $paragraph)
                <p style="margin:0 0 16px 0;font-size:15px;line-height:1.7;color:#4B3657;">
                  {{ $paragraph }}
                </p>
              @endforeach

              @if(!empty($highlights))
                <table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0" style="background-color:#FDF7FB;border:1px solid #F2DFEC;border-left:4px solid #A83384;border-radius:16px;margin:22px 0;">
                  <tr>
                    <td style="padding:18px 22px;">
                      <div style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;color:#8B267E;margin-bottom:10px;">
                        Summary Details
                      </div>
                      @foreach($highlights as $label => $value)
                        <div style="font-size:14px;color:#2E1A3B;margin-bottom:6px;line-height:1.5;">
                          <strong style="color:#4A1942;">{{ $label }}:</strong> {{ $value }}
                        </div>
                      @endforeach
                    </td>
                  </tr>
                </table>
              @endif

              @if(!empty($ctaLabel) && !empty($ctaUrl))
                <table role="presentation" cellspacing="0" cellpadding="0" border="0" style="margin:28px 0 24px 0;">
                  <tr>
                    <td align="center" style="border-radius:999px;background:linear-gradient(135deg,#4A1942 0%,#8B267E 55%,#D83F87 100%);box-shadow:0 8px 20px rgba(139,38,126,0.24);">
                      <a href="{{ $ctaUrl }}" style="display:inline-block;color:#FFFFFF;text-decoration:none;font-weight:700;font-size:14px;letter-spacing:0.02em;padding:14px 30px;border-radius:999px;">
                        {{ $ctaLabel }} &rarr;
                      </a>
                    </td>
                  </tr>
                </table>
              @endif

              <!-- Warm Signature Block -->
              <table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0" style="margin-top:26px;padding-top:22px;border-top:1px solid #F3E5EF;">
                <tr>
                  <td width="54" valign="top" style="padding-right:14px;">
                    <div style="width:48px;height:48px;border-radius:14px;background-color:#FDF0F6;border:1px solid #F5D0E6;padding:6px;box-sizing:border-box;">
                      <img src="{{ $logoEmblemUrl }}" alt="YanMata Emblem" width="34" height="34" style="display:block;width:34px;height:34px;margin:0 auto;border:0;object-fit:contain;">
                    </div>
                  </td>
                  <td valign="top">
                    <div style="font-family:Georgia,'Times New Roman',serif;font-style:italic;font-size:15px;color:#6E2568;margin-bottom:2px;">
                      With warmth, care &amp; dignity,
                    </div>
                    <div style="font-size:15px;font-weight:800;color:#261332;">
                      {{ $signatureName ?? 'The YanMata Care & Wellbeing Team' }}
                    </div>
                    <div style="font-size:12.5px;color:#7A6485;margin-top:2px;">
                      {{ $signatureRole ?? 'Lifelong Women’s Health Companion · Ages 9 through Later Life' }}
                    </div>
                    <div style="font-size:12px;margin-top:6px;">
                      <a href="mailto:{{ $fromEmail }}" style="color:#8B267E;text-decoration:none;font-weight:600;">{{ $fromEmail }}</a>
                      <span style="color:#D0BDD8;margin:0 6px;">&bull;</span>
                      <a href="{{ $appUrl }}" style="color:#8B267E;text-decoration:none;font-weight:600;">yanmata.zentreeca.org</a>
                    </div>
                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- Privacy & Safeguarding Assurance Banner -->
          <tr>
            <td style="padding:0 36px 24px 36px;">
              <table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0" style="background-color:#F8F2F9;border-radius:16px;border:1px solid #ECE0F0;">
                <tr>
                  <td style="padding:14px 18px;font-size:12px;line-height:1.55;color:#5E496B;">
                    <strong style="color:#3B1C54;">&#128274; Discreet &amp; Private by Design:</strong> To protect your confidentiality and dignity, YanMata never includes personal cycle logs, symptom notes, or private specialist chat messages inside email notifications.
                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- Cute Footer with Horizontal Brand Lockup -->
          <tr>
            <td align="center" style="background-color:#FBF3F8;padding:24px 32px;border-top:1px solid #F1DFEC;">
              <img src="{{ $logoHorizontalUrl }}" alt="YanMata — Healthy Women. Brighter Futures." width="150" style="display:block;width:150px;max-width:150px;height:auto;margin:0 auto 10px auto;border:0;">
              <p style="margin:0 0 6px 0;font-size:12px;color:#6E587A;font-weight:600;">
                Empowering girls and women across every chapter of life.
              </p>
              <p style="margin:0;font-size:11px;color:#8D7899;">
                &copy; {{ date('Y') }} YanMata Initiative by Zentreeca. Sent with care from <a href="mailto:{{ $fromEmail }}" style="color:#8B267E;text-decoration:none;">{{ $fromEmail }}</a>.
              </p>
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>
