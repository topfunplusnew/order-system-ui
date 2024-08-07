package org.dzu.system.service;

import org.dzu.system.domain.Repayment;

import java.util.List;

/**
 * 贷款还款信息Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IRepaymentService 
{
    /**
     * 查询贷款还款信息
     * 
     * @param id 贷款还款信息主键
     * @return 贷款还款信息
     */
    public Repayment selectRepaymentById(Long id);

    /**
     * 查询贷款还款信息列表
     * 
     * @param repayment 贷款还款信息
     * @return 贷款还款信息集合
     */
    public List<Repayment> selectRepaymentList(Repayment repayment);

    /**
     * 新增贷款还款信息
     * 
     * @param repayment 贷款还款信息
     * @return 结果
     */
    public int insertRepayment(Repayment repayment);

    /**
     * 修改贷款还款信息
     * 
     * @param repayment 贷款还款信息
     * @return 结果
     */
    public int updateRepayment(Repayment repayment);

    /**
     * 批量删除贷款还款信息
     * 
     * @param ids 需要删除的贷款还款信息主键集合
     * @return 结果
     */
    public int deleteRepaymentByIds(Long[] ids);

    List<Repayment> selectRepaymentByLoanNo(String id);
}
