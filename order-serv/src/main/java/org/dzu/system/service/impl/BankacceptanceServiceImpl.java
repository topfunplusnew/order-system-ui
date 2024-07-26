package org.dzu.system.service.impl;

import org.dzu.common.constant.OrderConstants;
import org.dzu.common.core.domain.model.LoginUser;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.system.domain.Bankacceptance;
import org.dzu.system.domain.Goodsorder;
import org.dzu.system.domain.Orderdetail;
import org.dzu.system.mapper.BankacceptanceMapper;
import org.dzu.system.mapper.OrderdetailMapper;
import org.dzu.system.service.IBankacceptanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 商业票据、银行承兑Service业务层处理
 * 
 * @author ml
 * @date 2024-07-19
 */
@Service
public class BankacceptanceServiceImpl implements IBankacceptanceService {
    @Autowired
    private BankacceptanceMapper bankacceptanceMapper;

    /**
     * 查询商业票据、银行承兑
     *
     * @param id 商业票据、银行承兑主键
     * @return 商业票据、银行承兑
     */
    @Override
    public Bankacceptance selectBankacceptanceById(Long id) {
        return bankacceptanceMapper.selectBankacceptanceById(id);
    }

    /**
     * 查询商业票据、银行承兑列表
     *
     * @param bankacceptance 商业票据、银行承兑
     * @return 商业票据、银行承兑
     */
    @Override
    public List<Bankacceptance> selectBankacceptanceList(Bankacceptance bankacceptance) {
        return bankacceptanceMapper.selectBankacceptanceList(bankacceptance);
    }

    /**
     * 新增商业票据、银行承兑
     *
     * @param bankacceptance 商业票据、银行承兑
     * @return 结果
     */
    @Transactional(rollbackFor = Exception.class)
    @Override
    public int insertBankacceptance(Bankacceptance bankacceptance) {
        return bankacceptanceMapper.insertBankacceptance(bankacceptance);
    }

    /**
     * 修改商业票据、银行承兑
     *
     * @param bankacceptance 商业票据、银行承兑
     * @return 结果
     */
    @Transactional(rollbackFor = Exception.class)
    @Override
    public int updateBankacceptance(Bankacceptance bankacceptance) {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        bankacceptance.setUserId(loginUser.getUserId());
        bankacceptance.setUserName(loginUser.getUser().getTrueName());
        //旧数据备份
        bankacceptanceMapper.copyToBack(new Long[]{bankacceptance.getId()});
        List<Long> collect = bankacceptance.getbankList().stream().map(Bankacceptance::getId).collect(Collectors.toList());
        bankacceptanceMapper.copyToBack((Long[]) collect.toArray());
        //新数据修改
        bankacceptance.setUpdateTime(DateUtils.getNowDate());
        System.out.println(bankacceptance.getId());
        bankacceptanceMapper.deleteBankacceptanceById(bankacceptance.getId());
        insertBankacceptance(bankacceptance);
        return bankacceptanceMapper.updateBankacceptance(bankacceptance);
    }

    /**
     * 批量删除商业票据、银行承兑
     *
     * @param ids 需要删除的商业票据、银行承兑主键
     * @return 结果
     */
    @Override
    public int deleteBankacceptanceByIds(Long[] ids)
    {
        for (Long id : ids) {
            Bankacceptance bankacceptance = bankacceptanceMapper.selectBankacceptanceById(id);
            bankacceptanceMapper.deleteBankacceptanceByIds(new Long[]{bankacceptance.getId()});
        }
        return bankacceptanceMapper.deleteBankacceptanceByIds(ids);
    }

    /**
     * 删除商业票据、银行承兑信息
     * 
     * @param id 商业票据、银行承兑主键
     * @return 结果
     */
    @Override
    public int deleteBankacceptanceById(Long id)
    {
        bankacceptanceMapper.deleteBankacceptanceById(selectBankacceptanceById(id).getId());
        return bankacceptanceMapper.deleteBankacceptanceById(id);
    }
}
