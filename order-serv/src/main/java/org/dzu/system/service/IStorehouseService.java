package org.dzu.system.service;

import org.dzu.system.domain.Storehouse;

import java.util.List;

/**
 * 仓库信息Service接口
 * 
 * @author ml
 * @date 2024-07-18
 */
public interface IStorehouseService 
{
    /**
     * 查询仓库信息
     * 
     * @param id 仓库信息主键
     * @return 仓库信息
     */
    public Storehouse selectStorehouseById(Long id);

    /**
     * 查询仓库信息列表
     * 
     * @param storehouse 仓库信息
     * @return 仓库信息集合
     */
    public List<Storehouse> selectStorehouseList(Storehouse storehouse);

    /**
     * 新增仓库信息
     * 
     * @param storehouse 仓库信息
     * @return 结果
     */
    public int insertStorehouse(Storehouse storehouse);

    /**
     * 修改仓库信息
     * 
     * @param storehouse 仓库信息
     * @return 结果
     */
    public int updateStorehouse(Storehouse storehouse);

    /**
     * 批量删除仓库信息
     * 
     * @param ids 需要删除的仓库信息主键集合
     * @return 结果
     */
    public int deleteStorehouseByIds(Long[] ids);

    /**
     * 删除仓库信息信息
     * 
     * @param id 仓库信息主键
     * @return 结果
     */
    public int deleteStorehouseById(Long id);
}
