## 项目技术栈、优化方式、组件使用

#### 技术栈 Vue2 , webpack

```bash
vue-ui || vue-cli
```

#### 缓存 webpack 编译结果

```bash
npm install hard-source-webpack-plugin --save-dev
```

应用 webpack

```js
const HardSourceWebpackPlugin = require('hard-source-webpack-plugin');

module.exports = {
	configureWebpack: {
		plugins: [new HardSourceWebpackPlugin()]
	}
};
```

#### yarn 下载 及 操作 monorepo 项目 https://juejin.cn/post/7081440800143310884

yarn add -dev <package-name> [--ignore-engines]

Yarn 下载包的流程大致可以分为以下几个步骤：

1. 读取配置文件
   Yarn 会首先读取项目中的 package.json 和 yarn.lock 文件。package.json 中记录了项目的依赖信息，而 yarn.lock 文件则锁定了依赖版本，确保每次安装的包版本一致。

2. 解析依赖
   Yarn 会根据 package.json 中的 dependencies、devDependencies、peerDependencies 等字段，解析并确定需要安装的依赖包列表。然后，它会检查 yarn.lock 文件中是否已经列出了这些依赖及其版本。如果存在，它会直接使用锁定的版本；如果没有，它会从注册表中查找相应的包。

3. 检查缓存
   Yarn 会检查缓存目录（yarn cache）中是否已经存在所需的包版本。Yarn 会使用这个缓存来加速安装过程，避免重新下载相同的包。如果缓存中没有，则会从远程注册表（如 npm 仓库）下载。

4. 下载包
   如果所需的依赖包不在本地缓存中，Yarn 会从远程注册表（如 npm 仓库）下载它们。下载过程中，Yarn 会根据 package.json 和 yarn.lock 中的信息，解析并安装对应版本的依赖。

5. 生成 node_modules 结构
   一旦依赖包被下载到本地，Yarn 会将它们解压并按照需要的结构放入 node_modules 目录中。在这个过程中，Yarn 会确保所有的依赖都被正确安装，并且解决依赖之间的关系（例如，处理不同版本的同一依赖）。

6. 执行 postinstall 脚本
   安装完成后，Yarn 会运行 postinstall 脚本（如果存在）。这个阶段可以用于执行额外的操作，如构建、编译等。

7. 更新 yarn.lock
   如果安装过程中有新的依赖被添加或版本发生了变化，Yarn 会更新 yarn.lock 文件，以确保后续的安装能够使用相同的版本。

8. 安装完成
   安装完成后，所有依赖包都已经下载并放置到 node_modules 目录中，项目可以开始正常运行。

总结：
解析依赖：读取 package.json 和 yarn.lock，确定需要安装的包。
检查缓存：看所需的包是否已经在缓存中。
下载包：如果缓存中没有，去远程注册表下载。
构建 node_modules：将下载的包解压并组织成 node_modules 结构。
执行 postinstall 脚本：如果有，执行安装后的脚本。
更新 yarn.lock：确保锁文件是最新的。
这种流程确保了安装的依赖版本的一致性和安装效率，同时利用缓存避免重复下载

#### postinstall 脚本

postinstall 脚本是在安装依赖包之后自动执行的一个脚本，它是一个生命周期钩子，可以用于在依赖包安装完成后执行一些额外的操作。

主要用途：
postinstall 脚本常用于执行一些项目初始化、构建或配置的任务，以下是一些常见的用途：

编译代码： 有些依赖包可能需要在安装后进行编译或构建。例如，使用 TypeScript 的项目可能需要在安装完成后运行 tsc 编译 TypeScript 代码。

生成配置文件： 有些项目可能需要根据当前的环境或某些条件，动态生成配置文件。例如，使用 webpack 或其他构建工具时，可以通过 postinstall 来生成一个配置文件。

运行额外的工具： 安装完成后，可以运行一些工具，如 eslint、prettier 来检查或格式化代码。

执行其他初始化操作： 可以用来执行其他任务，如检查环境变量、执行某些数据库操作、下载资源文件等。

如何使用 postinstall 脚本？
你可以在项目的 package.json 文件中的 scripts 部分定义 postinstall 脚本：

json
复制
{
"scripts": {
"postinstall": "echo '安装完成后执行的操作'"
}
}
当依赖包安装完成后，Yarn 或 npm 会自动运行 postinstall 中的命令。你也可以将它与其他脚本或工具结合使用：

json
复制
{
"scripts": {
"postinstall": "npm run build && npm run lint"
}
}
在这个例子中，postinstall 会首先运行 npm run build 来构建项目，然后运行 npm run lint 来执行代码检查。

postinstall 的执行顺序：
在 node_modules 安装完成后，所有的包都已经下载并解压到本地后，postinstall 脚本会被自动执行。
它会在 install 和 prepublish 脚本之后、test 脚本之前执行。
注意事项：
在使用 postinstall 时，确保执行的脚本是无副作用且适合在每次安装时执行的。例如，不要在 postinstall 脚本中执行长时间运行的任务。
如果某些依赖包有 postinstall 脚本（很多现代包会在安装时自动运行某些任务），这些脚本也会被依次执行。
总的来说，postinstall 脚本是一个非常灵活的工具，允许开发者在包安装后执行一系列操作，从而让项目更好地适配和配置。





## 资金变动统计数据处理逻辑

对于renderData分组数据，如果是订单或者库存 ，才会有主子表信息
```js
const obj = {
   body: {
      main_info: {
         // 是否是订单或库存 Object.keys(renderData[index]).length > 0 ? true : false
         isMulti: true,
         // isMulti ? (renderData[index].goodsOrder.length || renderData[index].inventory_main.length) > 0 ? true : false : false
         isAdjust: true,
         data: {
            id: '1',
            backupTime: '2025-05-02',
            logicBackupType: 'insert',
            changedInfo: '{"id": null, "path": null}',
            originalInfo: null,
            uuid: '5c2c6305-10d7-40b0-a0e2-3a02233ef91c'
         },
         items: [
            {
               id: '1',
               backupTime: '2025-05-02',
               logicBackupType: 'insert',
               changedInfo: '{"id": null, "path": null}',
               originalInfo: null,
               uuid: '5c2c6305-10d7-40b0-a0e2-3a02233ef91c'
            },
            {
               id: '2',
               backupTime: '2025-05-02',
               logicBackupType: 'insert',
               changedInfo: '{"id": null, "path": null}',
               originalInfo: null,
               uuid: '5c2c6305-10d7-40b0-a0e2-3a02233ef91c'
            }
         ]
      },
      sub_info: {
         items: [
            {
               orders_no: 'xxsd',
               pieces: '20'
            },
            {
               orders_no: 'xxsd',
               pieces: '20'
            }
         ],
         params: [
            {
               name: 'payment',
               label: '总货款',
               option: () => {}
            },
            {
               name: 'paymentFactory',
               label: '出厂货款',
               option: () => {}
            }
         ]
      },
      extraInfo: {
         _: ''
      }
   }
};

```