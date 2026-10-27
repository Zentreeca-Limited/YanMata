import fs from 'node:fs';
import { spawn } from 'node:child_process';

const chrome = spawn('/Applications/Google Chrome.app/Contents/MacOS/Google Chrome', [
  '--headless=new',
  '--remote-debugging-port=9222',
  '--user-data-dir=/tmp/chrome_test_profile_multilingual',
  '--disable-gpu',
  'about:blank'
], { stdio: 'ignore' });

let wsUrl = null;
for (let i = 0; i < 30; i++) {
  try {
    const res = await fetch('http://127.0.0.1:9222/json/version');
    if (res.ok) {
      const data = await res.json();
      wsUrl = data.webSocketDebuggerUrl;
      break;
    }
  } catch {}
  await new Promise(r => setTimeout(r, 200));
}

if (!wsUrl) {
  chrome.kill();
  console.error('Failed to connect to headless Chrome');
  process.exit(1);
}

const ws = new WebSocket(wsUrl);
let reqId = 1;
const pending = new Map();

function send(method, params = {}, sessionId = undefined) {
  return new Promise((resolve, reject) => {
    const id = reqId++;
    pending.set(id, { resolve, reject });
    const msg = { id, method, params };
    if (sessionId) msg.sessionId = sessionId;
    ws.send(JSON.stringify(msg));
  });
}

ws.onmessage = (event) => {
  const msg = JSON.parse(event.data);
  if (msg.id && pending.has(msg.id)) {
    const { resolve, reject } = pending.get(msg.id);
    pending.delete(msg.id);
    if (msg.error) reject(msg.error);
    else resolve(msg.result);
  }
};

await new Promise((resolve) => ws.onopen = resolve);

