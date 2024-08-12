package org.dzu.system.service.impl;

import org.dzu.common.constant.BankaccountConstants;
import org.dzu.common.constant.DelConstants;
import org.dzu.common.exception.ServiceException;
import org.dzu.system.domain.BankAccount;
import org.dzu.system.domain.Cars;
import org.dzu.system.mapper.BankAccountMapper;
import org.dzu.system.mapper.CarsMapper;
import org.dzu.system.service.IBankAccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;

/**
 * 银行账号Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class BankAccountServiceImpl implements IBankAccountService
{
    @Autowired
    private BankAccountMapper bankAccountMapper;
    @Autowired
    private CarsMapper carsMapper;

    @Override
    public BankAccount selectBankAccountByBankNo(String bankNo) {
        return bankAccountMapper.selectBankAccountByBankNo(bankNo);
    }

    /**
     * 查询银行账号
     *
     * @param id 银行账号主键
     * @return 银行账号
     */
    @Override
    public BankAccount selectBankAccountById(Long id)
    {
        return bankAccountMapper.selectBankAccountById(id);
    }

    /**
     * 查询银行账号列表
     *
     * @param bankAccount 银行账号
     * @return 银行账号
     */
    @Override
    public List<BankAccount> selectBankAccountList(BankAccount bankAccount)
    {
        return bankAccountMapper.selectBankAccountList(bankAccount);
    }

    /**
     * 新增银行账号
     *
     * @param bankAccount 银行账号
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE,rollbackFor = Exception.class)
    public int insertBankAccount(BankAccount bankAccount)
    {
        bankAccount.setDelFlag(Long.valueOf(DelConstants.NODEL));

        BankAccount query = new BankAccount();
        query.setBankNo(bankAccount.getBankNo());
        query.setAcountsType(bankAccount.getAcountsType());
        List<BankAccount> bankAccounts = selectBankAccountList(query);
        // 如果同类型下存在相同的卡号，直接拒绝
        if(bankAccounts.size()>0){
            throw new ServiceException("存在相同的银行卡号！,请删除原有的或更改本次的");
        }
        return bankAccountMapper.insertBankAccount(bankAccount);
    }

    /**
     * 修改银行账号
     * 
     * @param bankAccount 银行账号
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE,rollbackFor = Exception.class)//多次sql操作，需要保证事务
    public int updateBankAccount(BankAccount bankAccount)
    {
        BankAccount query = new BankAccount();
        query.setBankNo(bankAccount.getBankNo());
        query.setAcountsType(bankAccount.getAcountsType());
        List<BankAccount> bankAccounts = selectBankAccountList(query);
        // 如果同类型下存在相同的卡号，直接拒绝
        if(bankAccounts.size()>0&&bankAccounts.get(0).getBankNo()==bankAccount.getBankNo()){
            throw new ServiceException("存在相同的银行卡号！,请删除原有的或更改本次的");
        }
        return bankAccountMapper.updateBankAccount(bankAccount);
    }

    /**
     * 批量删除银行账号
     * 
     * @param ids 需要删除的银行账号主键
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteBankAccountByIds(Long[] ids)
    {
        // 先搜索全部要删除的信息,检测有无司机
        List<BankAccount> bankAccounts = bankAccountMapper.selectBatchIds(Arrays.asList(ids));
        bankAccounts.forEach(bankAccount -> {
            if(bankAccount.getAcountsType().equals(BankaccountConstants.DRIVER)){
                // 去搜索cars表,看看对应的司机的银行卡是不是本次的卡
                Cars cars = carsMapper.selectCarsById(bankAccount.getCompanyId());
                if(cars.getBankNo().equals(bankAccount.getBankNo())){
                    throw new ServiceException("存在司机使用本次银行卡，无法删除！");
                }
            }
        });
        return bankAccountMapper.deleteBankAccountByIds(ids);
    }

}
