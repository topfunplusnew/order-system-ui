package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.BusinessTripMapper;
import org.dzu.system.domain.BusinessTrip;
import org.dzu.system.service.IBusinessTripService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 出差Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
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
    @Override
    public int insertBusinessTrip(BusinessTrip businessTrip)
    {
        businessTrip.setAddtime(String.valueOf(DateUtils.getNowDate()));
        businessTrip.setUserId(SecurityUtils.getUserId());
        businessTrip.setUserName(SecurityUtils.getUserTruename());
        businessTrip.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return businessTripMapper.insertBusinessTrip(businessTrip);
    }

    /**
     * 修改出差
     * 
     * @param businessTrip 出差
     * @return 结果
     */
    @Override
    public int updateBusinessTrip(BusinessTrip businessTrip)
    {
        businessTrip.setUserId(SecurityUtils.getUserId());
        businessTrip.setUserName(SecurityUtils.getUserTruename());
        businessTrip.setUpdateTime(DateUtils.getNowDate());
        return businessTripMapper.updateBusinessTrip(businessTrip);
    }

    /**
     * 批量删除出差
     * 
     * @param ids 需要删除的出差主键
     * @return 结果
     */
    @Override
    public int deleteBusinessTripByIds(Long[] ids)
    {
        return businessTripMapper.deleteBusinessTripByIds(ids);
    }

    /**
     * 删除出差信息
     * 
     * @param id 出差主键
     * @return 结果
     */
    @Override
    public int deleteBusinessTripById(Long id)
    {
        return businessTripMapper.deleteBusinessTripById(id);
    }
}
