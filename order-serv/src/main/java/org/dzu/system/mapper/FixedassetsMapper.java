package org.dzu.system.mapper;

import java.util.List;
import org.dzu.system.domain.Fixedassets;

/**
 * 固定资产Mapper接口
 * 
 * @author ml
 * @date 2024-07-19
 */
public interface FixedassetsMapper 
{
    /**
     * 查询固定资产
     * 
     * @param id 固定资产主键
     * @return 固定资产
     */
    public Fixedassets selectFixedassetsById(Long id);

    /**
     * 查询固定资产列表
     * 
     * @param fixedassets 固定资产
     * @return 固定资产集合
     */
    public List<Fixedassets> selectFixedassetsList(Fixedassets fixedassets);

    /**
     * 新增固定资产
     * 
     * @param fixedassets 固定资产
     * @return 结果
     */
    public int insertFixedassets(Fixedassets fixedassets);

    /**
     * 修改固定资产
     * 
     * @param fixedassets 固定资产
     * @return 结果
     */
    public int updateFixedassets(Fixedassets fixedassets);

    /**
     * 删除固定资产
     * 
     * @param id 固定资产主键
     * @return 结果
     */
    public int deleteFixedassetsById(Long id);

    /**
     * 批量删除固定资产
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteFixedassetsByIds(Long[] ids);
}
