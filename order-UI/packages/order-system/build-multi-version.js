// build-multi-version.js
// 多版本打包脚本

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const { analyzeChanges } = require('./deepseek-analyzer');

/**
 * 生成版本目录名
 * 格式：订单系统-年月日-功能需求
 */
function generateVersionDirName(featureDescription) {
	const now = new Date();
	const year = now.getFullYear();
	const month = String(now.getMonth() + 1).padStart(2, '0');
	const day = String(now.getDate()).padStart(2, '0');
	const dateStr = `${year}${month}${day}`;

	// 清理功能描述，移除特殊字符，只保留中文、英文、数字和常见符号
	const cleanFeature = featureDescription
		.replace(/[<>:"/\\|?*]/g, '') // 移除Windows不允许的字符
		.replace(/\s+/g, '-') // 空格替换为短横线
		.trim();

	const dirName = `订单系统-${dateStr}-${cleanFeature}`;
	return dirName;
}

/**
 * 移动dist目录到目标位置
 */
function moveDistToTarget(sourceDist, targetDir) {
	const targetDist = path.join(targetDir, 'dist');

	// 确保目标目录的父目录存在
	if (!fs.existsSync(targetDir)) {
		fs.mkdirSync(targetDir, { recursive: true });
	}

	// 如果目标dist已存在，先删除
	if (fs.existsSync(targetDist)) {
		console.log('⚠️  目标dist目录已存在，正在删除...');
		fs.rmSync(targetDist, { recursive: true, force: true });
	}

	// 移动dist目录
	if (fs.existsSync(sourceDist)) {
		console.log(`📦 正在移动dist到: ${targetDist}`);
		fs.renameSync(sourceDist, targetDist);
		console.log('✅ 移动完成');
	} else {
		throw new Error(`源dist目录不存在: ${sourceDist}`);
	}
}

/**
 * 更新version.json
 */
function updateVersionJson(distPath) {
	const versionJsonPath = path.join(distPath, 'version.json');
	const version = new Date().toISOString();
	const versionData = {
		version,
		buildTime: new Date().toLocaleString('zh-CN'),
		buildPath: distPath
	};

	fs.writeFileSync(versionJsonPath, JSON.stringify(versionData, null, 2), 'utf-8');
	console.log('📦 已更新 version.json');
}

/**
 * 主函数
 */
async function main() {
	// 解析命令行参数
	const args = process.argv.slice(2);
	let featureDescription = '';

	// 检查是否有 --feature 参数
	const featureIndex = args.indexOf('--feature');
	if (featureIndex !== -1 && args[featureIndex + 1]) {
		featureDescription = args[featureIndex + 1];
		console.log('📝 使用命令行提供的功能描述:', featureDescription);
	} else {
		// 如果没有提供，调用AI分析
		console.log('🤖 未提供功能描述，正在调用AI分析git变更...');
		try {
			featureDescription = await analyzeChanges();
		} catch (error) {
			console.error('❌ AI分析失败:', error.message);
			console.log('⚠️  使用默认描述: 常规更新');
			featureDescription = '常规更新';
		}
	}

	// 生成版本目录名
	const versionDirName = generateVersionDirName(featureDescription);
	console.log('📁 版本目录名:', versionDirName);

	// 确定@build目录路径（相对于项目根目录，即order-system-ui目录）
	// __dirname 是 order-system 目录
	// 需要向上3级到达项目根目录
	const projectRoot = path.resolve(__dirname, '../..');
	const buildRoot = path.join(projectRoot, '@build');
	const targetDir = path.join(buildRoot, versionDirName);

	console.log('📂 构建输出目录:', targetDir);

	// 设置环境变量，让vue.config.js知道输出目录
	process.env.BUILD_OUTPUT_DIR = path.join(targetDir, 'dist');

	// 执行构建
	console.log('🚀 开始构建...');
	try {
		// 检查是否有 --mode 参数
		const modeIndex = args.indexOf('--mode');
		const mode = modeIndex !== -1 && args[modeIndex + 1] ? args[modeIndex + 1] : 'production';

		const buildCommand = `vue-cli-service build --mode ${mode}`;
		console.log('执行命令:', buildCommand);
		execSync(buildCommand, {
			stdio: 'inherit',
			cwd: __dirname,
			env: { ...process.env, BUILD_OUTPUT_DIR: process.env.BUILD_OUTPUT_DIR }
		});

		// 构建完成后，dist已经在目标位置（因为vue.config.js会使用BUILD_OUTPUT_DIR）
		const finalDistPath = process.env.BUILD_OUTPUT_DIR;

		// 更新version.json
		updateVersionJson(finalDistPath);

		console.log('\n✅ 构建完成！');
		console.log('📦 构建产物位置:', finalDistPath);
		console.log('📁 版本目录:', targetDir);
	} catch (error) {
		console.error('❌ 构建失败:', error.message);
		process.exit(1);
	}
}

// 运行主函数
if (require.main === module) {
	main().catch(error => {
		console.error('❌ 执行失败:', error);
		process.exit(1);
	});
}

module.exports = { generateVersionDirName, moveDistToTarget };
