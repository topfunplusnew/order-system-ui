package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Storehouse;

/**
 * 仓库管理Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IStorehouseService 
{
    /**
     * 查询仓库管理
     * 
     * @param id 仓库管理主键
     * @return 仓库管理
     */
    public Storehouse selectStorehouseById(Long id);

    /**
     * 查询仓库管理列表
     * 
     * @param storehouse 仓库管理
     * @return 仓库管理集合
     */
    public List<Storehouse> selectStorehouseList(Storehouse storehouse);

    /**
     * 新增仓库管理
     * 
     * @param storehouse 仓库管理
     * @return 结果
     */
    public int insertStorehouse(Storehouse storehouse);

    /**
     * 修改仓库管理
     * 
     * @param storehouse 仓库管理
     * @return 结果
     */
    public int updateStorehouse(Storehouse storehouse);

    /**
     * 批量删除仓库管理
     * 
     * @param ids 需要删除的仓库管理主键集合
     * @return 结果
     */
    public int deleteStorehouseByIds(Long[] ids);

    /**
     * 删除仓库管理信息
     * 
     * @param id 仓库管理主键
     * @return 结果
     */
    public int deleteStorehouseById(Long id);
}
