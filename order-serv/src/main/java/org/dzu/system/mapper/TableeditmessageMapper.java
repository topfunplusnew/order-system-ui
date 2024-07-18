package org.dzu.system.mapper;

import org.dzu.system.domain.Tableeditmessage;

import java.util.List;

/**
 * 信息Mapper接口
 * 
 * @author ml
 * @date 2024-07-18
 */
public interface TableeditmessageMapper 
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
     * 删除信息
     * 
     * @param id 信息主键
     * @return 结果
     */
    public int deleteTableeditmessageById(Long id);

    /**
     * 批量删除信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteTableeditmessageByIds(Long[] ids);
}
