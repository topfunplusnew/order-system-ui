package org.dzu.system.service.impl;

import org.dzu.common.constant.CarsConstant;
import org.dzu.common.constant.DelConstants;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.StringUtils;
import org.dzu.system.domain.BankAccount;
import org.dzu.system.domain.Cars;
import org.dzu.system.mapper.CarsMapper;
import org.dzu.system.service.ICarsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 外部车辆信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class CarsServiceImpl implements ICarsService {
    @Autowired
    private CarsMapper carsMapper;

    @Autowired
    private BankAccountServiceImpl bankAccountService;

    /**
     * 查询外部车辆信息
     *
     * @param id 外部车辆信息主键
     * @return 外部车辆信息
     */
    @Override
    public Cars selectCarsById(Long id) {
        return carsMapper.selectCarsById(id);
    }

    /**
     * 查询外部车辆信息列表
     *
     * @param cars 外部车辆信息
     * @return 外部车辆信息
     */
    @Override
    public List<Cars> selectCarsList(Cars cars) {
        return carsMapper.selectCarsList(cars);
    }

    /**
     * 新增外部车辆信息
     *
     * @param cars 外部车辆信息
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertCars(Cars cars) {
        cars.setAddtime(String.valueOf(DateUtils.getNowDate()));
        cars.setUserId(SecurityUtils.getUserId());
        cars.setUserName(SecurityUtils.getUserTruename());
        cars.setDelFlag(Long.valueOf(DelConstants.NODEL));
        // 逻辑校验
        Validated(cars);
        // 先执行插入，获取主键
        int i = carsMapper.insertCars(cars);

        // 同步到银行卡管理
        syncToBankAccount(cars);

        return i;
    }

    /**
     * 修改外部车辆信息
     *
     * @param cars 外部车辆信息
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateCars(Cars cars) {
        cars.setUserId(SecurityUtils.getUserId());
        cars.setUserName(SecurityUtils.getUserTruename());
        cars.setUpdateTime(DateUtils.getNowDate());
        // 逻辑校验
        Validated(cars);

        // 同步到银行卡管理
        syncToBankAccount(cars);
        return carsMapper.updateCars(cars);
    }

    /**
     * 批量删除外部车辆信息
     *
     * @param ids 需要删除的外部车辆信息主键
     * @return 结果
     */
    @Override
    public int deleteCarsByIds(Long[] ids) {
        return carsMapper.deleteCarsByIds(ids);
    }

    /**
     * 删除外部车辆信息信息
     *
     * @param id 外部车辆信息主键
     * @return 结果
     */
    @Override
    public int deleteCarsById(Long id) {
        return carsMapper.deleteCarsById(id);
    }

    private void Validated(Cars cars) {
        // 验证逻辑上是否正确
        //  车辆分为海运和陆运两种，海运可以没有车牌号，
        if (cars.getCarType().equals(CarsConstant.LandTransportation) && StringUtils.isEmpty(cars.getCarNo())) {
            throw new ServiceException("陆运车辆必须填写车牌号信息");
        }
    }

    private void syncToBankAccount(Cars cars) {
        // 如果是司机，应该同步到银行卡管理上
        // 先根据id拿数据库的旧Cars信息，用来搜索使用
        Cars oldCarsinfo = selectCarsById(cars.getId());
        // 拼装新的信息
        BankAccount newBankAccountInfo = new BankAccount();
        newBankAccountInfo.setCompanyName(cars.getDriver());
        newBankAccountInfo.setBankName(cars.getBankName());
        newBankAccountInfo.setAcountsName(cars.getAcountsName());
        newBankAccountInfo.setBankNo(cars.getBankNo());
        newBankAccountInfo.setAmount(Double.valueOf(0));
        newBankAccountInfo.setCompanyId(cars.getId());
        newBankAccountInfo.setAcountsType(CarsConstant.DriverType);
        if (oldCarsinfo == null) {
            //没有旧的车辆信息，本次肯定是新增
            bankAccountService.insertBankAccount(newBankAccountInfo);
            // 插入后直接返回
            return;
        }
        // 拼装一个搜索理由
        BankAccount bankAccount = new BankAccount();
        bankAccount.setAcountsType(CarsConstant.DriverType);
        bankAccount.setCompanyId(oldCarsinfo.getId());
        bankAccount.setBankNo(oldCarsinfo.getBankNo());
        // 首先尝试获取，判断是修改、新增
        List<BankAccount> bankAccounts = bankAccountService.selectBankAccountList(bankAccount);
        if (bankAccounts.size() > 0) {
            // 存在，所以当前是修改
            newBankAccountInfo.setId(bankAccounts.get(0).getId());// 拼接上原信息的id，允许修改
            bankAccountService.updateBankAccount(newBankAccountInfo);
        } else {
            // 不存在，但是找到旧车辆信息。故进行插入
            // 之前车的信息有了，但是本次修改提交了修改银行卡的情况
            //TODO： 这个情况有点奇怪，以后再来分析
            bankAccountService.insertBankAccount(newBankAccountInfo);
        }
    }

}
