package org.dzu.system.mapper;

import java.util.List;
import org.dzu.system.domain.Rebate;

/**
 * 供应商返利Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface RebateMapper 
{
    /**
     * 查询供应商返利
     * 
     * @param id 供应商返利主键
     * @return 供应商返利
     */
    public Rebate selectRebateById(Long id);

    /**
     * 查询供应商返利列表
     * 
     * @param rebate 供应商返利
     * @return 供应商返利集合
     */
    public List<Rebate> selectRebateList(Rebate rebate);

    /**
     * 新增供应商返利
     * 
     * @param rebate 供应商返利
     * @return 结果
     */
    public int insertRebate(Rebate rebate);

    /**
     * 修改供应商返利
     * 
     * @param rebate 供应商返利
     * @return 结果
     */
    public int updateRebate(Rebate rebate);

    /**
     * 删除供应商返利
     * 
     * @param id 供应商返利主键
     * @return 结果
     */
    public int deleteRebateById(Long id);

    /**
     * 批量删除供应商返利
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteRebateByIds(Long[] ids);
}
