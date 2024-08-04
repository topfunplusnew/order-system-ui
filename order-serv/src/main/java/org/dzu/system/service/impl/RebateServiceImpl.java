package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.system.domain.BankAccount;
import org.dzu.system.domain.Company;
import org.dzu.system.service.IBankAccountService;
import org.dzu.system.service.ICompanyService;
import org.dzu.system.service.IGoodsOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.RebateMapper;
import org.dzu.system.domain.Rebate;
import org.dzu.system.service.IRebateService;
 
import org.dzu.common.constant.DelConstants;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

/**
 * 返利回扣Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class RebateServiceImpl implements IRebateService
{
    @Autowired
    private RebateMapper rebateMapper;

    @Autowired
    private IBankAccountService bankAccountService;

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
    public Rebate selectRebateById(Long id)
    {
        return rebateMapper.selectRebateById(id);
    }

    /**
     * 查询返利回扣列表
     *
     * @param rebate 返利回扣
     * @return 返利回扣
     */
    @Override
    public List<Rebate> selectRebateList(Rebate rebate)
    {
        return rebateMapper.selectRebateList(rebate);
    }

    /**
     * 新增返利回扣
     *
     * @param rebate 返利回扣
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE,rollbackFor = Exception.class)
    public int insertRebate(Rebate rebate)
    {
        // 设置基础信息
        rebate.setAddtime(String.valueOf(DateUtils.getNowDate()));
        rebate.setUserId(SecurityUtils.getUserId());
        rebate.setUserName(SecurityUtils.getUserTruename());
        rebate.setDelFlag(Long.valueOf(DelConstants.NODEL));

        // 校验所依赖的表中有无数据
        Validate(rebate);

        return rebateMapper.insertRebate(rebate);
    }

    /**
     * 修改返利回扣
     * 
     * @param rebate 返利回扣
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE,rollbackFor = Exception.class)
    public int updateRebate(Rebate rebate)
    {
        // 设置基础信息
        rebate.setUserId(SecurityUtils.getUserId());
        rebate.setUserName(SecurityUtils.getUserTruename());
        rebate.setUpdateTime(DateUtils.getNowDate());


        // 校验所依赖的表中有无数据
        Validate(rebate);
        return rebateMapper.updateRebate(rebate);
    }

    /**
     * 批量删除返利回扣
     * 
     * @param ids 需要删除的返利回扣主键
     * @return 结果
     */
    @Override
    public int deleteRebateByIds(Long[] ids)
    {
        return rebateMapper.deleteRebateByIds(ids);
    }

    /**
     * 删除返利回扣信息
     * 
     * @param id 返利回扣主键
     * @return 结果
     */
    @Override
    public int deleteRebateById(Long id)
    {
        return rebateMapper.deleteRebateById(id);
    }


    private void Validate(Rebate rebate){
        // 搜索支付和收款的银行卡是否存在
        BankAccount InAccount = bankAccountService.selectBankAccountByBankNo(rebate.getInBankNo());
        BankAccount OutAccount = bankAccountService.selectBankAccountByBankNo(rebate.getOutBankNo());

        if (InAccount == null || OutAccount == null) {
            throw new RuntimeException("数据库中搜索不到对应银行卡");
        }

        // 搜索供应商是否存在
        Company supplier = companyService.selectCompanyById(rebate.getSupplierID());
        if (supplier == null) {
            throw new RuntimeException("数据库中搜索不到对应供应商");
        }


    }

}

