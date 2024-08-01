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
import org.dzu.system.domain.LendMoney;
import org.dzu.system.mapper.LendMoneyMapper;
import org.dzu.system.service.IBankAccountChangeService;
import org.dzu.system.service.IBankAccountService;
import org.dzu.system.service.ILendMoneyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.RecoverMoneyMapper;
import org.dzu.system.domain.RecoverMoney;
import org.dzu.system.service.IRecoverMoneyService;
 
import org.dzu.common.constant.DelConstants;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

/**
 * 借出款收回信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class RecoverMoneyServiceImpl implements IRecoverMoneyService
{
    @Autowired
    private IBankAccountService bankAccountServic;


    @Autowired
    private RecoverMoneyMapper recoverMoneyMapper;

    @Autowired
    private ILendMoneyService lendMoneyService;

    @Autowired
    private IBankAccountChangeService bankAccountChangeService;

    @Autowired
    private LendMoneyMapper lendMoneyMapper;
    /**
     * 查询借出款收回信息
     *
     * @param id 借出款收回信息主键
     * @return 借出款收回信息
     */
    @Override
    public RecoverMoney selectRecoverMoneyById(Long id)
    {
        return recoverMoneyMapper.selectRecoverMoneyById(id);
    }

    /**
     * 查询借出款收回信息列表
     *
     * @param recoverMoney 借出款收回信息
     * @return 借出款收回信息
     */
    @Override
    public List<RecoverMoney> selectRecoverMoneyList(RecoverMoney recoverMoney)
    {
        return recoverMoneyMapper.selectRecoverMoneyList(recoverMoney);
    }

    /**
     * 根据借出款编号查询借出款收回信息
     *
     * @param futuresNO
     * @return
     */
    @Override
    public List<RecoverMoney> selectRecoverMoneyByFuturesNO(String futuresNO)
    {
        QueryWrapper<RecoverMoney> queryWrapper = new QueryWrapper<>();
        queryWrapper.select().eq("futuresNO", futuresNO).eq("delFlag", DelConstants.NODEL);
        return recoverMoneyMapper.selectList(queryWrapper);
    }

    /**
     * 新增借出款收回信息
     *
     * @param recoverMoney 借出款收回信息
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE,rollbackFor = Exception.class) // 开启最高级别的事务和最小容忍错误
    public int insertRecoverMoney(RecoverMoney recoverMoney)
    {
        // 设置基础信息
        recoverMoney.setAddtime(String.valueOf(DateUtils.getNowDate()));
        recoverMoney.setUserId(SecurityUtils.getUserId());
        recoverMoney.setUserName(SecurityUtils.getUserTruename());
        recoverMoney.setDelFlag(Long.valueOf(DelConstants.NODEL));

        // 查询对应的借出款信息
        LendMoney lendMoney = lendMoneyService.selectLendMoneyByFuturesNO(recoverMoney.getFuturesNO());
        if(lendMoney==null){
            // 找不到这个对应的记录，即错误参数
            throw new ServiceException("找不到对应的借出款信息，请刷新页面后重试");
        }

        // 查询银行卡号是否存在
        if (bankAccountServic.selectBankAccountByBankNo(recoverMoney.getBankNo()) == null) {
            // 丢出错误信息异常
            throw new ServiceException("银行卡号不存在");
        }
        // 如果都存在，那么准备插入本次信息
        // 首先创建uuid
        recoverMoney.setRecoverNO(UUID.fastUUID().toString());

        // 同步到银行卡变动中去
        BankAccountChange bankAccountChange = new BankAccountChange();
        bankAccountChange.setChangeType(BankChangeConstant.PaymentType.RECEIPT.get());
        bankAccountChange.setMoneyAmount(recoverMoney.getMoneyAmount());
        bankAccountChange.setPayNO(recoverMoney.getRecoverNO());
        bankAccountChange.setSelfBankNo(recoverMoney.getBankNo());
        bankAccountChange.setTableName(BankChangeConstant.TableName.RECOVER_MONEY.get());
        bankAccountChangeService.insertBankAccountChange(bankAccountChange);

        // 执行插入
        return recoverMoneyMapper.insertRecoverMoney(recoverMoney);
    }

    /**
     * 修改借出款收回信息
     * 
     * @param recoverMoney 借出款收回信息
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE,rollbackFor = Exception.class) // 开启最高级别的事务和最小容忍错误
    public int updateRecoverMoney(RecoverMoney recoverMoney)
    {
        // 设置基础信息
        recoverMoney.setUserId(SecurityUtils.getUserId());
        recoverMoney.setUserName(SecurityUtils.getUserTruename());
        recoverMoney.setUpdateTime(DateUtils.getNowDate());

        // 判断本次更新有没有修改UUID
        RecoverMoney oldRecoverMoney = recoverMoneyMapper.selectRecoverMoneyById(recoverMoney.getId());
        if(!oldRecoverMoney.getFuturesNO().equals(recoverMoney.getFuturesNO())){
            throw new ServiceException("不允许修改uuid");
        }
        if(!oldRecoverMoney.getRecoverNO().equals(recoverMoney.getRecoverNO())){
            throw new ServiceException("不允许修改uuid");
        }

        // 查询修改后的银行卡号是否存在
        if (bankAccountServic.selectBankAccountByBankNo(recoverMoney.getBankNo()) == null) {
            // 丢出错误信息异常
            throw new ServiceException("银行卡号不存在");
        }

        // 创建银行卡变动信息
        BankAccountChange bankAccountChange = new BankAccountChange();
        bankAccountChange.setChangeType(BankChangeConstant.PaymentType.RECEIPT.get());
        bankAccountChange.setMoneyAmount(recoverMoney.getMoneyAmount());
        bankAccountChange.setPayNO(recoverMoney.getRecoverNO());
        bankAccountChange.setSelfBankNo(recoverMoney.getBankNo());
        bankAccountChange.setTableName(BankChangeConstant.TableName.RECOVER_MONEY.get());
        // 根据UUID来更新
        bankAccountChangeService.updateBankAccountChangeByUUID(bankAccountChange);

        // 执行更新
        return recoverMoneyMapper.updateRecoverMoney(recoverMoney);
    }

    /**
     * 批量删除借出款收回信息
     *
     * @param ids 需要删除的借出款收回信息主键
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE,rollbackFor = Exception.class) // 开启最高级别的事务和最小容忍错误
    public int deleteRecoverMoneyByIds(Long[] ids)
    {
        // 先删除资金变动信息
        List<RecoverMoney> recoverMonies = recoverMoneyMapper.selectBatchIds(Arrays.asList(ids));
        // 拼接UUID数组。批量删除
        List<String> collect = recoverMonies.parallelStream().map(RecoverMoney::getRecoverNO).collect(Collectors.toList());
        bankAccountChangeService.deleteBankAccountChangeByUUID(collect.toArray(new String[0]));


        return recoverMoneyMapper.deleteRecoverMoneyByIds(ids);
    }

}
