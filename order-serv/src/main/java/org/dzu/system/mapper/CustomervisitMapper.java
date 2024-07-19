package org.dzu.system.mapper;

import java.util.List;
import org.dzu.system.domain.Customervisit;

/**
 * 走访记录Mapper接口
 * 
 * @author ml
 * @date 2024-07-19
 */
public interface CustomervisitMapper 
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
     * 删除走访记录
     * 
     * @param id 走访记录主键
     * @return 结果
     */
    public int deleteCustomervisitById(Long id);

    /**
     * 批量删除走访记录
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteCustomervisitByIds(Long[] ids);
}