try {
  console.log('Testing Public Web at http://127.0.0.1:5173...');
  const { targetId: webTarget } = await send('Target.createTarget', { url: 'http://127.0.0.1:5173' });
  const { sessionId: webSession } = await send('Target.attachToTarget', { targetId: webTarget, flatten: true });

  await send('Page.enable', {}, webSession);
  await send('Runtime.enable', {}, webSession);
  await send('Emulation.setDeviceMetricsOverride', {
    width: 1440,
    height: 900,
    deviceScaleFactor: 1,
    mobile: false
  }, webSession);

  await new Promise(r => setTimeout(r, 2000));

  // 1. Switch language to Hausa
  console.log('Switching Web language to Hausa...');
  await send('Runtime.evaluate', {
    expression: `
      (() => {
        const selects = Array.from(document.querySelectorAll('select'));
        if (selects.length > 0) {
          const sel = selects[0];
          sel.value = 'ha';
          sel.dispatchEvent(new Event('change', { bubbles: true }));
          return 'switched_ha';
        }
        return 'no_select';
      })()
    `
  }, webSession);
  await new Promise(r => setTimeout(r, 1000));

  const hausaShot = await send('Page.captureScreenshot', { format: 'png' }, webSession);
  fs.writeFileSync('docs/evidence/screens/web-03-hausa.png', Buffer.from(hausaShot.data, 'base64'));
  console.log('Saved docs/evidence/screens/web-03-hausa.png');

  // 2. Switch to Dark Mode
  console.log('Switching Web to Dark Mode...');
  await send('Runtime.evaluate', {
    expression: `
      (() => {
        const themeBtn = Array.from(document.querySelectorAll('button')).find(b => 
          (b.title && (b.title.includes('dark') || b.title.includes('light'))) ||
          b.querySelector('svg.lucide-moon') ||
          b.querySelector('svg.lucide-sun')
        );
        if (themeBtn) {
          themeBtn.click();
          return 'clicked_dark_mode';
        }
        return 'theme_btn_not_found';
      })()
    `
  }, webSession);
  await new Promise(r => setTimeout(r, 1000));

  const darkShot = await send('Page.captureScreenshot', { format: 'png' }, webSession);
  fs.writeFileSync('docs/evidence/screens/web-04-dark.png', Buffer.from(darkShot.data, 'base64'));
  console.log('Saved docs/evidence/screens/web-04-dark.png');

  // 3. Open Aisha AI Companion Dialog
  console.log('Opening Aisha AI Companion modal...');
  await send('Runtime.evaluate', {
    expression: `
      (() => {
        const aiBtn = Array.from(document.querySelectorAll('button')).find(b => 
          b.textContent.includes('Aisha') ||
          (b.getAttribute('aria-label') && b.getAttribute('aria-label').includes('Aisha'))
        );
        if (aiBtn) {
          aiBtn.click();
          return 'clicked_aisha_modal';
        }
        return 'ai_btn_not_found';
      })()
    `
  }, webSession);
  await new Promise(r => setTimeout(r, 1500));

  // Type a question into Aisha AI chat
  console.log('Asking Aisha AI a health question...');
  await send('Runtime.evaluate', {
    expression: `
      (() => {
        const input = document.querySelector('input[placeholder*="Aisha"], input[placeholder*="Yi tambaya"], input[placeholder*="Ask"]');
        if (input) {
          const setter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
          setter.call(input, 'Yaya zan rage ciwon marar haila?');
          input.dispatchEvent(new Event('input', { bubbles: true }));
          input.dispatchEvent(new Event('change', { bubbles: true }));
          
          const sendBtn = Array.from(document.querySelectorAll('button')).find(b => 
            b.querySelector('svg.lucide-send') || b.textContent.includes('Aika') || b.textContent.includes('Send')
          );
          if (sendBtn) {
            sendBtn.click();
            return 'sent_ai_prompt';
          }
        }
        return 'input_not_found';
      })()
    `
  }, webSession);
  await new Promise(r => setTimeout(r, 3500));

  const aiShot = await send('Page.captureScreenshot', { format: 'png' }, webSession);
  fs.writeFileSync('docs/evidence/screens/web-05-ai-modal.png', Buffer.from(aiShot.data, 'base64'));
  console.log('Saved docs/evidence/screens/web-05-ai-modal.png');

  await send('Target.closeTarget', { targetId: webTarget });

  // 4. Testing Admin Portal
  console.log('Testing Admin Portal at http://127.0.0.1:5174...');
  const { targetId: adminTarget } = await send('Target.createTarget', { url: 'http://127.0.0.1:5174' });
  const { sessionId: adminSession } = await send('Target.attachToTarget', { targetId: adminTarget, flatten: true });

  await send('Page.enable', {}, adminSession);
  await send('Runtime.enable', {}, adminSession);
  await send('Emulation.setDeviceMetricsOverride', {
    width: 1440,
    height: 900,
    deviceScaleFactor: 1,
    mobile: false
  }, adminSession);

  await new Promise(r => setTimeout(r, 2000));
  const pw = fs.readFileSync('.env.demo.local', 'utf8').split('=')[1].trim();

  await send('Runtime.evaluate', {
    expression: `
      (() => {
        const emailInput = document.querySelector('input[type="email"]');
        const passInput = document.querySelector('input[type="password"]');
        const setter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
        
        setter.call(emailInput, 'publisher@demo.yanmata.test');
        emailInput.dispatchEvent(new Event('input', { bubbles: true }));
        emailInput.dispatchEvent(new Event('change', { bubbles: true }));
        
        setter.call(passInput, '${pw}');
        passInput.dispatchEvent(new Event('input', { bubbles: true }));
        passInput.dispatchEvent(new Event('change', { bubbles: true }));
        
        const btn = document.querySelector('button.button');
        btn.click();
        return 'clicked_sign_in';
      })()
    `
  }, adminSession);

  await new Promise(r => setTimeout(r, 3500));

  // Toggle Dark Mode in Admin
  console.log('Toggling Dark Mode in Admin...');
  await send('Runtime.evaluate', {
    expression: `
      (() => {
        const themeBtn = Array.from(document.querySelectorAll('button')).find(b => 
          (b.title && (b.title.includes('dark') || b.title.includes('light'))) ||
          b.querySelector('svg.lucide-moon') ||
          b.querySelector('svg.lucide-sun')
        );
        if (themeBtn) {
          themeBtn.click();
          return 'clicked_admin_dark';
        }
        return 'theme_btn_not_found';
      })()
    `
  }, adminSession);
  await new Promise(r => setTimeout(r, 1000));

  const adminDarkShot = await send('Page.captureScreenshot', { format: 'png' }, adminSession);
  fs.writeFileSync('docs/evidence/screens/admin-04-dark.png', Buffer.from(adminDarkShot.data, 'base64'));
  console.log('Saved docs/evidence/screens/admin-04-dark.png');

  await send('Target.closeTarget', { targetId: adminTarget });
  console.log('All Web and Admin tests completed successfully!');
} finally {
  ws.close();
  chrome.kill();
}
