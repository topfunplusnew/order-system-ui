package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.TableEditMessageMapper;
import org.dzu.system.domain.TableEditMessage;
import org.dzu.system.service.ITableEditMessageService;
/**
 * 编辑原因Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class TableEditMessageServiceImpl implements ITableEditMessageService
{
    @Autowired
    private TableEditMessageMapper tableEditMessageMapper;

    /**
     * 查询编辑原因
     *
     * @param id 编辑原因主键
     * @return 编辑原因
     */
    @Override
    public TableEditMessage selectTableEditMessageById(Long id)
    {
        return tableEditMessageMapper.selectTableEditMessageById(id);
    }

    /**
     * 查询编辑原因列表
     *
     * @param tableEditMessage 编辑原因
     * @return 编辑原因
     */
    @Override
    public List<TableEditMessage> selectTableEditMessageList(TableEditMessage tableEditMessage)
    {
        return tableEditMessageMapper.selectTableEditMessageList(tableEditMessage);
    }

    /**
     * 新增编辑原因
     *
     * @param tableEditMessage 编辑原因
     * @return 结果
     */
    @Override
    public int insertTableEditMessage(TableEditMessage tableEditMessage)
    {
        tableEditMessage.setAddtime(String.valueOf(DateUtils.getNowDate()));
        tableEditMessage.setUserId(SecurityUtils.getUserId());
        tableEditMessage.setUserName(SecurityUtils.getUserTruename());
        return tableEditMessageMapper.insertTableEditMessage(tableEditMessage);
    }

    /**
     * 修改编辑原因
     * 
     * @param tableEditMessage 编辑原因
     * @return 结果
     */
    @Override
    public int updateTableEditMessage(TableEditMessage tableEditMessage)
    {
        tableEditMessage.setUserId(SecurityUtils.getUserId());
        tableEditMessage.setUserName(SecurityUtils.getUserTruename());
        return tableEditMessageMapper.updateTableEditMessage(tableEditMessage);
    }

    /**
     * 批量删除编辑原因
     * 
     * @param ids 需要删除的编辑原因主键
     * @return 结果
     */
    @Override
    public int deleteTableEditMessageByIds(Long[] ids)
    {
        return tableEditMessageMapper.deleteTableEditMessageByIds(ids);
    }

    /**
     * 删除编辑原因信息
     * 
     * @param id 编辑原因主键
     * @return 结果
     */
    @Override
    public int deleteTableEditMessageById(Long id)
    {
        return tableEditMessageMapper.deleteTableEditMessageById(id);
    }
}
