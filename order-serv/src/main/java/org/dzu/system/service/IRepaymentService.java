package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Repayment;

/**
 * 还款记录Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IRepaymentService 
{
    /**
     * 查询还款记录
     * 
     * @param id 还款记录主键
     * @return 还款记录
     */
    public Repayment selectRepaymentById(Long id);

    /**
     * 查询还款记录列表
     * 
     * @param repayment 还款记录
     * @return 还款记录集合
     */
    public List<Repayment> selectRepaymentList(Repayment repayment);

    /**
     * 新增还款记录
     * 
     * @param repayment 还款记录
     * @return 结果
     */
    public int insertRepayment(Repayment repayment);

    /**
     * 修改还款记录
     * 
     * @param repayment 还款记录
     * @return 结果
     */
    public int updateRepayment(Repayment repayment);

    /**
     * 批量删除还款记录
     * 
     * @param ids 需要删除的还款记录主键集合
     * @return 结果
     */
    public int deleteRepaymentByIds(Long[] ids);

    /**
     * 删除还款记录信息
     * 
     * @param id 还款记录主键
     * @return 结果
     */
    public int deleteRepaymentById(Long id);
}
