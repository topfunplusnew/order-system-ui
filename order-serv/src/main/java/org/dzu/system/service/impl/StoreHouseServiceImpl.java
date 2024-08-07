package org.dzu.system.service.impl;

import org.dzu.common.constant.DelConstants;
import org.dzu.system.domain.StoreHouse;
import org.dzu.system.mapper.StoreHouseMapper;
import org.dzu.system.service.IStoreHouseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
/**
 * 库房Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class StoreHouseServiceImpl implements IStoreHouseService
{
    @Autowired
    private StoreHouseMapper storeHouseMapper;

    /**
     * 查询库房
     *
     * @param id 库房主键
     * @return 库房
     */
    @Override
    public StoreHouse selectStoreHouseById(Long id)
    {
        return storeHouseMapper.selectStoreHouseById(id);
    }

    /**
     * 查询库房列表
     *
     * @param storeHouse 库房
     * @return 库房
     */
    @Override
    public List<StoreHouse> selectStoreHouseList(StoreHouse storeHouse)
    {
        return storeHouseMapper.selectStoreHouseList(storeHouse);
    }

    /**
     * 新增库房
     *
     * @param storeHouse 库房
     * @return 结果
     */
    @Override
    public int insertStoreHouse(StoreHouse storeHouse)
    {
        storeHouse.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return storeHouseMapper.insertStoreHouse(storeHouse);
    }

    /**
     * 修改库房
     * 
     * @param storeHouse 库房
     * @return 结果
     */
    @Override
    public int updateStoreHouse(StoreHouse storeHouse)
    {
        return storeHouseMapper.updateStoreHouse(storeHouse);
    }

    /**
     * 批量删除库房
     * 
     * @param ids 需要删除的库房主键
     * @return 结果
     */
    @Override
    public int deleteStoreHouseByIds(Long[] ids)
    {
        return storeHouseMapper.deleteStoreHouseByIds(ids);
    }

    /**
     * 删除库房信息
     * 
     * @param id 库房主键
     * @return 结果
     */
    @Override
    public int deleteStoreHouseById(Long id)
    {
        return storeHouseMapper.deleteStoreHouseById(id);
    }
}
