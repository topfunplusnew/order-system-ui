package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import java.util.List;
import org.dzu.system.domain.Rebate;

/**
 * 返利回扣Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface RebateMapper extends BaseMapper<Rebate>
{
    /**
     * 查询返利回扣
     * 
     * @param id 返利回扣主键
     * @return 返利回扣
     */
    public Rebate selectRebateById(Long id);

    /**
     * 查询返利回扣列表
     * 
     * @param rebate 返利回扣
     * @return 返利回扣集合
     */
    public List<Rebate> selectRebateList(Rebate rebate);

    /**
     * 新增返利回扣
     * 
     * @param rebate 返利回扣
     * @return 结果
     */
    public int insertRebate(Rebate rebate);

    /**
     * 修改返利回扣
     * 
     * @param rebate 返利回扣
     * @return 结果
     */
    public int updateRebate(Rebate rebate);

    /**
     * 删除返利回扣
     * 
     * @param id 返利回扣主键
     * @return 结果
     */
    public int deleteRebateById(Long id);

    /**
     * 批量删除返利回扣
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteRebateByIds(Long[] ids);
}
