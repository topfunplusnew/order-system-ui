package org.dzu.system.mapper;

import java.util.List;
import org.dzu.system.domain.Rebate;

/**
 * 返利信息Mapper接口
 * 
 * @author ml
 * @date 2024-07-18
 */
public interface RebateMapper 
{
    /**
     * 查询返利信息
     * 
     * @param id 返利信息主键
     * @return 返利信息
     */
    public Rebate selectRebateById(Long id);

    /**
     * 查询返利信息列表
     * 
     * @param rebate 返利信息
     * @return 返利信息集合
     */
    public List<Rebate> selectRebateList(Rebate rebate);

    /**
     * 新增返利信息
     * 
     * @param rebate 返利信息
     * @return 结果
     */
    public int insertRebate(Rebate rebate);

    /**
     * 修改返利信息
     * 
     * @param rebate 返利信息
     * @return 结果
     */
    public int updateRebate(Rebate rebate);

    /**
     * 删除返利信息
     * 
     * @param id 返利信息主键
     * @return 结果
     */
    public int deleteRebateById(Long id);

    /**
     * 批量删除返利信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteRebateByIds(Long[] ids);
}
