import{bundle} from 'luabundle';
// import node.js filesystem module
import fs from 'fs'; 



const luabundle = bundle(`./src/stripmine.lua`, {
    paths: ['./src/?.lua'],
})
fs.writeFile(`./bin/bundle.lua`, luabundle, (err) => {
    if (err) throw err;
    console.log('compilation complete');
})