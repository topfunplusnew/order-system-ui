package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.RepaymentMapper;
import org.dzu.system.domain.Repayment;
import org.dzu.system.service.IRepaymentService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 贷款还款信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class RepaymentServiceImpl implements IRepaymentService
{
    @Autowired
    private RepaymentMapper repaymentMapper;

    /**
     * 查询贷款还款信息
     *
     * @param id 贷款还款信息主键
     * @return 贷款还款信息
     */
    @Override
    public Repayment selectRepaymentById(Long id)
    {
        return repaymentMapper.selectRepaymentById(id);
    }

    /**
     * 查询贷款还款信息列表
     *
     * @param repayment 贷款还款信息
     * @return 贷款还款信息
     */
    @Override
    public List<Repayment> selectRepaymentList(Repayment repayment)
    {
        return repaymentMapper.selectRepaymentList(repayment);
    }

    /**
     * 新增贷款还款信息
     *
     * @param repayment 贷款还款信息
     * @return 结果
     */
    @Override
    public int insertRepayment(Repayment repayment)
    {
        repayment.setAddtime(String.valueOf(DateUtils.getNowDate()));
        repayment.setUserId(SecurityUtils.getUserId());
        repayment.setUserName(SecurityUtils.getUserTruename());
        repayment.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return repaymentMapper.insertRepayment(repayment);
    }

    /**
     * 修改贷款还款信息
     * 
     * @param repayment 贷款还款信息
     * @return 结果
     */
    @Override
    public int updateRepayment(Repayment repayment)
    {
        repayment.setUserId(SecurityUtils.getUserId());
        repayment.setUserName(SecurityUtils.getUserTruename());
        repayment.setUpdateTime(DateUtils.getNowDate());
        return repaymentMapper.updateRepayment(repayment);
    }

    /**
     * 批量删除贷款还款信息
     * 
     * @param ids 需要删除的贷款还款信息主键
     * @return 结果
     */
    @Override
    public int deleteRepaymentByIds(Long[] ids)
    {
        return repaymentMapper.deleteRepaymentByIds(ids);
    }

    /**
     * 删除贷款还款信息信息
     * 
     * @param id 贷款还款信息主键
     * @return 结果
     */
    @Override
    public int deleteRepaymentById(Long id)
    {
        return repaymentMapper.deleteRepaymentById(id);
    }
}
