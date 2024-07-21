package com.ruoyi.system.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.RebateMapper;
import com.ruoyi.system.domain.Rebate;
import com.ruoyi.system.service.IRebateService;

/**
 * 返利信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@Service
public class RebateServiceImpl implements IRebateService 
{
    @Autowired
    private RebateMapper rebateMapper;

    /**
     * 查询返利信息
     * 
     * @param id 返利信息主键
     * @return 返利信息
     */
    @Override
    public Rebate selectRebateById(Long id)
    {
        return rebateMapper.selectRebateById(id);
    }

    /**
     * 查询返利信息列表
     * 
     * @param rebate 返利信息
     * @return 返利信息
     */
    @Override
    public List<Rebate> selectRebateList(Rebate rebate)
    {
        return rebateMapper.selectRebateList(rebate);
    }

    /**
     * 新增返利信息
     * 
     * @param rebate 返利信息
     * @return 结果
     */
    @Override
    public int insertRebate(Rebate rebate)
    {
        return rebateMapper.insertRebate(rebate);
    }

    /**
     * 修改返利信息
     * 
     * @param rebate 返利信息
     * @return 结果
     */
    @Override
    public int updateRebate(Rebate rebate)
    {
        rebate.setUpdateTime(DateUtils.getNowDate());
        return rebateMapper.updateRebate(rebate);
    }

    /**
     * 批量删除返利信息
     * 
     * @param ids 需要删除的返利信息主键
     * @return 结果
     */
    @Override
    public int deleteRebateByIds(Long[] ids)
    {
        return rebateMapper.deleteRebateByIds(ids);
    }

    /**
     * 删除返利信息信息
     * 
     * @param id 返利信息主键
     * @return 结果
     */
    @Override
    public int deleteRebateById(Long id)
    {
        return rebateMapper.deleteRebateById(id);
    }
}
