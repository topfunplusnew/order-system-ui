package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.CarapplyMapper;
import org.dzu.system.domain.Carapply;
import org.dzu.system.service.ICarapplyService;

/**
 * 汽车申请Service业务层处理
 * 
 * @author ml
 * @date 2024-07-18
 */
@Service
public class CarapplyServiceImpl implements ICarapplyService 
{
    @Autowired
    private CarapplyMapper carapplyMapper;

    /**
     * 查询汽车申请
     * 
     * @param id 汽车申请主键
     * @return 汽车申请
     */
    @Override
    public Carapply selectCarapplyById(Long id)
    {
        return carapplyMapper.selectCarapplyById(id);
    }

    /**
     * 查询汽车申请列表
     * 
     * @param carapply 汽车申请
     * @return 汽车申请
     */
    @Override
    public List<Carapply> selectCarapplyList(Carapply carapply)
    {
        return carapplyMapper.selectCarapplyList(carapply);
    }

    /**
     * 新增汽车申请
     * 
     * @param carapply 汽车申请
     * @return 结果
     */
    @Override
    public int insertCarapply(Carapply carapply)
    {
        return carapplyMapper.insertCarapply(carapply);
    }

    /**
     * 修改汽车申请
     * 
     * @param carapply 汽车申请
     * @return 结果
     */
    @Override
    public int updateCarapply(Carapply carapply)
    {
        carapply.setUpdateTime(DateUtils.getNowDate());
        return carapplyMapper.updateCarapply(carapply);
    }

    /**
     * 批量删除汽车申请
     * 
     * @param ids 需要删除的汽车申请主键
     * @return 结果
     */
    @Override
    public int deleteCarapplyByIds(Long[] ids)
    {
        return carapplyMapper.deleteCarapplyByIds(ids);
    }

    /**
     * 删除汽车申请信息
     * 
     * @param id 汽车申请主键
     * @return 结果
     */
    @Override
    public int deleteCarapplyById(Long id)
    {
        return carapplyMapper.deleteCarapplyById(id);
    }
}
