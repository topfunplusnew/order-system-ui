package org.dzu.system.service;

import org.dzu.system.domain.StoreHouse;

import java.util.List;

/**
 * 库房Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IStoreHouseService 
{
    /**
     * 查询库房
     * 
     * @param id 库房主键
     * @return 库房
     */
    public StoreHouse selectStoreHouseById(Long id);

    /**
     * 查询库房列表
     * 
     * @param storeHouse 库房
     * @return 库房集合
     */
    public List<StoreHouse> selectStoreHouseList(StoreHouse storeHouse);

    /**
     * 新增库房
     * 
     * @param storeHouse 库房
     * @return 结果
     */
    public int insertStoreHouse(StoreHouse storeHouse);

    /**
     * 修改库房
     * 
     * @param storeHouse 库房
     * @return 结果
     */
    public int updateStoreHouse(StoreHouse storeHouse);

    /**
     * 批量删除库房
     * 
     * @param ids 需要删除的库房主键集合
     * @return 结果
     */
    public int deleteStoreHouseByIds(Long[] ids);

    /**
     * 删除库房信息
     * 
     * @param id 库房主键
     * @return 结果
     */
    public int deleteStoreHouseById(Long id);
}
