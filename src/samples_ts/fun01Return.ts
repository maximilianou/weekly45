() => {
   console.log(`${__dirname}`);
   console.log(`${__filename}`);
}
type ArgType = number
//type ReturnType  
//type FunType = (arg: ArgType) => ReturnType
type FunType = (arg: ArgType) => number 

const one: ArgType = 3

//type FunObjType = {
//  (arg: ArgType): ReturnType 
//}
//
//interface InterfaceWithFn {
//  fun(arg: ArgType): ReturnType
//}
//
//const funImpl =  (arg: ArgType): ReturnType => {
//  return arg
//}
//
//const data: ReturnType = funImple(4);
//console.log(`${data}`);
//
const add: (a:number, b:number) => number = (a, b) => a + b

type FunAdd =  (a: number, b:number ) => number
const addT: FunAdd = ( a, b ) => a + b

type FunAddObj = {
  (a:number, b:number ):number
}
const addObj: FunAddObj = (a, b) => a + b

type MathFun = (a:number, b:number) => number
const math: { sum: MathFun } = { sum: (a, b) => a + b }


