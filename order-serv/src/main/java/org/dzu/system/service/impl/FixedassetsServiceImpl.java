package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.FixedassetsMapper;
import org.dzu.system.domain.Fixedassets;
import org.dzu.system.service.IFixedassetsService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 固定资产Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class FixedassetsServiceImpl implements IFixedassetsService
{
    @Autowired
    private FixedassetsMapper fixedassetsMapper;

    /**
     * 查询固定资产
     *
     * @param id 固定资产主键
     * @return 固定资产
     */
    @Override
    public Fixedassets selectFixedassetsById(Long id)
    {
        return fixedassetsMapper.selectFixedassetsById(id);
    }

    /**
     * 查询固定资产列表
     *
     * @param fixedassets 固定资产
     * @return 固定资产
     */
    @Override
    public List<Fixedassets> selectFixedassetsList(Fixedassets fixedassets)
    {
        return fixedassetsMapper.selectFixedassetsList(fixedassets);
    }

    /**
     * 新增固定资产
     *
     * @param fixedassets 固定资产
     * @return 结果
     */
    @Override
    public int insertFixedassets(Fixedassets fixedassets)
    {
        fixedassets.setAddtime(String.valueOf(DateUtils.getNowDate()));
        fixedassets.setUserId(SecurityUtils.getUserId());
        fixedassets.setUserName(SecurityUtils.getUserTruename());
        fixedassets.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return fixedassetsMapper.insertFixedassets(fixedassets);
    }

    /**
     * 修改固定资产
     * 
     * @param fixedassets 固定资产
     * @return 结果
     */
    @Override
    public int updateFixedassets(Fixedassets fixedassets)
    {
        fixedassets.setUserId(SecurityUtils.getUserId());
        fixedassets.setUserName(SecurityUtils.getUserTruename());
        fixedassets.setUpdateTime(DateUtils.getNowDate());
        return fixedassetsMapper.updateFixedassets(fixedassets);
    }

    /**
     * 批量删除固定资产
     * 
     * @param ids 需要删除的固定资产主键
     * @return 结果
     */
    @Override
    public int deleteFixedassetsByIds(Long[] ids)
    {
        return fixedassetsMapper.deleteFixedassetsByIds(ids);
    }

    /**
     * 删除固定资产信息
     * 
     * @param id 固定资产主键
     * @return 结果
     */
    @Override
    public int deleteFixedassetsById(Long id)
    {
        return fixedassetsMapper.deleteFixedassetsById(id);
    }
}
