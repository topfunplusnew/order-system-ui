package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.dzu.system.domain.FixedAssets;

import java.util.List;

/**
 * 固定资产Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface FixedAssetsMapper extends BaseMapper<FixedAssets>
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
     * 删除固定资产
     * 
     * @param id 固定资产主键
     * @return 结果
     */
    public int deleteFixedAssetsById(Long id);

    /**
     * 批量删除固定资产
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteFixedAssetsByIds(Long[] ids);
}
