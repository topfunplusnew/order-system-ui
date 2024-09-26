import {create} from 'jsondiffpatch'
import {format} from "jsondiffpatch/formatters/html";

console.log(format)

const disPatcher = create()
console.log(disPatcher)
const obj1 = {name: 'Alice', age: 30};
const obj2 = {name: 'Bob', age: 35};


const diff = disPatcher.diff(obj1, obj2)

const patchedObj = disPatcher.patch(obj1, diff);

const html = format(diff, obj1);
console.log(html)
