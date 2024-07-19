package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.CustomervisitMapper;
import org.dzu.system.domain.Customervisit;
import org.dzu.system.service.ICustomervisitService;

/**
 * 走访记录Service业务层处理
 * 
 * @author ml
 * @date 2024-07-19
 */
@Service
public class CustomervisitServiceImpl implements ICustomervisitService 
{
    @Autowired
    private CustomervisitMapper customervisitMapper;

    /**
     * 查询走访记录
     * 
     * @param id 走访记录主键
     * @return 走访记录
     */
    @Override
    public Customervisit selectCustomervisitById(Long id)
    {
        return customervisitMapper.selectCustomervisitById(id);
    }

    /**
     * 查询走访记录列表
     * 
     * @param customervisit 走访记录
     * @return 走访记录
     */
    @Override
    public List<Customervisit> selectCustomervisitList(Customervisit customervisit)
    {
        return customervisitMapper.selectCustomervisitList(customervisit);
    }

    /**
     * 新增走访记录
     * 
     * @param customervisit 走访记录
     * @return 结果
     */
    @Override
    public int insertCustomervisit(Customervisit customervisit)
    {
        return customervisitMapper.insertCustomervisit(customervisit);
    }

    /**
     * 修改走访记录
     * 
     * @param customervisit 走访记录
     * @return 结果
     */
    @Override
    public int updateCustomervisit(Customervisit customervisit)
    {
        customervisit.setUpdateTime(DateUtils.getNowDate());
        return customervisitMapper.updateCustomervisit(customervisit);
    }

    /**
     * 批量删除走访记录
     * 
     * @param ids 需要删除的走访记录主键
     * @return 结果
     */
    @Override
    public int deleteCustomervisitByIds(Long[] ids)
    {
        return customervisitMapper.deleteCustomervisitByIds(ids);
    }

    /**
     * 删除走访记录信息
     * 
     * @param id 走访记录主键
     * @return 结果
     */
    @Override
    public int deleteCustomervisitById(Long id)
    {
        return customervisitMapper.deleteCustomervisitById(id);
    }
}
