package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.dzu.system.domain.Cars;

import java.util.List;

/**
 * 外部车辆信息Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface CarsMapper extends BaseMapper<Cars>
{
    /**
     * 查询外部车辆信息
     * 
     * @param id 外部车辆信息主键
     * @return 外部车辆信息
     */
    public Cars selectCarsById(Long id);

    /**
     * 查询外部车辆信息列表
     * 
     * @param cars 外部车辆信息
     * @return 外部车辆信息集合
     */
    public List<Cars> selectCarsList(Cars cars);

    /**
     * 新增外部车辆信息
     * 
     * @param cars 外部车辆信息
     * @return 结果
     */
    public int insertCars(Cars cars);

    /**
     * 修改外部车辆信息
     * 
     * @param cars 外部车辆信息
     * @return 结果
     */
    public int updateCars(Cars cars);

    /**
     * 删除外部车辆信息
     * 
     * @param id 外部车辆信息主键
     * @return 结果
     */
    public int deleteCarsById(Long id);

    /**
     * 批量删除外部车辆信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteCarsByIds(Long[] ids);
}
