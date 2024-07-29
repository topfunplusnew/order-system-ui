package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.CustomerVisitMapper;
import org.dzu.system.domain.CustomerVisit;
import org.dzu.system.service.ICustomerVisitService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 走访记录Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class CustomerVisitServiceImpl implements ICustomerVisitService
{
    @Autowired
    private CustomerVisitMapper customerVisitMapper;

    /**
     * 查询走访记录
     *
     * @param id 走访记录主键
     * @return 走访记录
     */
    @Override
    public CustomerVisit selectCustomerVisitById(Long id)
    {
        return customerVisitMapper.selectCustomerVisitById(id);
    }

    /**
     * 查询走访记录列表
     *
     * @param customerVisit 走访记录
     * @return 走访记录
     */
    @Override
    public List<CustomerVisit> selectCustomerVisitList(CustomerVisit customerVisit)
    {
        return customerVisitMapper.selectCustomerVisitList(customerVisit);
    }

    /**
     * 新增走访记录
     *
     * @param customerVisit 走访记录
     * @return 结果
     */
    @Override
    public int insertCustomerVisit(CustomerVisit customerVisit)
    {
        customerVisit.setAddtime(String.valueOf(DateUtils.getNowDate()));
        customerVisit.setUserId(SecurityUtils.getUserId());
        customerVisit.setUserName(SecurityUtils.getUserTruename());
        customerVisit.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return customerVisitMapper.insertCustomerVisit(customerVisit);
    }

    /**
     * 修改走访记录
     * 
     * @param customerVisit 走访记录
     * @return 结果
     */
    @Override
    public int updateCustomerVisit(CustomerVisit customerVisit)
    {
        customerVisit.setUserId(SecurityUtils.getUserId());
        customerVisit.setUserName(SecurityUtils.getUserTruename());
        customerVisit.setUpdateTime(DateUtils.getNowDate());
        return customerVisitMapper.updateCustomerVisit(customerVisit);
    }

    /**
     * 批量删除走访记录
     * 
     * @param ids 需要删除的走访记录主键
     * @return 结果
     */
    @Override
    public int deleteCustomerVisitByIds(Long[] ids)
    {
        return customerVisitMapper.deleteCustomerVisitByIds(ids);
    }

    /**
     * 删除走访记录信息
     * 
     * @param id 走访记录主键
     * @return 结果
     */
    @Override
    public int deleteCustomerVisitById(Long id)
    {
        return customerVisitMapper.deleteCustomerVisitById(id);
    }
}
