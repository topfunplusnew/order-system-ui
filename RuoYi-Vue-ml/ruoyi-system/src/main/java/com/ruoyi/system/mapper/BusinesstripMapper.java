package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.Businesstrip;

/**
 * 出差记录Mapper接口
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public interface BusinesstripMapper 
{
    /**
     * 查询出差记录
     * 
     * @param id 出差记录主键
     * @return 出差记录
     */
    public Businesstrip selectBusinesstripById(Long id);

    /**
     * 查询出差记录列表
     * 
     * @param businesstrip 出差记录
     * @return 出差记录集合
     */
    public List<Businesstrip> selectBusinesstripList(Businesstrip businesstrip);

    /**
     * 新增出差记录
     * 
     * @param businesstrip 出差记录
     * @return 结果
     */
    public int insertBusinesstrip(Businesstrip businesstrip);

    /**
     * 修改出差记录
     * 
     * @param businesstrip 出差记录
     * @return 结果
     */
    public int updateBusinesstrip(Businesstrip businesstrip);

    /**
     * 删除出差记录
     * 
     * @param id 出差记录主键
     * @return 结果
     */
    public int deleteBusinesstripById(Long id);

    /**
     * 批量删除出差记录
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteBusinesstripByIds(Long[] ids);
}
