package com.ruoyi.system.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.CarsMapper;
import com.ruoyi.system.domain.Cars;
import com.ruoyi.system.service.ICarsService;

/**
 * 汽车信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@Service
public class CarsServiceImpl implements ICarsService 
{
    @Autowired
    private CarsMapper carsMapper;

    /**
     * 查询汽车信息
     * 
     * @param id 汽车信息主键
     * @return 汽车信息
     */
    @Override
    public Cars selectCarsById(Long id)
    {
        return carsMapper.selectCarsById(id);
    }

    /**
     * 查询汽车信息列表
     * 
     * @param cars 汽车信息
     * @return 汽车信息
     */
    @Override
    public List<Cars> selectCarsList(Cars cars)
    {
        return carsMapper.selectCarsList(cars);
    }

    /**
     * 新增汽车信息
     * 
     * @param cars 汽车信息
     * @return 结果
     */
    @Override
    public int insertCars(Cars cars)
    {
        return carsMapper.insertCars(cars);
    }

    /**
     * 修改汽车信息
     * 
     * @param cars 汽车信息
     * @return 结果
     */
    @Override
    public int updateCars(Cars cars)
    {
        cars.setUpdateTime(DateUtils.getNowDate());
        return carsMapper.updateCars(cars);
    }

    /**
     * 批量删除汽车信息
     * 
     * @param ids 需要删除的汽车信息主键
     * @return 结果
     */
    @Override
    public int deleteCarsByIds(Long[] ids)
    {
        return carsMapper.deleteCarsByIds(ids);
    }

    /**
     * 删除汽车信息信息
     * 
     * @param id 汽车信息主键
     * @return 结果
     */
    @Override
    public int deleteCarsById(Long id)
    {
        return carsMapper.deleteCarsById(id);
    }
}
