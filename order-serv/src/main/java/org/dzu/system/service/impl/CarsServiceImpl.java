package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.CarsMapper;
import org.dzu.system.domain.Cars;
import org.dzu.system.service.ICarsService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 外部车辆信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class CarsServiceImpl implements ICarsService
{
    @Autowired
    private CarsMapper carsMapper;

    /**
     * 查询外部车辆信息
     *
     * @param id 外部车辆信息主键
     * @return 外部车辆信息
     */
    @Override
    public Cars selectCarsById(Long id)
    {
        return carsMapper.selectCarsById(id);
    }

    /**
     * 查询外部车辆信息列表
     *
     * @param cars 外部车辆信息
     * @return 外部车辆信息
     */
    @Override
    public List<Cars> selectCarsList(Cars cars)
    {
        return carsMapper.selectCarsList(cars);
    }

    /**
     * 新增外部车辆信息
     *
     * @param cars 外部车辆信息
     * @return 结果
     */
    @Override
    public int insertCars(Cars cars)
    {
        cars.setAddtime(String.valueOf(DateUtils.getNowDate()));
        cars.setUserId(SecurityUtils.getUserId());
        cars.setUserName(SecurityUtils.getUserTruename());
        cars.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return carsMapper.insertCars(cars);
    }

    /**
     * 修改外部车辆信息
     * 
     * @param cars 外部车辆信息
     * @return 结果
     */
    @Override
    public int updateCars(Cars cars)
    {
        cars.setUserId(SecurityUtils.getUserId());
        cars.setUserName(SecurityUtils.getUserTruename());
        cars.setUpdateTime(DateUtils.getNowDate());
        return carsMapper.updateCars(cars);
    }

    /**
     * 批量删除外部车辆信息
     * 
     * @param ids 需要删除的外部车辆信息主键
     * @return 结果
     */
    @Override
    public int deleteCarsByIds(Long[] ids)
    {
        return carsMapper.deleteCarsByIds(ids);
    }

    /**
     * 删除外部车辆信息信息
     * 
     * @param id 外部车辆信息主键
     * @return 结果
     */
    @Override
    public int deleteCarsById(Long id)
    {
        return carsMapper.deleteCarsById(id);
    }
}
