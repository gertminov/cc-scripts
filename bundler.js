import{bundle} from 'luabundle';
// import node.js filesystem module
import fs from 'fs'; 

console.log("Hello World")

const luabundle = bundle(`./stripmine.lua`)
fs.writeFileSync(`./budnle.lua`, luabundle)