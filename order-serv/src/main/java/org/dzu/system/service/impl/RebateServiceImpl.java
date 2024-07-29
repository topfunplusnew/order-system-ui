package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.RebateMapper;
import org.dzu.system.domain.Rebate;
import org.dzu.system.service.IRebateService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 供应商返利Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class RebateServiceImpl implements IRebateService
{
    @Autowired
    private RebateMapper rebateMapper;

    /**
     * 查询供应商返利
     *
     * @param id 供应商返利主键
     * @return 供应商返利
     */
    @Override
    public Rebate selectRebateById(Long id)
    {
        return rebateMapper.selectRebateById(id);
    }

    /**
     * 查询供应商返利列表
     *
     * @param rebate 供应商返利
     * @return 供应商返利
     */
    @Override
    public List<Rebate> selectRebateList(Rebate rebate)
    {
        return rebateMapper.selectRebateList(rebate);
    }

    /**
     * 新增供应商返利
     *
     * @param rebate 供应商返利
     * @return 结果
     */
    @Override
    public int insertRebate(Rebate rebate)
    {
        rebate.setAddtime(String.valueOf(DateUtils.getNowDate()));
        rebate.setUserId(SecurityUtils.getUserId());
        rebate.setUserName(SecurityUtils.getUserTruename());
        rebate.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return rebateMapper.insertRebate(rebate);
    }

    /**
     * 修改供应商返利
     * 
     * @param rebate 供应商返利
     * @return 结果
     */
    @Override
    public int updateRebate(Rebate rebate)
    {
        rebate.setUserId(SecurityUtils.getUserId());
        rebate.setUserName(SecurityUtils.getUserTruename());
        rebate.setUpdateTime(DateUtils.getNowDate());
        return rebateMapper.updateRebate(rebate);
    }

    /**
     * 批量删除供应商返利
     * 
     * @param ids 需要删除的供应商返利主键
     * @return 结果
     */
    @Override
    public int deleteRebateByIds(Long[] ids)
    {
        return rebateMapper.deleteRebateByIds(ids);
    }

    /**
     * 删除供应商返利信息
     * 
     * @param id 供应商返利主键
     * @return 结果
     */
    @Override
    public int deleteRebateById(Long id)
    {
        return rebateMapper.deleteRebateById(id);
    }
}
