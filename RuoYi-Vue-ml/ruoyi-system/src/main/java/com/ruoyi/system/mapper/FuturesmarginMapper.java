package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.Futuresmargin;

/**
 * 期货保证金信息Mapper接口
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public interface FuturesmarginMapper 
{
    /**
     * 查询期货保证金信息
     * 
     * @param id 期货保证金信息主键
     * @return 期货保证金信息
     */
    public Futuresmargin selectFuturesmarginById(Long id);

    /**
     * 查询期货保证金信息列表
     * 
     * @param futuresmargin 期货保证金信息
     * @return 期货保证金信息集合
     */
    public List<Futuresmargin> selectFuturesmarginList(Futuresmargin futuresmargin);

    /**
     * 新增期货保证金信息
     * 
     * @param futuresmargin 期货保证金信息
     * @return 结果
     */
    public int insertFuturesmargin(Futuresmargin futuresmargin);

    /**
     * 修改期货保证金信息
     * 
     * @param futuresmargin 期货保证金信息
     * @return 结果
     */
    public int updateFuturesmargin(Futuresmargin futuresmargin);

    /**
     * 删除期货保证金信息
     * 
     * @param id 期货保证金信息主键
     * @return 结果
     */
    public int deleteFuturesmarginById(Long id);

    /**
     * 批量删除期货保证金信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteFuturesmarginByIds(Long[] ids);
}
