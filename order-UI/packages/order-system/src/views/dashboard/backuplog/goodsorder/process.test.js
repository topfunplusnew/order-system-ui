// const finalResult = result
// 	.map(backlog => {
// 		const ori = _.cloneDeep(backlog.originalInfo);
// 		const chag = _.cloneDeep(backlog.changedInfo);
// 		const originDataType = TypeUtils.prototype.checkType(ori);
// 		const changedDataType = TypeUtils.prototype.checkType(chag);
// 		if (originDataType === 'Array' && changedDataType === 'Array') {
// 			if (ori.length > 0 && chag.length > 0) {
// 				ori.forEach(element => {
// 					if (element) {
// 						extra.push({
// 							...backlog,
// 							tableName: backlog.tableName,
// 							originalInfo: backlog,
// 							changedInfo: null
// 						});
// 						if (element.id) extraIds.push(backlog.id);
// 					}
// 				});
// 				chag.forEach(element => {
// 					if (element) {
// 						extra.push({
// 							...backlog,
// 							tableName: backlog.tableName,
// 							originalInfo: null,
// 							changedInfo: backlog
// 						});
// 						if (element.id) extraIds.push(backlog.id);
// 					}
// 				});
// 			}
// 			return backlog;
// 		} else if (originDataType === 'Array' && changedDataType !== 'Array') {
// 			if (ori.length === 0) return backlog;
// 			ori.forEach(element => {
// 				if (element) {
// 					extra.push({
// 						...backlog,
// 						tableName: backlog.tableName,
// 						originalInfo: backlog,
// 						changedInfo: null
// 					});
// 					if (element.id) extraIds.push(backlog.id);
// 				}
// 			});
// 		} else if (originDataType !== 'Array' && changedDataType === 'Array') {
// 			if (chag.length === 0) return backlog;
// 			chag.forEach(element => {
// 				if (element) {
// 					extra.push({
// 						...backlog,
// 						tableName: backlog.tableName,
// 						originalInfo: null,
// 						changedInfo: backlog
// 					});
// 					if (element.id) extraIds.push(backlog.id);
// 				}
// 			});
// 		} else {
// 			return backlog;
// 		}
// 		return backlog;
// 	})
// 	.filter(backlog => !extraIds.includes(backlog.id));
