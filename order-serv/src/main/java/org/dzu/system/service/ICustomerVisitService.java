package org.dzu.system.service;

import org.dzu.system.domain.CustomerVisit;

import java.util.List;

/**
 * 走访记录Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface ICustomerVisitService 
{
    /**
     * 查询走访记录
     * 
     * @param id 走访记录主键
     * @return 走访记录
     */
    public CustomerVisit selectCustomerVisitById(Long id);

    /**
     * 查询走访记录列表
     * 
     * @param customerVisit 走访记录
     * @return 走访记录集合
     */
    public List<CustomerVisit> selectCustomerVisitList(CustomerVisit customerVisit);

    /**
     * 新增走访记录
     * 
     * @param customerVisit 走访记录
     * @return 结果
     */
    public int insertCustomerVisit(CustomerVisit customerVisit);

    /**
     * 修改走访记录
     * 
     * @param customerVisit 走访记录
     * @return 结果
     */
    public int updateCustomerVisit(CustomerVisit customerVisit);

    /**
     * 批量删除走访记录
     * 
     * @param ids 需要删除的走访记录主键集合
     * @return 结果
     */
    public int deleteCustomerVisitByIds(Long[] ids);

    /**
     * 删除走访记录信息
     * 
     * @param id 走访记录主键
     * @return 结果
     */
    public int deleteCustomerVisitById(Long id);
}
