package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import java.util.List;
import org.dzu.system.domain.ExWarehouse;

/**
 * 出库Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface ExWarehouseMapper extends BaseMapper<ExWarehouse>
{
    /**
     * 查询出库
     * 
     * @param id 出库主键
     * @return 出库
     */
    public ExWarehouse selectExWarehouseById(Long id);

    /**
     * 查询出库列表
     * 
     * @param exWarehouse 出库
     * @return 出库集合
     */
    public List<ExWarehouse> selectExWarehouseList(ExWarehouse exWarehouse);

    /**
     * 新增出库
     * 
     * @param exWarehouse 出库
     * @return 结果
     */
    public int insertExWarehouse(ExWarehouse exWarehouse);

    /**
     * 修改出库
     * 
     * @param exWarehouse 出库
     * @return 结果
     */
    public int updateExWarehouse(ExWarehouse exWarehouse);

    /**
     * 删除出库
     * 
     * @param id 出库主键
     * @return 结果
     */
    public int deleteExWarehouseById(Long id);

    /**
     * 批量删除出库
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteExWarehouseByIds(Long[] ids);
}
