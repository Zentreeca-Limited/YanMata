import {spawn} from 'node:child_process';
import {fileURLToPath} from 'node:url';
import {createServer} from 'node:net';
const root=fileURLToPath(new URL('../',import.meta.url));
for(const port of [8091,5173,5174]){
 await new Promise((resolve,reject)=>{const s=createServer();s.once('error',()=>reject(new Error(`Port ${port} is occupied. Stop the existing YanMata preview or choose explicit ports.`)));s.listen(port,'127.0.0.1',()=>s.close(resolve));});
}
const children=[spawn('php',['artisan','serve','--host=127.0.0.1','--port=8091'],{cwd:root+'apps/api',stdio:'inherit'}),spawn('npm',['run','dev:web'],{cwd:root,stdio:'inherit'}),spawn('npm',['run','dev:admin'],{cwd:root,stdio:'inherit'})];
let ending=false;function stop(code=0){if(ending)return;ending=true;for(const child of children)child.kill('SIGTERM');process.exitCode=code;}
process.on('SIGINT',()=>stop());process.on('SIGTERM',()=>stop());for(const child of children){child.on('error',e=>{console.error(e.message);stop(1);});child.on('exit',code=>{if(!ending)stop(code??1);});}
