package org.dzu.system.service.impl;

import org.dzu.common.constant.DelConstants;
import org.dzu.common.enums.TableName;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.system.domain.BalanceAccounts;
import org.dzu.system.domain.Company;
import org.dzu.system.domain.VirtualBankAccountChange;
import org.dzu.system.mapper.BalanceAccountsMapper;
import org.dzu.system.service.IBalanceAccountsService;
import org.dzu.system.service.ICompanyService;
import org.dzu.system.service.IVirtualBankAccountChangeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 平账信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class BalanceAccountsServiceImpl implements IBalanceAccountsService {
    @Autowired
    private BalanceAccountsMapper balanceAccountsMapper;

    @Autowired
    private IVirtualBankAccountChangeService bankAccountChangeService;

    @Autowired
    private ICompanyService companyService;

    /**
     * 查询平账信息
     *
     * @param id 平账信息主键
     * @return 平账信息
     */
    @Override
    public BalanceAccounts selectBalanceAccountsById(Long id) {
        return balanceAccountsMapper.selectBalanceAccountsById(id);
    }

    /**
     * 查询平账信息列表
     *
     * @param balanceAccounts 平账信息
     * @return 平账信息
     */
    @Override
    public List<BalanceAccounts> selectBalanceAccountsList(BalanceAccounts balanceAccounts) {
        return balanceAccountsMapper.selectBalanceAccountsList(balanceAccounts);
    }

    /**
     * 新增平账信息
     *
     * @param balanceAccounts 平账信息
     * @return 结果
     */
    @Override
    @Transactional
    public int insertBalanceAccounts(BalanceAccounts balanceAccounts) {
        // 设置基础信息
        balanceAccounts.setAddtime(String.valueOf(DateUtils.getNowDate()));
        balanceAccounts.setUserId(SecurityUtils.getUserId());
        balanceAccounts.setUserName(SecurityUtils.getUserTruename());
        balanceAccounts.setDelFlag(Long.valueOf(DelConstants.NODEL));

        // 先校验本次涉及的company是否存在
        Company company = companyService.selectCompanyById(balanceAccounts.getCompanyID());
        if (company == null) {
            throw new ServiceException("搜索不到对应信息，请刷新页面后重试");
        }
        // 先插入信息，才能生成主键
        int rows = balanceAccountsMapper.insertBalanceAccounts(balanceAccounts);
        syncToChange(balanceAccounts);

        return rows;
    }

    private void syncToChange(BalanceAccounts balanceAccounts) {
        // 因为不涉及银行卡操作，故向虚拟变动中插入信息
        VirtualBankAccountChange self = new VirtualBankAccountChange();
        self.setCompanyId(String.valueOf(balanceAccounts.getCompanyID()));
        self.setPayNO(String.valueOf(balanceAccounts.getId()));
        self.setTableName(TableName.BALANCEACCOUNT.get());
        self.setMoneyAmount(balanceAccounts.getMoneyAmount());
        bankAccountChangeService.insertReceipt(self);
        bankAccountChangeService.inserPayment(self);
    }

    /**
     * 修改平账信息
     *
     * @param balanceAccounts 平账信息
     * @return 结果
     */
    @Override
    @Transactional
    public int updateBalanceAccounts(BalanceAccounts balanceAccounts) {
        balanceAccounts.setUpdateTime(DateUtils.getNowDate());
        // 直接删除对应的资金变动然后重新插入
        bankAccountChangeService.delete(TableName.BALANCEACCOUNT.get(), String.valueOf(balanceAccounts.getId()));
        // 重新插入
        syncToChange(balanceAccounts);

        return balanceAccountsMapper.updateBalanceAccounts(balanceAccounts);
    }

    /**
     * 批量删除平账信息
     *
     * @param ids 需要删除的平账信息主键
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteBalanceAccountsByIds(Long[] ids) {

        for (Long id : ids) {
            bankAccountChangeService.delete(TableName.BALANCEACCOUNT.get(), String.valueOf(id));
        }

        return balanceAccountsMapper.deleteBalanceAccountsByIds(ids);
    }


}
