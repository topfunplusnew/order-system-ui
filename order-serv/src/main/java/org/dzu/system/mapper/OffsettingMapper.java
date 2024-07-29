package org.dzu.system.mapper;

import java.util.List;
import org.dzu.system.domain.Offsetting;

/**
 * 资金调整单信息Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface OffsettingMapper 
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
     * 删除资金调整单信息
     * 
     * @param id 资金调整单信息主键
     * @return 结果
     */
    public int deleteOffsettingById(Long id);

    /**
     * 批量删除资金调整单信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteOffsettingByIds(Long[] ids);
}
