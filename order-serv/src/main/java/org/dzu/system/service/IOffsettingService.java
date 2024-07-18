package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Offsetting;

/**
 * 资金调整单信息Service接口
 * 
 * @author ml
 * @date 2024-07-18
 */
public interface IOffsettingService 
{
    /**
     * 查询资金调整单信息
     * 
     * @param id 资金调整单信息主键
     * @return 资金调整单信息
     */
    public Offsetting selectOffsettingById(Long id);

    /**
     * 查询资金调整单信息列表
     * 
     * @param offsetting 资金调整单信息
     * @return 资金调整单信息集合
     */
    public List<Offsetting> selectOffsettingList(Offsetting offsetting);

    /**
     * 新增资金调整单信息
     * 
     * @param offsetting 资金调整单信息
     * @return 结果
     */
    public int insertOffsetting(Offsetting offsetting);

    /**
     * 修改资金调整单信息
     * 
     * @param offsetting 资金调整单信息
     * @return 结果
     */
    public int updateOffsetting(Offsetting offsetting);

    /**
     * 批量删除资金调整单信息
     * 
     * @param ids 需要删除的资金调整单信息主键集合
     * @return 结果
     */
    public int deleteOffsettingByIds(Long[] ids);

    /**
     * 删除资金调整单信息信息
     * 
     * @param id 资金调整单信息主键
     * @return 结果
     */
    public int deleteOffsettingById(Long id);
}
