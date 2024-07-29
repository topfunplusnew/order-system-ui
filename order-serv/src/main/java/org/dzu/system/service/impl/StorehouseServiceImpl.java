package org.dzu.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.StorehouseMapper;
import org.dzu.system.domain.Storehouse;
import org.dzu.system.service.IStorehouseService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 仓库管理Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class StorehouseServiceImpl implements IStorehouseService
{
    @Autowired
    private StorehouseMapper storehouseMapper;

    /**
     * 查询仓库管理
     *
     * @param id 仓库管理主键
     * @return 仓库管理
     */
    @Override
    public Storehouse selectStorehouseById(Long id)
    {
        return storehouseMapper.selectStorehouseById(id);
    }

    /**
     * 查询仓库管理列表
     *
     * @param storehouse 仓库管理
     * @return 仓库管理
     */
    @Override
    public List<Storehouse> selectStorehouseList(Storehouse storehouse)
    {
        return storehouseMapper.selectStorehouseList(storehouse);
    }

    /**
     * 新增仓库管理
     *
     * @param storehouse 仓库管理
     * @return 结果
     */
    @Override
    public int insertStorehouse(Storehouse storehouse)
    {
        storehouse.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return storehouseMapper.insertStorehouse(storehouse);
    }

    /**
     * 修改仓库管理
     * 
     * @param storehouse 仓库管理
     * @return 结果
     */
    @Override
    public int updateStorehouse(Storehouse storehouse)
    {
        return storehouseMapper.updateStorehouse(storehouse);
    }

    /**
     * 批量删除仓库管理
     * 
     * @param ids 需要删除的仓库管理主键
     * @return 结果
     */
    @Override
    public int deleteStorehouseByIds(Long[] ids)
    {
        return storehouseMapper.deleteStorehouseByIds(ids);
    }

    /**
     * 删除仓库管理信息
     * 
     * @param id 仓库管理主键
     * @return 结果
     */
    @Override
    public int deleteStorehouseById(Long id)
    {
        return storehouseMapper.deleteStorehouseById(id);
    }
}
