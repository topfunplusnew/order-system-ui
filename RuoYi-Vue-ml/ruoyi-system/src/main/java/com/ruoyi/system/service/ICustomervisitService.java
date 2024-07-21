package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.Customervisit;

/**
 * 走访记录Service接口
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public interface ICustomervisitService 
{
    /**
     * 查询走访记录
     * 
     * @param id 走访记录主键
     * @return 走访记录
     */
    public Customervisit selectCustomervisitById(Long id);

    /**
     * 查询走访记录列表
     * 
     * @param customervisit 走访记录
     * @return 走访记录集合
     */
    public List<Customervisit> selectCustomervisitList(Customervisit customervisit);

    /**
     * 新增走访记录
     * 
     * @param customervisit 走访记录
     * @return 结果
     */
    public int insertCustomervisit(Customervisit customervisit);

    /**
     * 修改走访记录
     * 
     * @param customervisit 走访记录
     * @return 结果
     */
    public int updateCustomervisit(Customervisit customervisit);

    /**
     * 批量删除走访记录
     * 
     * @param ids 需要删除的走访记录主键集合
     * @return 结果
     */
    public int deleteCustomervisitByIds(Long[] ids);

    /**
     * 删除走访记录信息
     * 
     * @param id 走访记录主键
     * @return 结果
     */
    public int deleteCustomervisitById(Long id);
}
