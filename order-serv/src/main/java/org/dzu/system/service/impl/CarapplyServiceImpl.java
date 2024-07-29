package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.CarapplyMapper;
import org.dzu.system.domain.Carapply;
import org.dzu.system.service.ICarapplyService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 车辆派出管理Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class CarapplyServiceImpl implements ICarapplyService
{
    @Autowired
    private CarapplyMapper carapplyMapper;

    /**
     * 查询车辆派出管理
     *
     * @param id 车辆派出管理主键
     * @return 车辆派出管理
     */
    @Override
    public Carapply selectCarapplyById(Long id)
    {
        return carapplyMapper.selectCarapplyById(id);
    }

    /**
     * 查询车辆派出管理列表
     *
     * @param carapply 车辆派出管理
     * @return 车辆派出管理
     */
    @Override
    public List<Carapply> selectCarapplyList(Carapply carapply)
    {
        return carapplyMapper.selectCarapplyList(carapply);
    }

    /**
     * 新增车辆派出管理
     *
     * @param carapply 车辆派出管理
     * @return 结果
     */
    @Override
    public int insertCarapply(Carapply carapply)
    {
        carapply.setAddtime(String.valueOf(DateUtils.getNowDate()));
        carapply.setUserId(SecurityUtils.getUserId());
        carapply.setUserName(SecurityUtils.getUserTruename());
        carapply.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return carapplyMapper.insertCarapply(carapply);
    }

    /**
     * 修改车辆派出管理
     * 
     * @param carapply 车辆派出管理
     * @return 结果
     */
    @Override
    public int updateCarapply(Carapply carapply)
    {
        carapply.setUserId(SecurityUtils.getUserId());
        carapply.setUserName(SecurityUtils.getUserTruename());
        carapply.setUpdateTime(DateUtils.getNowDate());
        return carapplyMapper.updateCarapply(carapply);
    }

    /**
     * 批量删除车辆派出管理
     * 
     * @param ids 需要删除的车辆派出管理主键
     * @return 结果
     */
    @Override
    public int deleteCarapplyByIds(Long[] ids)
    {
        return carapplyMapper.deleteCarapplyByIds(ids);
    }

    /**
     * 删除车辆派出管理信息
     * 
     * @param id 车辆派出管理主键
     * @return 结果
     */
    @Override
    public int deleteCarapplyById(Long id)
    {
        return carapplyMapper.deleteCarapplyById(id);
    }
}
