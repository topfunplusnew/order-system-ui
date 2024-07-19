package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.RepaymentMapper;
import org.dzu.system.domain.Repayment;
import org.dzu.system.service.IRepaymentService;

/**
 * 还款记录Service业务层处理
 * 
 * @author ml
 * @date 2024-07-19
 */
@Service
public class RepaymentServiceImpl implements IRepaymentService 
{
    @Autowired
    private RepaymentMapper repaymentMapper;

    /**
     * 查询还款记录
     * 
     * @param id 还款记录主键
     * @return 还款记录
     */
    @Override
    public Repayment selectRepaymentById(Long id)
    {
        return repaymentMapper.selectRepaymentById(id);
    }

    /**
     * 查询还款记录列表
     * 
     * @param repayment 还款记录
     * @return 还款记录
     */
    @Override
    public List<Repayment> selectRepaymentList(Repayment repayment)
    {
        return repaymentMapper.selectRepaymentList(repayment);
    }

    /**
     * 新增还款记录
     * 
     * @param repayment 还款记录
     * @return 结果
     */
    @Override
    public int insertRepayment(Repayment repayment)
    {
        return repaymentMapper.insertRepayment(repayment);
    }

    /**
     * 修改还款记录
     * 
     * @param repayment 还款记录
     * @return 结果
     */
    @Override
    public int updateRepayment(Repayment repayment)
    {
        repayment.setUpdateTime(DateUtils.getNowDate());
        return repaymentMapper.updateRepayment(repayment);
    }

    /**
     * 批量删除还款记录
     * 
     * @param ids 需要删除的还款记录主键
     * @return 结果
     */
    @Override
    public int deleteRepaymentByIds(Long[] ids)
    {
        return repaymentMapper.deleteRepaymentByIds(ids);
    }

    /**
     * 删除还款记录信息
     * 
     * @param id 还款记录主键
     * @return 结果
     */
    @Override
    public int deleteRepaymentById(Long id)
    {
        return repaymentMapper.deleteRepaymentById(id);
    }
}
