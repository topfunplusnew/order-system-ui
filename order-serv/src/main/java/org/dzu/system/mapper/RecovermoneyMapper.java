package org.dzu.system.mapper;

import java.util.List;
import org.dzu.system.domain.Recovermoney;

/**
 * 资金回收Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface RecovermoneyMapper 
{
    /**
     * 查询资金回收
     * 
     * @param id 资金回收主键
     * @return 资金回收
     */
    public Recovermoney selectRecovermoneyById(Long id);

    /**
     * 查询资金回收列表
     * 
     * @param recovermoney 资金回收
     * @return 资金回收集合
     */
    public List<Recovermoney> selectRecovermoneyList(Recovermoney recovermoney);

    /**
     * 新增资金回收
     * 
     * @param recovermoney 资金回收
     * @return 结果
     */
    public int insertRecovermoney(Recovermoney recovermoney);

    /**
     * 修改资金回收
     * 
     * @param recovermoney 资金回收
     * @return 结果
     */
    public int updateRecovermoney(Recovermoney recovermoney);

    /**
     * 删除资金回收
     * 
     * @param id 资金回收主键
     * @return 结果
     */
    public int deleteRecovermoneyById(Long id);

    /**
     * 批量删除资金回收
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteRecovermoneyByIds(Long[] ids);
}
