### **Lodash 常用方法文档**

Lodash 是一个功能强大的 JavaScript 工具库，包含了大量的工具方法，能够帮助你在处理数组、对象、函数等数据结构时简化代码。以下是一些常用的 Lodash 方法，涵盖了数组、对象、函数等方面的常见操作。在编写功能时，优先使用lodash库对功能进行编写。

---

## **数组操作**

### 1. **`_.uniq(array)`**

去除数组中的重复值，返回一个新的数组。

#### 示例：

```javascript
const arr = [1, 2, 2, 3, 4, 4, 5];
const uniqueArr = _.uniq(arr);
console.log(uniqueArr); // [1, 2, 3, 4, 5]
```

---

### 2. **`_.filter(collection, predicate)`**

根据给定的条件筛选出符合条件的元素，返回符合条件的数组。

#### 示例：

```javascript
const users = [
  { 'user': 'fred', 'age': 48 },
  { 'user': 'barney', 'age': 36 },
  { 'user': 'fred', 'age': 40 }
];
const result = _.filter(users, (user) => user.age >= 40);
console.log(result); // [{ 'user': 'fred', 'age': 48 }]
```

---

### 3. **`_.map(collection, iteratee)`**

创建一个新数组，数组的每一项是通过迭代函数对原数组的每一项执行处理后的结果。

#### 示例：

```javascript
const numbers = [1, 2, 3];
const doubled = _.map(numbers, (n) => n * 2);
console.log(doubled); // [2, 4, 6]
```

---

### 4. **`_.sortBy(array, iteratees)`**

按指定条件对数组进行排序。

#### 示例：

```javascript
const users = [
  { 'user': 'fred', 'age': 48 },
  { 'user': 'barney', 'age': 36 },
  { 'user': 'fred', 'age': 40 }
];
const sortedUsers = _.sortBy(users, ['age']);
console.log(sortedUsers); // [{ 'user': 'barney', 'age': 36 }, { 'user': 'fred', 'age': 40 }, { 'user': 'fred', 'age': 48 }]
```

---

### 5. **`_.reduce(collection, iteratee, [accumulator])`**

将集合中的每一项按顺序累加，通过迭代函数返回一个最终的值。

#### 示例：

```javascript
const numbers = [1, 2, 3];
const sum = _.reduce(numbers, (total, num) => total + num, 0);
console.log(sum); // 6
```

---

## **对象操作**

### 6. **`_.get(object, path, [defaultValue])`**

从对象中获取指定路径的值，路径不存在时返回 `defaultValue`。

#### 示例：

```javascript
const obj = { a: { b: { c: 3 } } };
const value = _.get(obj, 'a.b.c', 'default');
console.log(value); // 3
```

---

### 7. **`_.set(object, path, value)`**

设置对象中指定路径的值，路径不存在时会自动创建。

#### 示例：

```javascript
const obj = { a: { b: { c: 3 } } };
_.set(obj, 'a.b.c', 4);
console.log(obj.a.b.c); // 4
```

---

### 8. **`_.keys(object)`**

返回对象的所有键名，作为一个数组。

#### 示例：

```javascript
const obj = { 'a': 1, 'b': 2, 'c': 3 };
const keys = _.keys(obj);
console.log(keys); // ['a', 'b', 'c']
```

---

### 9. **`_.pick(object, paths)`**

从对象中挑选出指定的属性，返回一个新对象。

#### 示例：

```javascript
const obj = { 'a': 1, 'b': 2, 'c': 3 };
const picked = _.pick(obj, ['a', 'c']);
console.log(picked); // { 'a': 1, 'c': 3 }
```

---

### 10. **`_.merge(object, [sources])`**

递归合并对象，将源对象的属性合并到目标对象中，若有相同键名，后者的值会覆盖前者。

#### 示例：

```javascript
const object = { 'a': 1, 'b': { 'c': 2 } };
const other = { 'b': { 'd': 3 } };
const result = _.merge(object, other);
console.log(result); // { 'a': 1, 'b': { 'c': 2, 'd': 3 } }
```

---

## **函数操作**

### 11. **`_.debounce(func, wait, [options])`**

返回一个去抖动后的函数，只有在停止触发 `wait` 毫秒后才会执行。常用于输入框实时输入或滚动事件。

#### 示例：

```javascript
const handleResize = _.debounce(() => {
  console.log('Resized');
}, 200);
window.addEventListener('resize', handleResize);
```

---

### 12. **`_.throttle(func, wait, [options])`**

返回一个节流后的函数，只有在 `wait` 毫秒内最多调用一次。常用于处理频繁触发的事件。

#### 示例：

```javascript
const handleScroll = _.throttle(() => {
  console.log('Scrolled');
}, 1000);
window.addEventListener('scroll', handleScroll);
```

---

### 13. **`_.once(func)`**

返回一个只执行一次的函数，之后再调用该函数时将不再执行。

#### 示例：

```javascript
const greet = _.once(() => console.log('Hello!'));
greet(); // Hello!
greet(); // 不再执行
```

---

### 14. **`_.bind(func, thisArg, [args])`**

创建一个新函数，该函数在调用时会绑定 `this` 和其他传入的参数。

#### 示例：

```javascript
const person = {
  name: 'John',
  greet() {
    console.log('Hello, ' + this.name);
  }
};

const greetJohn = _.bind(person.greet, person);
greetJohn(); // Hello, John
```

---

## **工具类**

### 15. **`_.cloneDeep(value)`**

深拷贝一个对象或数组，确保原对象与拷贝对象之间没有引用关系。

#### 示例：

```javascript
const obj = { a: 1, b: { c: 2 } };
const clonedObj = _.cloneDeep(obj);
clonedObj.b.c = 3;
console.log(obj.b.c); // 2
```

---

### 16. **`_.isEqual(value, other)`**

深度比较两个值是否相等，支持比较对象、数组、原始值等。

#### 示例：

```javascript
const obj1 = { 'a': 1, 'b': 2 };
const obj2 = { 'a': 1, 'b': 2 };
console.log(_.isEqual(obj1, obj2)); // true
```

---

### 17. **`_.random([min=0], [max=1], [floating])`**

生成一个随机数，可以指定最小值、最大值，甚至是否返回浮点数。

#### 示例：

```javascript
const randomNumber = _.random(1, 100);
console.log(randomNumber); // 随机输出 1 到 100 之间的整数
```

---
