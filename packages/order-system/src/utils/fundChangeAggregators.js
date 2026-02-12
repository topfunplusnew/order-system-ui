/**
 * 资金变动统计模板聚合器
 * 用于摘要区统一计算，支持 sum、absSum、avg 等
 */
import { format, add, abs, divide } from 'mathjs';
import _ from 'lodash';

/**
 * 求和聚合器
 * @param {number[]} values - 差额行该列的值
 * @param {Object} [ctx] - { precision }
 * @returns {string}
 */
export const sumAggregator = (values, ctx = {}) => {
	const precision = ctx.precision ?? 2;
	return _.reduce(values, (acc, v) => format(add(acc, Number(v) || 0), { notation: 'fixed', precision }), 0);
};

/**
 * 绝对值求和聚合器
 * @param {number[]} values
 * @param {Object} [ctx]
 * @returns {string}
 */
export const absSumAggregator = (values, ctx = {}) => {
	const precision = ctx.precision ?? 2;
	return _.reduce(values, (acc, v) => format(add(acc, abs(Number(v) || 0)), { notation: 'fixed', precision }), 0);
};

/**
 * 平均值聚合器
 * @param {number[]} values
 * @param {Object} [ctx]
 * @returns {string}
 */
export const avgAggregator = (values, ctx = {}) => {
	const precision = ctx.precision ?? 2;
	const arr = _.filter(
		_.map(values, v => (_.isNumber(v) ? v : Number(v))),
		v => !_.isNaN(v)
	);
	if (_.isEmpty(arr)) return format(0, { notation: 'fixed', precision });
	const total = _.reduce(arr, (acc, v) => add(acc, v), 0);
	return format(divide(total, arr.length), { notation: 'fixed', precision });
};

/** 聚合器映射，供模板按字符串引用 */
export const AGGREGATOR_MAP = {
	sum: sumAggregator,
	absSum: absSumAggregator,
	avg: avgAggregator,
	max: (values, ctx = {}) => format(_.max(_.map(values, v => Number(v) || 0)) || 0, { notation: 'fixed', precision: ctx.precision ?? 2 }),
	min: (values, ctx = {}) => format(_.min(_.map(values, v => Number(v) || 0)) || 0, { notation: 'fixed', precision: ctx.precision ?? 2 }),
	count: values => String(_.filter(values, v => v != null && v !== '').length),
	none: () => '-'
};
