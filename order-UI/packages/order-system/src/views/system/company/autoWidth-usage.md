/**
 * 自适应宽度功能使用说明
 * 
 * 1. 配置说明：
 *    - autoWidth: true  // 开启自适应宽度
 *    - autoWidth: false // 使用固定宽度（默认值）
 *    - minWidth: 120    // 最小宽度（仅在autoWidth为true时生效）
 *    - maxWidth: 300    // 最大宽度（仅在autoWidth为true时生效）
 * 
 * 2. 工作原理：
 *    - 当 autoWidth 为 true 时，删除 width 属性，使用 minWidth 和 maxWidth
 *    - Element UI 会根据内容自动调整列宽
 *    - 列宽会在 minWidth 和 maxWidth 之间动态调整
 * 
 * 3. 性能考虑：
 *    - 自适应宽度会轻微影响首屏渲染性能
 *    - 建议只对内容长度变化较大的列开启自适应
 *    - 固定宽度列（如ID、操作列）建议保持 autoWidth: false
 * 
 * 4. 最佳实践：
 *    - 短内容列（ID、状态）：使用固定宽度
 *    - 中等内容列（姓名、电话）：可开启自适应，设置合理的min/max
 *    - 长内容列（地址、备注）：推荐开启自适应，设置较大的max值
 * 
 * 5. 示例配置：
 */

// 固定宽度列（推荐用于ID等短内容）
const fixedWidthColumn = {
    prop: 'id',
    label: 'ID',
    width: 80,
    autoWidth: false, // 固定宽度
    align: 'center'
};

// 自适应宽度列（推荐用于姓名等中等内容）
const autoWidthColumn = {
    prop: 'companyName',
    label: '客户名称',
    autoWidth: true, // 开启自适应
    minWidth: 120,   // 最小宽度
    maxWidth: 300,   // 最大宽度
    align: 'center'
};

// 长内容自适应列（推荐用于地址、备注等）
const longContentColumn = {
    prop: 'address',
    label: '地址',
    autoWidth: true, // 开启自适应
    minWidth: 150,   // 最小宽度
    maxWidth: 400,   // 最大宽度（较大值）
    align: 'center',
    showOverflowTooltip: true // 内容过长时显示tooltip
};

export { fixedWidthColumn, autoWidthColumn, longContentColumn };
