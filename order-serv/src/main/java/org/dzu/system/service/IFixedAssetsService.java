package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.FixedAssets;

/**
 * 固定资产Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IFixedAssetsService 
{
    /**
     * 查询固定资产
     * 
     * @param id 固定资产主键
     * @return 固定资产
     */
    public FixedAssets selectFixedAssetsById(Long id);

    /**
     * 查询固定资产列表
     * 
     * @param fixedAssets 固定资产
     * @return 固定资产集合
     */
    public List<FixedAssets> selectFixedAssetsList(FixedAssets fixedAssets);

    /**
     * 新增固定资产
     * 
     * @param fixedAssets 固定资产
     * @return 结果
     */
    public int insertFixedAssets(FixedAssets fixedAssets);

    /**
     * 修改固定资产
     * 
     * @param fixedAssets 固定资产
     * @return 结果
     */
    public int updateFixedAssets(FixedAssets fixedAssets);

    /**
     * 批量删除固定资产
     * 
     * @param ids 需要删除的固定资产主键集合
     * @return 结果
     */
    public int deleteFixedAssetsByIds(Long[] ids);

    /**
     * 删除固定资产信息
     * 
     * @param id 固定资产主键
     * @return 结果
     */
    public int deleteFixedAssetsById(Long id);
}
