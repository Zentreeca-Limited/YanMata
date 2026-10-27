import fs from 'node:fs';
import { spawn } from 'node:child_process';

const chrome = spawn('/Applications/Google Chrome.app/Contents/MacOS/Google Chrome', [
  '--headless=new',
  '--remote-debugging-port=9222',
  '--user-data-dir=/tmp/chrome_test_profile3',
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
  const { targetId } = await send('Target.createTarget', { url: 'http://127.0.0.1:5174' });
  const { sessionId } = await send('Target.attachToTarget', { targetId, flatten: true });

  await send('Page.enable', {}, sessionId);
  await send('Runtime.enable', {}, sessionId);
  await send('Emulation.setDeviceMetricsOverride', {
    width: 1440,
    height: 900,
    deviceScaleFactor: 1,
    mobile: false
  }, sessionId);

  // Wait for login form
  await new Promise(r => setTimeout(r, 2000));

  const pw = fs.readFileSync('.env.demo.local', 'utf8').split('=')[1].trim();

  // Use native value setter for React inputs
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
  }, sessionId);

  console.log('Login submitted, waiting for studio layout...');
  await new Promise(r => setTimeout(r, 3500));

  const textRes = await send('Runtime.evaluate', { expression: 'document.body.innerText' }, sessionId);
  console.log('Current page preview:', textRes.result.value.slice(0, 200));

  // Capture editorial studio
  const studioShot = await send('Page.captureScreenshot', { format: 'png' }, sessionId);
  fs.writeFileSync('docs/evidence/screens/admin-02-editorial-studio.png', Buffer.from(studioShot.data, 'base64'));
  console.log('Saved docs/evidence/screens/admin-02-editorial-studio.png');

  // Click Care Inquiries tab
  const careClick = await send('Runtime.evaluate', {
    expression: `
      (() => {
        const btns = Array.from(document.querySelectorAll('.nav-btn'));
        const careBtn = btns.find(b => b.textContent.includes('Care inquiries'));
        if (careBtn) {
          careBtn.click();
          return 'clicked_care';
        }
        return 'care_btn_not_found';
      })()
    `
  }, sessionId);
  console.log('Care tab click result:', careClick.result.value);

  await new Promise(r => setTimeout(r, 2000));

  // Capture care triage
  const careShot = await send('Page.captureScreenshot', { format: 'png' }, sessionId);
  fs.writeFileSync('docs/evidence/screens/admin-03-care-triage.png', Buffer.from(careShot.data, 'base64'));
  console.log('Saved docs/evidence/screens/admin-03-care-triage.png');

  await send('Target.closeTarget', { targetId });
} finally {
  ws.close();
  chrome.kill();
}
