package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.FixedAssetsMapper;
import org.dzu.system.domain.FixedAssets;
import org.dzu.system.service.IFixedAssetsService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 固定资产Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class FixedAssetsServiceImpl implements IFixedAssetsService
{
    @Autowired
    private FixedAssetsMapper fixedAssetsMapper;

    /**
     * 查询固定资产
     *
     * @param id 固定资产主键
     * @return 固定资产
     */
    @Override
    public FixedAssets selectFixedAssetsById(Long id)
    {
        return fixedAssetsMapper.selectFixedAssetsById(id);
    }

    /**
     * 查询固定资产列表
     *
     * @param fixedAssets 固定资产
     * @return 固定资产
     */
    @Override
    public List<FixedAssets> selectFixedAssetsList(FixedAssets fixedAssets)
    {
        return fixedAssetsMapper.selectFixedAssetsList(fixedAssets);
    }

    /**
     * 新增固定资产
     *
     * @param fixedAssets 固定资产
     * @return 结果
     */
    @Override
    public int insertFixedAssets(FixedAssets fixedAssets)
    {
        fixedAssets.setAddtime(String.valueOf(DateUtils.getNowDate()));
        fixedAssets.setUserId(SecurityUtils.getUserId());
        fixedAssets.setUserName(SecurityUtils.getUserTruename());
        fixedAssets.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return fixedAssetsMapper.insertFixedAssets(fixedAssets);
    }

    /**
     * 修改固定资产
     * 
     * @param fixedAssets 固定资产
     * @return 结果
     */
    @Override
    public int updateFixedAssets(FixedAssets fixedAssets)
    {
        fixedAssets.setUserId(SecurityUtils.getUserId());
        fixedAssets.setUserName(SecurityUtils.getUserTruename());
        fixedAssets.setUpdateTime(DateUtils.getNowDate());
        return fixedAssetsMapper.updateFixedAssets(fixedAssets);
    }

    /**
     * 批量删除固定资产
     * 
     * @param ids 需要删除的固定资产主键
     * @return 结果
     */
    @Override
    public int deleteFixedAssetsByIds(Long[] ids)
    {
        return fixedAssetsMapper.deleteFixedAssetsByIds(ids);
    }

    /**
     * 删除固定资产信息
     * 
     * @param id 固定资产主键
     * @return 结果
     */
    @Override
    public int deleteFixedAssetsById(Long id)
    {
        return fixedAssetsMapper.deleteFixedAssetsById(id);
    }
}
