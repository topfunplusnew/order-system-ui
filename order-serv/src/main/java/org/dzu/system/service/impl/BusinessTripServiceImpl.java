package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import org.dzu.common.utils.StringUtils;
import org.springframework.transaction.annotation.Transactional;
import org.dzu.system.domain.TripReimbursement;
import org.dzu.system.mapper.BusinessTripMapper;
import org.dzu.system.domain.BusinessTrip;
import org.dzu.system.service.IBusinessTripService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 出差Service业务层处理
 *
 * @author ml
 * @date 2024-08-10
 */
@Service
public class BusinessTripServiceImpl implements IBusinessTripService
{
    @Autowired
    private BusinessTripMapper businessTripMapper;

    /**
     * 查询出差
     *
     * @param id 出差主键
     * @return 出差
     */
    @Override
    public BusinessTrip selectBusinessTripById(Long id)
    {
        return businessTripMapper.selectBusinessTripById(id);
    }

    /**
     * 查询出差列表
     *
     * @param businessTrip 出差
     * @return 出差
     */
    @Override
    public List<BusinessTrip> selectBusinessTripList(BusinessTrip businessTrip)
    {
        return businessTripMapper.selectBusinessTripList(businessTrip);
    }

    /**
     * 新增出差
     *
     * @param businessTrip 出差
     * @return 结果
     */
    @Transactional
    @Override
    public int insertBusinessTrip(BusinessTrip businessTrip)
    {
        // 设置基础信息
        businessTrip.setAddtime(String.valueOf(DateUtils.getNowDate()));
        businessTrip.setUserId(SecurityUtils.getUserId());
        businessTrip.setUserName(SecurityUtils.getUserTruename());
        businessTrip.setDelFlag(Long.valueOf(DelConstants.NODEL));
        businessTrip.setEmployee(SecurityUtils.getUserTruename());
        businessTrip.setEmployeeID(SecurityUtils.getUserId());


        // 插入出差
        int rows = businessTripMapper.insertBusinessTrip(businessTrip);
        insertTripReimbursement(businessTrip);
        return rows;
    }

    /**
     * 修改出差
     * 
     * @param businessTrip 出差
     * @return 结果
     */
    @Transactional
    @Override
    public int updateBusinessTrip(BusinessTrip businessTrip)
    {
        businessTrip.setUpdateTime(DateUtils.getNowDate());


        businessTripMapper.deleteTripReimbursementByBTripId(businessTrip.getId());
        insertTripReimbursement(businessTrip);
        return businessTripMapper.updateBusinessTrip(businessTrip);
    }

    /**
     * 批量删除出差
     * 
     * @param ids 需要删除的出差主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteBusinessTripByIds(Long[] ids)
    {
        businessTripMapper.deleteTripReimbursementByBTripIds(ids);
        return businessTripMapper.deleteBusinessTripByIds(ids);
    }

    /**
     * 删除出差信息
     * 
     * @param id 出差主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteBusinessTripById(Long id)
    {
        businessTripMapper.deleteTripReimbursementByBTripId(id);
        return businessTripMapper.deleteBusinessTripById(id);
    }

    /**
     * 新增出差报销信息
     * 
     * @param businessTrip 出差对象
     */
    public void insertTripReimbursement(BusinessTrip businessTrip)
    {
        List<TripReimbursement> tripReimbursementList = businessTrip.getTripReimbursementList();
        Long id = businessTrip.getId();
        if (StringUtils.isNotNull(tripReimbursementList))
        {
            List<TripReimbursement> list = new ArrayList<TripReimbursement>();
            for (TripReimbursement tripReimbursement : tripReimbursementList)
            {
                tripReimbursement.setbTripId(id);
                tripReimbursement.setUserId(SecurityUtils.getUserId());
                tripReimbursement.setUserName(SecurityUtils.getUserTruename());
                tripReimbursement.setDelFlag(Long.valueOf(DelConstants.NODEL));
                tripReimbursement.setAddtime(DateUtils.getNowDate().toString());
                list.add(tripReimbursement);
            }
            if (list.size() > 0)
            {
                businessTripMapper.batchTripReimbursement(list);
            }
        }
    }
}
