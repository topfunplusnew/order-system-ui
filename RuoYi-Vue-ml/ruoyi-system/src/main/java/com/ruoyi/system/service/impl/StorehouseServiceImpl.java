package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.StorehouseMapper;
import com.ruoyi.system.domain.Storehouse;
import com.ruoyi.system.service.IStorehouseService;

/**
 * 仓库信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@Service
public class StorehouseServiceImpl implements IStorehouseService 
{
    @Autowired
    private StorehouseMapper storehouseMapper;

    /**
     * 查询仓库信息
     * 
     * @param id 仓库信息主键
     * @return 仓库信息
     */
    @Override
    public Storehouse selectStorehouseById(Long id)
    {
        return storehouseMapper.selectStorehouseById(id);
    }

    /**
     * 查询仓库信息列表
     * 
     * @param storehouse 仓库信息
     * @return 仓库信息
     */
    @Override
    public List<Storehouse> selectStorehouseList(Storehouse storehouse)
    {
        return storehouseMapper.selectStorehouseList(storehouse);
    }

    /**
     * 新增仓库信息
     * 
     * @param storehouse 仓库信息
     * @return 结果
     */
    @Override
    public int insertStorehouse(Storehouse storehouse)
    {
        return storehouseMapper.insertStorehouse(storehouse);
    }

    /**
     * 修改仓库信息
     * 
     * @param storehouse 仓库信息
     * @return 结果
     */
    @Override
    public int updateStorehouse(Storehouse storehouse)
    {
        return storehouseMapper.updateStorehouse(storehouse);
    }

    /**
     * 批量删除仓库信息
     * 
     * @param ids 需要删除的仓库信息主键
     * @return 结果
     */
    @Override
    public int deleteStorehouseByIds(Long[] ids)
    {
        return storehouseMapper.deleteStorehouseByIds(ids);
    }

    /**
     * 删除仓库信息信息
     * 
     * @param id 仓库信息主键
     * @return 结果
     */
    @Override
    public int deleteStorehouseById(Long id)
    {
        return storehouseMapper.deleteStorehouseById(id);
    }
}
