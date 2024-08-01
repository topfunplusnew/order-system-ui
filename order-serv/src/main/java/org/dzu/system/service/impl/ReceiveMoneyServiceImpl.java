package org.dzu.system.service.impl;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.dzu.common.constant.BankChangeConstant;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.uuid.UUID;
import org.dzu.system.domain.BankAccountChange;
import org.dzu.system.service.IBankAccountChangeService;
import org.dzu.system.service.IBankAccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.ReceiveMoneyMapper;
import org.dzu.system.domain.ReceiveMoney;
import org.dzu.system.service.IReceiveMoneyService;
 
import org.dzu.common.constant.DelConstants;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

/**
 * 收款信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class ReceiveMoneyServiceImpl implements IReceiveMoneyService
{
    @Autowired
    private ReceiveMoneyMapper receiveMoneyMapper;

    @Autowired
    private IBankAccountService bankAccountService;

    @Autowired
    private IBankAccountChangeService bankAccountChangeService;
    /**
     * 查询收款信息
     *
     * @param id 收款信息主键
     * @return 收款信息
     */
    @Override
    public ReceiveMoney selectReceiveMoneyById(Long id)
    {
        return receiveMoneyMapper.selectReceiveMoneyById(id);
    }

    /**
     * 查询收款信息列表
     *
     * @param receiveMoney 收款信息
     * @return 收款信息
     */
    @Override
    public List<ReceiveMoney> selectReceiveMoneyList(ReceiveMoney receiveMoney)
    {
        return receiveMoneyMapper.selectReceiveMoneyList(receiveMoney);
    }

    /**
     * 根据 UUID查询收款信息
     */
    @Override
    public ReceiveMoney selectReceiveMoneyByReceiveNO(String receiveNO)
    {
        QueryWrapper<ReceiveMoney> query = new QueryWrapper<>();
        query.select().eq("receiveNO", receiveNO).eq("delFlag", DelConstants.NODEL);
        return receiveMoneyMapper.selectOne(query);
    }

    /**
     * 新增收款信息
     *
     * @param receiveMoney 收款信息
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE, rollbackFor = Exception.class)// 开启最高级别的事务隔离和最小容忍异常
    public int insertReceiveMoney(ReceiveMoney receiveMoney)
    {
        // 设置基础信息
        receiveMoney.setAddtime(String.valueOf(DateUtils.getNowDate()));
        receiveMoney.setUserId(SecurityUtils.getUserId());
        receiveMoney.setUserName(SecurityUtils.getUserTruename());
        receiveMoney.setDelFlag(Long.valueOf(DelConstants.NODEL));

        // 判断交易双方的银行卡是否存在
        if(bankAccountService.selectBankAccountByBankNo(receiveMoney.getSelfBankNo())==null){
            throw new ServiceException("对应银行卡号不存在");
        }
        if(bankAccountService.selectBankAccountByBankNo(receiveMoney.getOtherBankNo())==null){
            throw new ServiceException("对应银行卡号不存在");
        }
        // 生成UUID
        receiveMoney.setReceiveNO(UUID.fastUUID().toString());

        syncToBankChange(receiveMoney);

        // 插入
        return receiveMoneyMapper.insertReceiveMoney(receiveMoney);
    }


    /**
     * 修改收款信息
     *
     * @param receiveMoney 收款信息
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE, rollbackFor = Exception.class)// 开启最高级别的事务隔离和最小容忍异常
    public int updateReceiveMoney(ReceiveMoney receiveMoney)
    {
        // 基础信息
        receiveMoney.setUserId(SecurityUtils.getUserId());
        receiveMoney.setUserName(SecurityUtils.getUserTruename());
        receiveMoney.setUpdateTime(DateUtils.getNowDate());

        // 判断交易双方的银行卡是否存在
        if(bankAccountService.selectBankAccountByBankNo(receiveMoney.getSelfBankNo())==null){
            throw new ServiceException("对应银行卡号不存在");
        }
        if(bankAccountService.selectBankAccountByBankNo(receiveMoney.getOtherBankNo())==null){
            throw new ServiceException("对应银行卡号不存在");
        }

        // 判断是否修改UUID
        ReceiveMoney old = receiveMoneyMapper.selectReceiveMoneyById(receiveMoney.getId());
        if(!old.getReceiveNO().equals(receiveMoney.getReceiveNO())){
            throw new ServiceException("不允许修改UUID");
        }


        // 因为变动表对与本次来说是由两个相同的UUID，所以这里使用先删除，后插入，而不是修改
        // 批量删除
        bankAccountChangeService.deleteBankAccountChangeByUUID(new String[]{receiveMoney.getReceiveNO()});
        // 同步到银行账户变动表
        syncToBankChange(receiveMoney);

        // 更新
        return receiveMoneyMapper.updateReceiveMoney(receiveMoney);
    }

    /**
     * 批量删除收款信息
     *
     * @param ids 需要删除的收款信息主键
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE, rollbackFor = Exception.class)// 开启最高级别的事务隔离和最小容忍异常
    public int deleteReceiveMoneyByIds(Long[] ids)
    {
        // 先查询出所有信息
        List<ReceiveMoney> receiveMonies = receiveMoneyMapper.selectBatchIds(Arrays.asList(ids));
        // 批量删除
        List<String> collect = receiveMonies.parallelStream().map(ReceiveMoney::getReceiveNO).collect(Collectors.toList());
        bankAccountChangeService.deleteBankAccountChangeByUUID(collect.toArray(new String[0]));

        // 执行本信息的删除
        return receiveMoneyMapper.deleteReceiveMoneyByIds(ids);
    }

    /**
     * 同步到银行账户变动表
     * @param receiveMoney
     */
    private void syncToBankChange(ReceiveMoney receiveMoney) {
        // 同步到银行账户变动表，我方收款
        BankAccountChange selfChange = new BankAccountChange();
        selfChange.setSelfBankNo(receiveMoney.getSelfBankNo());
        selfChange.setMoneyAmount(receiveMoney.getMoneyAmount());
        selfChange.setChangeType(BankChangeConstant.PaymentType.RECEIPT.get());
        selfChange.setTableName(BankChangeConstant.TableName.RECEIVE_MONEY.get());
        selfChange.setPayNO(receiveMoney.getReceiveNO());
        bankAccountChangeService.insertBankAccountChange(selfChange);

        // 同步到银行账户变动表，对方付款
        BankAccountChange otherChange = new BankAccountChange();
        otherChange.setSelfBankNo(receiveMoney.getOtherBankNo());
        otherChange.setMoneyAmount(receiveMoney.getMoneyAmount());
        otherChange.setChangeType(BankChangeConstant.PaymentType.PAYMENT.get());
        otherChange.setTableName(BankChangeConstant.TableName.RECEIVE_MONEY.get());
        otherChange.setPayNO(receiveMoney.getReceiveNO());
        bankAccountChangeService.insertBankAccountChange(otherChange);
    }
}
