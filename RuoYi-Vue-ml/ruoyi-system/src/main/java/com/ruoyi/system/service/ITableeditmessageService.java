package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.Tableeditmessage;

/**
 * 信息Service接口
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public interface ITableeditmessageService 
{
    /**
     * 查询信息
     * 
     * @param id 信息主键
     * @return 信息
     */
    public Tableeditmessage selectTableeditmessageById(Long id);

    /**
     * 查询信息列表
     * 
     * @param tableeditmessage 信息
     * @return 信息集合
     */
    public List<Tableeditmessage> selectTableeditmessageList(Tableeditmessage tableeditmessage);

    /**
     * 新增信息
     * 
     * @param tableeditmessage 信息
     * @return 结果
     */
    public int insertTableeditmessage(Tableeditmessage tableeditmessage);

    /**
     * 修改信息
     * 
     * @param tableeditmessage 信息
     * @return 结果
     */
    public int updateTableeditmessage(Tableeditmessage tableeditmessage);

    /**
     * 批量删除信息
     * 
     * @param ids 需要删除的信息主键集合
     * @return 结果
     */
    public int deleteTableeditmessageByIds(Long[] ids);

    /**
     * 删除信息信息
     * 
     * @param id 信息主键
     * @return 结果
     */
    public int deleteTableeditmessageById(Long id);
}
