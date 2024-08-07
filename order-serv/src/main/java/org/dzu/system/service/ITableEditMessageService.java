package org.dzu.system.service;

import org.dzu.system.domain.TableEditMessage;

import java.util.List;

/**
 * 编辑原因Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface ITableEditMessageService 
{
    /**
     * 查询编辑原因
     * 
     * @param id 编辑原因主键
     * @return 编辑原因
     */
    public TableEditMessage selectTableEditMessageById(Long id);

    /**
     * 查询编辑原因列表
     * 
     * @param tableEditMessage 编辑原因
     * @return 编辑原因集合
     */
    public List<TableEditMessage> selectTableEditMessageList(TableEditMessage tableEditMessage);

    /**
     * 新增编辑原因
     * 
     * @param tableEditMessage 编辑原因
     * @return 结果
     */
    public int insertTableEditMessage(TableEditMessage tableEditMessage);

    /**
     * 修改编辑原因
     * 
     * @param tableEditMessage 编辑原因
     * @return 结果
     */
    public int updateTableEditMessage(TableEditMessage tableEditMessage);

    /**
     * 批量删除编辑原因
     * 
     * @param ids 需要删除的编辑原因主键集合
     * @return 结果
     */
    public int deleteTableEditMessageByIds(Long[] ids);

    /**
     * 删除编辑原因信息
     * 
     * @param id 编辑原因主键
     * @return 结果
     */
    public int deleteTableEditMessageById(Long id);
}
