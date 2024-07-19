package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.CarsMapper;
import org.dzu.system.domain.Cars;
import org.dzu.system.service.ICarsService;

/**
 * 车辆管理Service业务层处理
 * 
 * @author ml
 * @date 2024-07-19
 */
@Service
public class CarsServiceImpl implements ICarsService 
{
    @Autowired
    private CarsMapper carsMapper;

    /**
     * 查询车辆管理
     * 
     * @param id 车辆管理主键
     * @return 车辆管理
     */
    @Override
    public Cars selectCarsById(Long id)
    {
        return carsMapper.selectCarsById(id);
    }

    /**
     * 查询车辆管理列表
     * 
     * @param cars 车辆管理
     * @return 车辆管理
     */
    @Override
    public List<Cars> selectCarsList(Cars cars)
    {
        return carsMapper.selectCarsList(cars);
    }

    /**
     * 新增车辆管理
     * 
     * @param cars 车辆管理
     * @return 结果
     */
    @Override
    public int insertCars(Cars cars)
    {
        return carsMapper.insertCars(cars);
    }

    /**
     * 修改车辆管理
     * 
     * @param cars 车辆管理
     * @return 结果
     */
    @Override
    public int updateCars(Cars cars)
    {
        cars.setUpdateTime(DateUtils.getNowDate());
        return carsMapper.updateCars(cars);
    }

    /**
     * 批量删除车辆管理
     * 
     * @param ids 需要删除的车辆管理主键
     * @return 结果
     */
    @Override
    public int deleteCarsByIds(Long[] ids)
    {
        return carsMapper.deleteCarsByIds(ids);
    }

    /**
     * 删除车辆管理信息
     * 
     * @param id 车辆管理主键
     * @return 结果
     */
    @Override
    public int deleteCarsById(Long id)
    {
        return carsMapper.deleteCarsById(id);
    }
}
