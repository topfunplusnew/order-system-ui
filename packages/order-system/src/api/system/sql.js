// 查询资金变动详情
import service from './../../utils/request';
export const getFundChangeDetail = data => {
	return service.request({
		url: '/system/backuplog/list',
		method: 'post',
		data: data
	});
};
