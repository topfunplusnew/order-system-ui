package org.dzu.system.service;

import org.dzu.system.domain.Fixedassets;

import java.util.List;

/**
 * 固定资产信息Service接口
 * 
 * @author ml
 * @date 2024-07-18
 */
public interface IFixedassetsService 
{
    /**
     * 查询固定资产信息
     * 
     * @param id 固定资产信息主键
     * @return 固定资产信息
     */
    public Fixedassets selectFixedassetsById(Long id);

    /**
     * 查询固定资产信息列表
     * 
     * @param fixedassets 固定资产信息
     * @return 固定资产信息集合
     */
    public List<Fixedassets> selectFixedassetsList(Fixedassets fixedassets);

    /**
     * 新增固定资产信息
     * 
     * @param fixedassets 固定资产信息
     * @return 结果
     */
    public int insertFixedassets(Fixedassets fixedassets);

    /**
     * 修改固定资产信息
     * 
     * @param fixedassets 固定资产信息
     * @return 结果
     */
    public int updateFixedassets(Fixedassets fixedassets);

    /**
     * 批量删除固定资产信息
     * 
     * @param ids 需要删除的固定资产信息主键集合
     * @return 结果
     */
    public int deleteFixedassetsByIds(Long[] ids);

    /**
     * 删除固定资产信息信息
     * 
     * @param id 固定资产信息主键
     * @return 结果
     */
    public int deleteFixedassetsById(Long id);
}
