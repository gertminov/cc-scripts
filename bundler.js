import{bundle} from 'luabundle';
import chokidar from "chokidar"
// import node.js filesystem module
import fs from 'fs'; 

console.log("started Bundler");
console.log("watching for changes...");

chokidar.watch('./src').on('all', (event, path) => {
    if(event !== 'change') return

    console.log(event, path);
    console.log("Compiling...");
    const luabundle = bundle(`./src/stripmine.lua`, {
        paths: ['./src/?.lua'],
    })
    fs.writeFile(`./bin/bundle.lua`, luabundle, (err) => {
        if (err) throw err;
        console.log('compilation complete');
    })
})

