package org.dzu.system.service.impl;

import org.dzu.common.constant.DelConstants;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.system.domain.TripReimbursement;
import org.dzu.system.mapper.TripReimbursementMapper;
import org.dzu.system.service.ITripReimbursementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
/**
 * 出差报销Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class TripReimbursementServiceImpl implements ITripReimbursementService
{
    @Autowired
    private TripReimbursementMapper tripReimbursementMapper;

    /**
     * 查询出差报销
     *
     * @param id 出差报销主键
     * @return 出差报销
     */
    @Override
    public TripReimbursement selectTripReimbursementById(Long id)
    {
        return tripReimbursementMapper.selectTripReimbursementById(id);
    }

    /**
     * 查询出差报销列表
     *
     * @param tripReimbursement 出差报销
     * @return 出差报销
     */
    @Override
    public List<TripReimbursement> selectTripReimbursementList(TripReimbursement tripReimbursement)
    {
        return tripReimbursementMapper.selectTripReimbursementList(tripReimbursement);
    }

    /**
     * 新增出差报销
     *
     * @param tripReimbursement 出差报销
     * @return 结果
     */
    @Override
    public int insertTripReimbursement(TripReimbursement tripReimbursement)
    {
        tripReimbursement.setAddtime(String.valueOf(DateUtils.getNowDate()));
        tripReimbursement.setUserId(SecurityUtils.getUserId());
        tripReimbursement.setUserName(SecurityUtils.getUserTruename());
        tripReimbursement.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return tripReimbursementMapper.insertTripReimbursement(tripReimbursement);
    }

    /**
     * 修改出差报销
     * 
     * @param tripReimbursement 出差报销
     * @return 结果
     */
    @Override
    public int updateTripReimbursement(TripReimbursement tripReimbursement)
    {
        tripReimbursement.setUserId(SecurityUtils.getUserId());
        tripReimbursement.setUserName(SecurityUtils.getUserTruename());
        tripReimbursement.setUpdateTime(DateUtils.getNowDate());
        return tripReimbursementMapper.updateTripReimbursement(tripReimbursement);
    }

    /**
     * 批量删除出差报销
     * 
     * @param ids 需要删除的出差报销主键
     * @return 结果
     */
    @Override
    public int deleteTripReimbursementByIds(Long[] ids)
    {
        return tripReimbursementMapper.deleteTripReimbursementByIds(ids);
    }

    /**
     * 删除出差报销信息
     * 
     * @param id 出差报销主键
     * @return 结果
     */
    @Override
    public int deleteTripReimbursementById(Long id)
    {
        return tripReimbursementMapper.deleteTripReimbursementById(id);
    }
}
