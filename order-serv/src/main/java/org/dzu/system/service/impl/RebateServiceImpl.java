package org.dzu.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.dzu.common.constant.BankChangeConstant;
import org.dzu.common.constant.DelConstants;
import org.dzu.common.enums.TableName;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.system.domain.BankAccount;
import org.dzu.system.domain.BankAccountChange;
import org.dzu.system.domain.Company;
import org.dzu.system.domain.Rebate;
import org.dzu.system.mapper.BankAccountChangeMapper;
import org.dzu.system.mapper.RebateMapper;
import org.dzu.system.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 返利回扣Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class RebateServiceImpl implements IRebateService {
    @Autowired
    private RebateMapper rebateMapper;

    @Autowired
    private IBankAccountService bankAccountService;

    @Autowired
    private BankAccountChangeMapper bankAccountChangeMapper;

    @Autowired
    private IBankAccountChangeService bankAccountChangeService;

    @Autowired
    private IGoodsOrderService goodsOrderService;

    @Autowired
    private ICompanyService companyService;

    /**
     * 查询返利回扣
     *
     * @param id 返利回扣主键
     * @return 返利回扣
     */
    @Override
    public Rebate selectRebateById(Long id) {
        return rebateMapper.selectRebateById(id);
    }

    /**
     * 查询返利回扣列表
     *
     * @param rebate 返利回扣
     * @return 返利回扣
     */
    @Override
    public List<Rebate> selectRebateList(Rebate rebate) {
        return rebateMapper.selectRebateList(rebate);
    }

    /**
     * 新增返利回扣
     *
     * @param rebate 返利回扣
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE, rollbackFor = Exception.class)
    public int insertRebate(Rebate rebate) {
        // 设置基础信息
        rebate.setAddtime(String.valueOf(DateUtils.getNowDate()));
        rebate.setUserId(SecurityUtils.getUserId());
        rebate.setUserName(SecurityUtils.getUserTruename());
        rebate.setDelFlag(Long.valueOf(DelConstants.NODEL));

        // 校验所依赖的表中有无数据
        Validate(rebate);

        // 先插入，插入之后才有主键
        int rows = rebateMapper.insertRebate(rebate);
        // 同步银行卡变动
        SyncToBankChange(rebate);

        return  rows;
    }

    /**
     * 修改返利回扣
     *
     * @param rebate 返利回扣
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE, rollbackFor = Exception.class)
    public int updateRebate(Rebate rebate) {
        // 设置基础信息
        rebate.setUserId(SecurityUtils.getUserId());
        rebate.setUserName(SecurityUtils.getUserTruename());
        rebate.setUpdateTime(DateUtils.getNowDate());


        // 校验所依赖的表中有无数据
        Validate(rebate);

        // 同步银行卡变动
        SyncToBankChange(rebate);
        return rebateMapper.updateRebate(rebate);
    }

    /**
     * 批量删除返利回扣
     *
     * @param ids 需要删除的返利回扣主键
     * @return 结果
     */
    @Override
    public int deleteRebateByIds(Long[] ids) {
        return rebateMapper.deleteRebateByIds(ids);
    }

    /**
     * 删除返利回扣信息
     *
     * @param id 返利回扣主键
     * @return 结果
     */
    @Override
    public int deleteRebateById(Long id) {
        return rebateMapper.deleteRebateById(id);
    }


    private void Validate(Rebate rebate) {
        // 搜索供应商是否存在
        Company supplier = companyService.selectCompanyById(rebate.getSupplierID());
        if (supplier == null) {
            throw new RuntimeException("数据库中搜索不到对应供应商");
        }
    }

    private void SyncToBankChange(Rebate rebate) {

        // 搜索支付和收款的银行卡是否存在
        BankAccount InAccount = bankAccountService.selectBankAccountByBankNo(rebate.getInBankNo());
        BankAccount OutAccount = bankAccountService.selectBankAccountByBankNo(rebate.getOutBankNo());

        if (InAccount == null || OutAccount == null) {
            throw new RuntimeException("数据库中搜索不到对应银行卡");
        }

        // 确定能搜索到，开始更新银行卡余额
        BankAccountChange outBank = new BankAccountChange();
        outBank.setPayNO(String.valueOf(rebate.getId()));
        outBank.setChangeType(BankChangeConstant.PaymentType.PAYMENT.get());
        outBank.setSelfBankNo(rebate.getOutBankNo());
        outBank.setMoneyAmount(rebate.getRebate());
        outBank.setTableName(TableName.REBATE.get());

        BankAccountChange inBank = new BankAccountChange();
        inBank.setPayNO(String.valueOf(rebate.getId()));
        inBank.setChangeType(BankChangeConstant.PaymentType.RECEIPT.get());
        inBank.setSelfBankNo(rebate.getInBankNo());
        inBank.setMoneyAmount(rebate.getRebate());
        inBank.setTableName(TableName.REBATE.get());

        // 去尝试搜索是否有对应的银行卡变动记录，如果无，则是更新，如果有，则是插入
        QueryWrapper<BankAccountChange> queryIn = new QueryWrapper<>();
        queryIn.eq("payNO", rebate.getId()).eq("changeType", BankChangeConstant.PaymentType.RECEIPT.get());
        if (bankAccountChangeMapper.selectOne(queryIn)==null) {
            bankAccountChangeService.insertBankAccountChange(inBank);
        } else {
            bankAccountChangeService.updateBankAccountChangeByUUID(inBank);
        }
        QueryWrapper<BankAccountChange> queryOut = new QueryWrapper<>();
        queryOut.eq("payNO", rebate.getId()).eq("changeType", BankChangeConstant.PaymentType.PAYMENT.get());
        if (bankAccountChangeMapper.selectOne(queryOut)==null) {
            bankAccountChangeService.insertBankAccountChange(outBank);
        } else {
            bankAccountChangeService.updateBankAccountChangeByUUID(outBank);
        }
    }

}

