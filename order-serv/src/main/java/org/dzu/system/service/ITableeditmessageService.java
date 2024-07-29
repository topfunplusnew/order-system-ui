package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Tableeditmessage;

/**
 * 变动日志信息Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface ITableeditmessageService 
{
    /**
     * 查询变动日志信息
     * 
     * @param id 变动日志信息主键
     * @return 变动日志信息
     */
    public Tableeditmessage selectTableeditmessageById(Long id);

    /**
     * 查询变动日志信息列表
     * 
     * @param tableeditmessage 变动日志信息
     * @return 变动日志信息集合
     */
    public List<Tableeditmessage> selectTableeditmessageList(Tableeditmessage tableeditmessage);

    /**
     * 新增变动日志信息
     * 
     * @param tableeditmessage 变动日志信息
     * @return 结果
     */
    public int insertTableeditmessage(Tableeditmessage tableeditmessage);

    /**
     * 修改变动日志信息
     * 
     * @param tableeditmessage 变动日志信息
     * @return 结果
     */
    public int updateTableeditmessage(Tableeditmessage tableeditmessage);

    /**
     * 批量删除变动日志信息
     * 
     * @param ids 需要删除的变动日志信息主键集合
     * @return 结果
     */
    public int deleteTableeditmessageByIds(Long[] ids);

    /**
     * 删除变动日志信息信息
     * 
     * @param id 变动日志信息主键
     * @return 结果
     */
    public int deleteTableeditmessageById(Long id);
}
