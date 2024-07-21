package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.Repayment;

/**
 * 还款信息Mapper接口
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public interface RepaymentMapper 
{
    /**
     * 查询还款信息
     * 
     * @param id 还款信息主键
     * @return 还款信息
     */
    public Repayment selectRepaymentById(Long id);

    /**
     * 查询还款信息列表
     * 
     * @param repayment 还款信息
     * @return 还款信息集合
     */
    public List<Repayment> selectRepaymentList(Repayment repayment);

    /**
     * 新增还款信息
     * 
     * @param repayment 还款信息
     * @return 结果
     */
    public int insertRepayment(Repayment repayment);

    /**
     * 修改还款信息
     * 
     * @param repayment 还款信息
     * @return 结果
     */
    public int updateRepayment(Repayment repayment);

    /**
     * 删除还款信息
     * 
     * @param id 还款信息主键
     * @return 结果
     */
    public int deleteRepaymentById(Long id);

    /**
     * 批量删除还款信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteRepaymentByIds(Long[] ids);
}
