package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.OffsettingMapper;
import org.dzu.system.domain.Offsetting;
import org.dzu.system.service.IOffsettingService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 对冲账信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class OffsettingServiceImpl implements IOffsettingService
{
    @Autowired
    private OffsettingMapper offsettingMapper;

    /**
     * 查询对冲账信息
     *
     * @param id 对冲账信息主键
     * @return 对冲账信息
     */
    @Override
    public Offsetting selectOffsettingById(Long id)
    {
        return offsettingMapper.selectOffsettingById(id);
    }

    /**
     * 查询对冲账信息列表
     *
     * @param offsetting 对冲账信息
     * @return 对冲账信息
     */
    @Override
    public List<Offsetting> selectOffsettingList(Offsetting offsetting)
    {
        return offsettingMapper.selectOffsettingList(offsetting);
    }

    /**
     * 新增对冲账信息
     *
     * @param offsetting 对冲账信息
     * @return 结果
     */
    @Override
    public int insertOffsetting(Offsetting offsetting)
    {
        offsetting.setAddtime(String.valueOf(DateUtils.getNowDate()));
        offsetting.setUserId(SecurityUtils.getUserId());
        offsetting.setUserName(SecurityUtils.getUserTruename());
        offsetting.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return offsettingMapper.insertOffsetting(offsetting);
    }

    /**
     * 修改对冲账信息
     * 
     * @param offsetting 对冲账信息
     * @return 结果
     */
    @Override
    public int updateOffsetting(Offsetting offsetting)
    {
        offsetting.setUserId(SecurityUtils.getUserId());
        offsetting.setUserName(SecurityUtils.getUserTruename());
        offsetting.setUpdateTime(DateUtils.getNowDate());
        return offsettingMapper.updateOffsetting(offsetting);
    }

    /**
     * 批量删除对冲账信息
     * 
     * @param ids 需要删除的对冲账信息主键
     * @return 结果
     */
    @Override
    public int deleteOffsettingByIds(Long[] ids)
    {
        return offsettingMapper.deleteOffsettingByIds(ids);
    }

    /**
     * 删除对冲账信息信息
     * 
     * @param id 对冲账信息主键
     * @return 结果
     */
    @Override
    public int deleteOffsettingById(Long id)
    {
        return offsettingMapper.deleteOffsettingById(id);
    }
}
