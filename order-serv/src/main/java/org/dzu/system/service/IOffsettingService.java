package org.dzu.system.service;

import org.dzu.system.domain.Offsetting;

import java.util.List;

/**
 * 对冲账信息Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IOffsettingService 
{
    /**
     * 查询对冲账信息
     * 
     * @param id 对冲账信息主键
     * @return 对冲账信息
     */
    public Offsetting selectOffsettingById(Long id);

    /**
     * 查询对冲账信息列表
     * 
     * @param offsetting 对冲账信息
     * @return 对冲账信息集合
     */
    public List<Offsetting> selectOffsettingList(Offsetting offsetting);

    /**
     * 新增对冲账信息
     * 
     * @param offsetting 对冲账信息
     * @return 结果
     */
    public int insertOffsetting(Offsetting offsetting);

    /**
     * 修改对冲账信息
     * 
     * @param offsetting 对冲账信息
     * @return 结果
     */
    public int updateOffsetting(Offsetting offsetting);

    /**
     * 批量删除对冲账信息
     * 
     * @param ids 需要删除的对冲账信息主键集合
     * @return 结果
     */
    public int deleteOffsettingByIds(Long[] ids);

    /**
     * 删除对冲账信息信息
     * 
     * @param id 对冲账信息主键
     * @return 结果
     */
    public int deleteOffsettingById(Long id);
}
