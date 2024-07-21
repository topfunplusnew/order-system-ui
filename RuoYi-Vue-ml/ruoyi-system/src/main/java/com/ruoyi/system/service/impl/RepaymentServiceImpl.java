package com.ruoyi.system.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.RepaymentMapper;
import com.ruoyi.system.domain.Repayment;
import com.ruoyi.system.service.IRepaymentService;

/**
 * 还款信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@Service
public class RepaymentServiceImpl implements IRepaymentService 
{
    @Autowired
    private RepaymentMapper repaymentMapper;

    /**
     * 查询还款信息
     * 
     * @param id 还款信息主键
     * @return 还款信息
     */
    @Override
    public Repayment selectRepaymentById(Long id)
    {
        return repaymentMapper.selectRepaymentById(id);
    }

    /**
     * 查询还款信息列表
     * 
     * @param repayment 还款信息
     * @return 还款信息
     */
    @Override
    public List<Repayment> selectRepaymentList(Repayment repayment)
    {
        return repaymentMapper.selectRepaymentList(repayment);
    }

    /**
     * 新增还款信息
     * 
     * @param repayment 还款信息
     * @return 结果
     */
    @Override
    public int insertRepayment(Repayment repayment)
    {
        return repaymentMapper.insertRepayment(repayment);
    }

    /**
     * 修改还款信息
     * 
     * @param repayment 还款信息
     * @return 结果
     */
    @Override
    public int updateRepayment(Repayment repayment)
    {
        repayment.setUpdateTime(DateUtils.getNowDate());
        return repaymentMapper.updateRepayment(repayment);
    }

    /**
     * 批量删除还款信息
     * 
     * @param ids 需要删除的还款信息主键
     * @return 结果
     */
    @Override
    public int deleteRepaymentByIds(Long[] ids)
    {
        return repaymentMapper.deleteRepaymentByIds(ids);
    }

    /**
     * 删除还款信息信息
     * 
     * @param id 还款信息主键
     * @return 结果
     */
    @Override
    public int deleteRepaymentById(Long id)
    {
        return repaymentMapper.deleteRepaymentById(id);
    }
}
