package org.dzu.system.service.impl;

import org.dzu.common.constant.BankaccountConstants;
import org.dzu.common.constant.CarsConstant;
import org.dzu.common.constant.DelConstants;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.StringUtils;
import org.dzu.common.utils.reflect.ReflectUtils;
import org.dzu.system.domain.Bankaccount;
import org.dzu.system.domain.Cars;
import org.dzu.system.mapper.CarsMapper;
import org.dzu.system.service.ICarsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.List;

/**
 * 车辆管理Service业务层处理
 *
 * @author ml
 * @date 2024-07-19
 */
@Service
public class CarsServiceImpl implements ICarsService {
    @Autowired
    private CarsMapper carsMapper;

    @Autowired
    private BankaccountServiceImpl bankaccountService;

    /**
     * 查询车辆管理
     *
     * @param id 车辆管理主键
     * @return 车辆管理
     */
    @Override
    public Cars selectCarsById(Long id) {
        return carsMapper.selectCarsById(id);
    }

    /**
     * 查询车辆管理列表
     *
     * @param cars 车辆管理
     * @return 车辆管理
     */
    @Override
    public List<Cars> selectCarsList(Cars cars) {
        return carsMapper.selectCarsList(cars);
    }

    /**
     * 新增车辆管理
     *
     * @param cars 车辆管理
     * @return 结果
     */
    @Override
    @Transactional
    public int insertCars(Cars cars) {
        Validated(cars);
        // 利用工具类写入本次操作人员
        ReflectUtils.modfiyPersonInfo(cars, SecurityUtils.getLoginUser().getUser());
        // 设置基础属性
        cars.setDelFlag(Long.valueOf(DelConstants.NODEL));
        cars.setAddtime(DateUtils.getTime());
        // 向银行表中同步信息
        Bankaccount bankaccount = new Bankaccount();
        bankaccount.setAcountsType(BankaccountConstants.DRIVER);
        bankaccount.setCompanyName(cars.getDriver());
        bankaccount.setAcountsName(cars.getAcountsName());
        bankaccount.setBankName(cars.getBankName());
        int i = carsMapper.insertCars(cars);
        bankaccount.setCompanyId(cars.getId());
        bankaccountService.insertBankaccount(bankaccount);
        return i;

    }

    /**
     * 修改车辆管理
     *
     * @param cars 车辆管理
     * @return 结果
     */
    @Override
    @Transactional
    public int updateCars(Cars cars) {
        Validated(cars);
        // 利用工具类写入本次操作人员
        ReflectUtils.modfiyPersonInfo(cars, SecurityUtils.getLoginUser().getUser());
        // 向银行表中同步信息
        Bankaccount bankaccount = new Bankaccount();
        bankaccount.setAcountsType(BankaccountConstants.DRIVER);
        bankaccount.setCompanyName(cars.getDriver());
        bankaccount.setAcountsName(cars.getAcountsName());
        bankaccount.setBankName(cars.getBankName());
        cars.setUpdateTime(DateUtils.getNowDate());
        int i =carsMapper.updateCars(cars);
        bankaccount.setCompanyId(cars.getId());
        bankaccountService.updateBankaccount(bankaccount);
        return i;
    }

    /**
     * 批量删除车辆管理
     *
     * @param ids 需要删除的车辆管理主键
     * @return 结果
     */
    @Override
    public int deleteCarsByIds(Long[] ids) {
        return carsMapper.deleteCarsByIds(ids);
    }

    /**
     * 删除车辆管理信息
     *
     * @param id 车辆管理主键
     * @return 结果
     */
    @Override
    public int deleteCarsById(Long id) {
        return carsMapper.deleteCarsById(id);
    }

    // 验证逻辑：车辆分为海运和陆运两种，海运可以没有车牌号
    private void Validated(Cars cars){
        if(cars.getCarType().equals(CarsConstant.LandTransportation)){
            if(StringUtils.isNotEmpty(cars.getCarNo())){
                return;
            }else throw new ServiceException("陆运必须填写车牌号信息");
        }
    }
}
