package org.dzu.system.service.impl;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.dzu.common.constant.BankChangeConstant;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.uuid.UUID;
import org.dzu.system.domain.BankAccountChange;
import org.dzu.system.service.IBankAccountChangeService;
import org.dzu.system.service.IBankAccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.LendMoneyMapper;
import org.dzu.system.domain.LendMoney;
import org.dzu.system.service.ILendMoneyService;
 
import org.dzu.common.constant.DelConstants;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

/**
 * 向外部借出款信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class LendMoneyServiceImpl implements ILendMoneyService
{
    @Autowired
    private LendMoneyMapper lendMoneyMapper;

    @Autowired
    private IBankAccountChangeService bankAccountChangeService;

    @Autowired
    private IBankAccountService bankAccountService;


    /**
     * 查询向外部借出款信息
     *
     * @param id 向外部借出款信息主键
     * @return 向外部借出款信息
     */
    @Override
    public LendMoney selectLendMoneyById(Long id)
    {
        return lendMoneyMapper.selectLendMoneyById(id);
    }

    /**
     * 查询向外部借出款信息列表
     *
     * @param lendMoney 向外部借出款信息
     * @return 向外部借出款信息
     */
    @Override
    public List<LendMoney> selectLendMoneyList(LendMoney lendMoney)
    {
        return lendMoneyMapper.selectLendMoneyList(lendMoney);
    }

    /**
     * 新增向外部借出款信息
     *
     * @param lendMoney 向外部借出款信息
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE,rollbackFor = Exception.class) // 开启最高级别的事务和最小容忍错误
    public int insertLendMoney(LendMoney lendMoney)
    {
        // 设置基础信息
        lendMoney.setAddtime(String.valueOf(DateUtils.getNowDate()));
        lendMoney.setUserId(SecurityUtils.getUserId());
        lendMoney.setUserName(SecurityUtils.getUserTruename());
        lendMoney.setDelFlag(Long.valueOf(DelConstants.NODEL));

        // 创建uuid
        lendMoney.setFuturesNO(UUID.fastUUID().toString());

        // 先查询对应银行卡是否存在
        if (bankAccountService.selectBankAccountByBankNo(lendMoney.getSelfBankNo()) == null) {
            // 丢出错误信息异常
            throw new ServiceException("银行卡号不存在");
        }

        // 同步信息到银行卡变动表
        BankAccountChange bankAccountChange = new BankAccountChange();
        bankAccountChange.setPayNO(lendMoney.getFuturesNO());
        bankAccountChange.setMoneyAmount(lendMoney.getMoneyAmount());
        bankAccountChange.setSelfBankNo(lendMoney.getSelfBankNo());
        bankAccountChange.setTableName(BankChangeConstant.TableName.LEND_MONEY.get());
        bankAccountChange.setChangeType(BankChangeConstant.PaymentType.PAYMENT.get());
        bankAccountChangeService.insertBankAccountChange(bankAccountChange);

        // 插入真正的数据
        return lendMoneyMapper.insertLendMoney(lendMoney);
    }

    /**
     * 修改向外部借出款信息
     * 
     * @param lendMoney 向外部借出款信息
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE,rollbackFor = Exception.class) // 开启最高级别的事务和最小容忍错误
    public int updateLendMoney(LendMoney lendMoney)
    {
        // 完善基础信息
        lendMoney.setUserId(SecurityUtils.getUserId());
        lendMoney.setUserName(SecurityUtils.getUserTruename());
        lendMoney.setUpdateTime(DateUtils.getNowDate());
        // 查询原来的数据
        LendMoney oldinfo = selectLendMoneyById(lendMoney.getId());
        // 如果修改了uuid，则抛出异常
        if (!oldinfo.getFuturesNO().equals(lendMoney.getFuturesNO())) {
            throw new ServiceException("不允许修改uuid");
        }
        // 检查银行卡卡号是否存在
        if (bankAccountService.selectBankAccountByBankNo(lendMoney.getSelfBankNo()) == null) {
            // 丢出错误信息异常
            throw new ServiceException("银行卡号不存在");
        }
        // 同步信息到银行卡变动表
        BankAccountChange bankAccountChange = new BankAccountChange();
        bankAccountChange.setPayNO(lendMoney.getFuturesNO());
        bankAccountChange.setMoneyAmount(lendMoney.getMoneyAmount());
        bankAccountChange.setSelfBankNo(lendMoney.getSelfBankNo());
        bankAccountChange.setTableName(BankChangeConstant.TableName.LEND_MONEY.get());
        bankAccountChange.setChangeType(BankChangeConstant.PaymentType.PAYMENT.get());

        bankAccountChangeService.updateBankAccountChangeByUUID(bankAccountChange);


        // 更新数据
        return lendMoneyMapper.updateLendMoney(lendMoney);
    }

    /**
     * 批量删除向外部借出款信息
     * 
     * @param ids 需要删除的向外部借出款信息主键
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE,rollbackFor = Exception.class) // 开启最高级别的事务和最小容忍错误
    public int deleteLendMoneyByIds(Long[] ids)
    {
        // 通过mybatis plus批量查询主键
        List<LendMoney> lendMoneys = lendMoneyMapper.selectBatchIds(Arrays.asList(ids));
        // 获取所有的uuid
        List<String> collect = lendMoneys.parallelStream().map(LendMoney::getFuturesNO).collect(Collectors.toList());
        // 批量删除掉对应的资金变动日志
        bankAccountChangeService.deleteBankAccountChangeByUUID(collect.toArray(new String[0]));


        // 真正的删除数据
        return lendMoneyMapper.deleteLendMoneyByIds(ids);
    }


}
