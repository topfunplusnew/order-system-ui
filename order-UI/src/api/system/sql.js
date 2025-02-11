// 查询资金变动详情
import service from './../../utils/request';
export const getFundChangeDetail = params => {
	return service.request({
		url: '/system/backuplog/list',
		method: 'get',
		params
	});
};
