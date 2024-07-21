package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.Recoverfuturesmargin;

/**
 * 恢复期货保证金？Service接口
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public interface IRecoverfuturesmarginService 
{
    /**
     * 查询恢复期货保证金？
     * 
     * @param id 恢复期货保证金？主键
     * @return 恢复期货保证金？
     */
    public Recoverfuturesmargin selectRecoverfuturesmarginById(Long id);

    /**
     * 查询恢复期货保证金？列表
     * 
     * @param recoverfuturesmargin 恢复期货保证金？
     * @return 恢复期货保证金？集合
     */
    public List<Recoverfuturesmargin> selectRecoverfuturesmarginList(Recoverfuturesmargin recoverfuturesmargin);

    /**
     * 新增恢复期货保证金？
     * 
     * @param recoverfuturesmargin 恢复期货保证金？
     * @return 结果
     */
    public int insertRecoverfuturesmargin(Recoverfuturesmargin recoverfuturesmargin);

    /**
     * 修改恢复期货保证金？
     * 
     * @param recoverfuturesmargin 恢复期货保证金？
     * @return 结果
     */
    public int updateRecoverfuturesmargin(Recoverfuturesmargin recoverfuturesmargin);

    /**
     * 批量删除恢复期货保证金？
     * 
     * @param ids 需要删除的恢复期货保证金？主键集合
     * @return 结果
     */
    public int deleteRecoverfuturesmarginByIds(Long[] ids);

    /**
     * 删除恢复期货保证金？信息
     * 
     * @param id 恢复期货保证金？主键
     * @return 结果
     */
    public int deleteRecoverfuturesmarginById(Long id);
}
