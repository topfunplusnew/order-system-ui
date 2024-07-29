package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import java.util.List;
import org.dzu.system.domain.StoreHouse;

/**
 * 库房Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface StoreHouseMapper extends BaseMapper<StoreHouse>
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
     * 删除库房
     * 
     * @param id 库房主键
     * @return 结果
     */
    public int deleteStoreHouseById(Long id);

    /**
     * 批量删除库房
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteStoreHouseByIds(Long[] ids);
}
