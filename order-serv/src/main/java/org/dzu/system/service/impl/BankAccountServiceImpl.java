package org.dzu.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.dzu.common.constant.BankaccountConstants;
import org.dzu.common.constant.DelConstants;
import org.dzu.common.enums.TableName;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.StringUtils;
import org.dzu.system.domain.BankAccount;
import org.dzu.system.domain.BankAccountChange;
import org.dzu.system.domain.Cars;
import org.dzu.system.domain.Company;
import org.dzu.system.domain.vo.TranseferMoney;
import org.dzu.system.mapper.BankAccountMapper;
import org.dzu.system.mapper.CarsMapper;
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
public class BankAccountServiceImpl {
    @Autowired
    private BankAccountMapper bankAccountMapper;
    @Autowired
    private CarsMapper carsMapper;
    @Autowired
    private BankAccountChangeServiceImpl bankAccountChangeServiceImpl;
    @Autowired
    private CompanyServiceImpl companyServiceImpl;

    public BankAccount selectBankAccountByBankNo(String bankNo) {
        return bankAccountMapper.selectBankAccountByBankNo(bankNo);
    }

    /**
     * 查询银行账号
     *
     * @param id 银行账号主键
     * @return 银行账号
     */
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
     * 创建一个客户的默认卡
     *
     * @param bankAccount 银行账号
     * @return 结果
     */
    @Transactional(isolation = Isolation.SERIALIZABLE,rollbackFor = Exception.class)
    public int insertCompanyDefaultBankAccount(BankAccount bankAccount)
    {
        // 这里获取一下卡的类别,如果是默认卡,则代表一定绑定到company中的一个客户
        if(bankAccount.getAcountsType().endsWith(BankaccountConstants.DEFAULT)&&bankAccount.getAcountsType().length()>BankaccountConstants.DEFAULT.length()){
            if(StringUtils.isNull(bankAccount.getCompanyId())){
                throw new ServiceException("添加默认卡时必须绑定到客户");
            }
            // 抓取对应客户信息
            Company company = companyServiceImpl.selectCompanyById(bankAccount.getCompanyId());
            if(StringUtils.isNull(company)){
                throw new ServiceException("绑定的客户不存在！");
            }
            //1. 检测客户的其他默认卡,全改成非默认
            BankAccount queryDefault = new BankAccount();
            queryDefault.setCompanyId(bankAccount.getCompanyId());
            queryDefault.setAcountsType(BankaccountConstants.DEFAULT);
            List<BankAccount> defaultBankAccounts = selectBankAccountList(queryDefault);
            for (BankAccount defaultBankAccount : defaultBankAccounts) {
                // 遍历修改掉原来的默认卡成对应的供应商卡或者客户卡
                defaultBankAccount.setAcountsType(company.getCompanyType());
                updateBankAccount(defaultBankAccount);
            }
            // 2.修改客户信息中的银行卡信息
            company.setBankNo(bankAccount.getBankNo());
            company.setBankName(bankAccount.getBankName());
            company.setAcountsName(bankAccount.getAcountsName());
            company.setId(bankAccount.getCompanyId());
            companyServiceImpl.updateCompany(company);





            // 3. 插入默认卡信息
            // 需要搜索一下是否存在相同的卡号,是的话就不是新增,而是修改
            QueryWrapper<BankAccount> eq = new QueryWrapper<BankAccount>().eq("bankNo", bankAccount.getBankNo()).eq("companyId", bankAccount.getCompanyId());
            List<BankAccount> bankAccounts = bankAccountMapper.selectList(eq);
            if(bankAccounts.size()>0){
                bankAccount.setId(bankAccounts.get(0).getId());
                return updateBankAccount(bankAccount);
            }else {
                return insertBankAccount(bankAccount);
            }
        }else {
            throw new ServiceException("调用接口参数错误");
        }
    }
    /**
     * 修改银行账号
     * 
     * @param bankAccount 银行账号
     * @return 结果
     */
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
    @Transactional
    public int deleteBankAccountByIds(Long[] ids)
    {
        // 先搜索全部要删除的信息
        List<BankAccount> bankAccounts = bankAccountMapper.selectBatchIds(Arrays.asList(ids));
        bankAccounts.forEach(bankAccount -> {
            if(bankAccount.getAcountsType().equals(BankaccountConstants.DRIVER)){
                // 去搜索cars表,看看对应的司机的银行卡是不是本次的卡
                Cars cars = carsMapper.selectCarsById(bankAccount.getCompanyId());
                if(cars.getBankNo().equals(bankAccount.getBankNo())){
                    throw new ServiceException("存在司机使用本次银行卡，无法删除！");
                }
            }
            // 检测是否为默认卡
            if(bankAccount.getAcountsType().equals(BankaccountConstants.DEFAULT)){
                // 检测是否为客户默认卡
                Company company = companyServiceImpl.selectCompanyById(bankAccount.getCompanyId());
                if(company.getBankNo().equals(bankAccount.getBankNo())){
                    throw new ServiceException("该卡:"+bankAccount.getBankNo()+"被供应商/客户绑定为默认卡,请前往对应页面调整！");
                }
            }

        });
        return bankAccountMapper.deleteBankAccountByIds(ids);
    }


    // 提供接口允许两个银行卡进行转账
    @Transactional(isolation = Isolation.SERIALIZABLE,rollbackFor = Exception.class)
    public TranseferMoney transferMoney(TranseferMoney transeferMoney){
        // 首先检测两个银行卡是否存在
        BankAccount fromBank = bankAccountMapper.selectBankAccountByBankNo(transeferMoney.getFromBankNo());
        BankAccount toBank = bankAccountMapper.selectBankAccountByBankNo(transeferMoney.getToBankNo());
        // 非空判断,防止空指针
        if(fromBank==null||toBank==null){
            throw new ServiceException("银行卡不存在！");
        }

        // 检测本次的金额是否支持转账
        if(fromBank.getAmount()<transeferMoney.getMoney()){
            throw new ServiceException("转账金额超过本次银行卡余额！");
        }

        // 如果卡号相同,则拒绝
        if(fromBank.getBankNo().equals(toBank.getBankNo())){
            throw new ServiceException("两个银行卡号相同！");
        }

        // 准备转账
        BankAccountChange fromChange = new BankAccountChange();
        fromChange.setSelfBankNo(transeferMoney.getFromBankNo());
        fromChange.setMoneyAmount(-transeferMoney.getMoney());
        fromChange.setPayNO(transeferMoney.getFromBankNo());
        fromChange.setTableName(TableName.BANK_ACCOUNT.get());
        bankAccountChangeServiceImpl.insertPaymenyChange(fromChange);
        BankAccountChange toChange = new BankAccountChange();
        toChange.setSelfBankNo(transeferMoney.getToBankNo());
        toChange.setMoneyAmount(transeferMoney.getMoney());
        toChange.setPayNO(transeferMoney.getFromBankNo());
        toChange.setTableName(TableName.BANK_ACCOUNT.get());
        bankAccountChangeServiceImpl.insertReceiptChange(toChange);

        return transeferMoney;
    }




}
