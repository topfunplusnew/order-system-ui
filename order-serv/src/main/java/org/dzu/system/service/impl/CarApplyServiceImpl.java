package org.dzu.system.service.impl;

import org.dzu.common.constant.DelConstants;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.system.domain.CarApply;
import org.dzu.system.mapper.CarApplyMapper;
import org.dzu.system.service.ICarApplyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
/**
 * 车辆使用申请Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class CarApplyServiceImpl implements ICarApplyService
{
    @Autowired
    private CarApplyMapper carApplyMapper;

    /**
     * 查询车辆使用申请
     *
     * @param id 车辆使用申请主键
     * @return 车辆使用申请
     */
    @Override
    public CarApply selectCarApplyById(Long id)
    {
        return carApplyMapper.selectCarApplyById(id);
    }

    /**
     * 查询车辆使用申请列表
     *
     * @param carApply 车辆使用申请
     * @return 车辆使用申请
     */
    @Override
    public List<CarApply> selectCarApplyList(CarApply carApply)
    {
        return carApplyMapper.selectCarApplyList(carApply);
    }

    /**
     * 新增车辆使用申请
     *
     * @param carApply 车辆使用申请
     * @return 结果
     */
    @Override
    public int insertCarApply(CarApply carApply)
    {
        carApply.setAddtime(String.valueOf(DateUtils.getNowDate()));
        carApply.setUserId(SecurityUtils.getUserId());
        carApply.setUserName(SecurityUtils.getUserTruename());
        carApply.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return carApplyMapper.insertCarApply(carApply);
    }

    /**
     * 修改车辆使用申请
     * 
     * @param carApply 车辆使用申请
     * @return 结果
     */
    @Override
    public int updateCarApply(CarApply carApply)
    {
        carApply.setUserId(SecurityUtils.getUserId());
        carApply.setUserName(SecurityUtils.getUserTruename());
        carApply.setUpdateTime(DateUtils.getNowDate());
        return carApplyMapper.updateCarApply(carApply);
    }

    /**
     * 批量删除车辆使用申请
     * 
     * @param ids 需要删除的车辆使用申请主键
     * @return 结果
     */
    @Override
    public int deleteCarApplyByIds(Long[] ids)
    {
        return carApplyMapper.deleteCarApplyByIds(ids);
    }

    /**
     * 删除车辆使用申请信息
     * 
     * @param id 车辆使用申请主键
     * @return 结果
     */
    @Override
    public int deleteCarApplyById(Long id)
    {
        return carApplyMapper.deleteCarApplyById(id);
    }
}
