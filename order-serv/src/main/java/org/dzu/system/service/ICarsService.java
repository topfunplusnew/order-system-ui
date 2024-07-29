package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Cars;

/**
 * 车辆管理Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface ICarsService 
{
    /**
     * 查询车辆管理
     * 
     * @param id 车辆管理主键
     * @return 车辆管理
     */
    public Cars selectCarsById(Long id);

    /**
     * 查询车辆管理列表
     * 
     * @param cars 车辆管理
     * @return 车辆管理集合
     */
    public List<Cars> selectCarsList(Cars cars);

    /**
     * 新增车辆管理
     * 
     * @param cars 车辆管理
     * @return 结果
     */
    public int insertCars(Cars cars);

    /**
     * 修改车辆管理
     * 
     * @param cars 车辆管理
     * @return 结果
     */
    public int updateCars(Cars cars);

    /**
     * 批量删除车辆管理
     * 
     * @param ids 需要删除的车辆管理主键集合
     * @return 结果
     */
    public int deleteCarsByIds(Long[] ids);

    /**
     * 删除车辆管理信息
     * 
     * @param id 车辆管理主键
     * @return 结果
     */
    public int deleteCarsById(Long id);
}
