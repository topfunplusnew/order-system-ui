package org.dzu.system.mapper;

import org.dzu.system.domain.Cars;

import java.util.List;

/**
 * 汽车信息Mapper接口
 * 
 * @author ml
 * @date 2024-07-18
 */
public interface CarsMapper 
{
    /**
     * 查询汽车信息
     * 
     * @param id 汽车信息主键
     * @return 汽车信息
     */
    public Cars selectCarsById(Long id);

    /**
     * 查询汽车信息列表
     * 
     * @param cars 汽车信息
     * @return 汽车信息集合
     */
    public List<Cars> selectCarsList(Cars cars);

    /**
     * 新增汽车信息
     * 
     * @param cars 汽车信息
     * @return 结果
     */
    public int insertCars(Cars cars);

    /**
     * 修改汽车信息
     * 
     * @param cars 汽车信息
     * @return 结果
     */
    public int updateCars(Cars cars);

    /**
     * 删除汽车信息
     * 
     * @param id 汽车信息主键
     * @return 结果
     */
    public int deleteCarsById(Long id);

    /**
     * 批量删除汽车信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteCarsByIds(Long[] ids);
}
