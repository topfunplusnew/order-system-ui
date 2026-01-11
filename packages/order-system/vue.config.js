'use strict';
const path = require('path');

function resolve(dir) {
	return path.join(__dirname, dir);
}

const name = process.env.VUE_APP_TITLE || '订单管理系统'; // 网页标题
const port = process.env.port || process.env.npm_config_port || 40080; // 端口

// 支持动态输出目录（用于多版本打包）
const outputDir = process.env.BUILD_OUTPUT_DIR || 'dist';

module.exports = {
	publicPath: process.env.NODE_ENV === 'production' ? '/' : '/',
	outputDir: outputDir,
	assetsDir: 'static',
	lintOnSave: process.env.NODE_ENV === 'development',
	productionSourceMap: false,
	// 转译 monorepo 中的本地包
	transpileDependencies: ['@code-less/platform'],
	// webpack-dev-server 相关配置
	devServer: {
		host: '0.0.0.0',
		port: port,
		open: true,
		proxy: {
			// CodeLess 低代码平台 API -> 本地 NodeJS + MongoDB 服务
			[process.env.VUE_APP_BASE_API + '/codeless']: {
				target: 'http://localhost:3100',
				changeOrigin: true,
				pathRewrite: {
					['^' + process.env.VUE_APP_BASE_API]: ''
				}
			},
			// 其他 API -> 后端服务器
			[process.env.VUE_APP_BASE_API]: {
				target: `http://60.205.5.253:60036/`,
				changeOrigin: true,
				pathRewrite: {
					['^' + process.env.VUE_APP_BASE_API]: ''
				}
			}
		},
		disableHostCheck: true
	},
	css: {
		loaderOptions: {
			sass: {
				sassOptions: { outputStyle: 'expanded' }
			}
		}
	},
	configureWebpack: {
		name: name,
		devtool: 'source-map',
		resolve: {
			alias: {
				'@': resolve('src'),
				// 支持引用共享包
				'@shared': resolve(__dirname, '../shared'),
				'@ui-components': resolve(__dirname, '../ui-components'),
				'@config': resolve(__dirname, '../config'),
				// 低代码平台包
				'@code-less/platform': resolve(__dirname, '../code-less/src')
			}
		},
		plugins: [
			// new CompressionPlugin({
			// 	cache: false, // 不启用文件缓存
			// 	test: /\.(js|css|html|jpe?g|png|gif|svg)?$/i, // 压缩文件格式
			// 	filename: '[path][base].gz[query]', // 压缩后的文件名
			// 	algorithm: 'gzip', // 使用gzip压缩
			// 	minRatio: 0.8, // 压缩比例，小于 80% 的文件不会被压缩
			// 	deleteOriginalAssets: false // 压缩后删除原文件
			// }),
		]
	},
	chainWebpack(config) {
		config.plugins.delete('preload'); // TODO: need test
		config.plugins.delete('prefetch'); // TODO: need test

		// set svg-sprite-loader
		config.module.rule('svg').exclude.add(resolve('src/assets/icons')).end();
		config.module
			.rule('icons')
			.test(/\.svg$/)
			.include.add(resolve('src/assets/icons'))
			.end()
			.use('svg-sprite-loader')
			.loader('svg-sprite-loader')
			.options({
				symbolId: 'icon-[name]'
			})
			.end();

		config.when(process.env.NODE_ENV !== 'development', config => {
			config
				.plugin('ScriptExtHtmlWebpackPlugin')
				.after('html')
				.use('script-ext-html-webpack-plugin', [
					{
						// `runtime` must same as runtimeChunk name. default is `runtime`
						inline: /runtime\..*\.js$/
					}
				])
				.end();

			config.optimization.splitChunks({
				chunks: 'all',
				cacheGroups: {
					libs: {
						name: 'chunk-libs',
						test: /[\\/]node_modules[\\/]/,
						priority: 10,
						chunks: 'initial' // only package third parties that are initially dependent
					},
					elementUI: {
						name: 'chunk-elementUI', // split elementUI into a single package
						test: /[\\/]node_modules[\\/]_?element-ui(.*)/, // in order to adapt to cnpm
						priority: 20 // the weight needs to be larger than libs and app or it will be packaged into libs or app
					},
					commons: {
						name: 'chunk-commons',
						test: resolve('src/components'), // can customize your rules
						minChunks: 3, //  minimum common number
						priority: 5,
						reuseExistingChunk: true
					}
				}
			});
			config.optimization.runtimeChunk('single');
		});
	}
};
