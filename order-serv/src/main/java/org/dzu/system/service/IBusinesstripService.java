package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Businesstrip;

/**
 * 出差登记Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IBusinesstripService 
{
    /**
     * 查询出差登记
     * 
     * @param id 出差登记主键
     * @return 出差登记
     */
    public Businesstrip selectBusinesstripById(Long id);

    /**
     * 查询出差登记列表
     * 
     * @param businesstrip 出差登记
     * @return 出差登记集合
     */
    public List<Businesstrip> selectBusinesstripList(Businesstrip businesstrip);

    /**
     * 新增出差登记
     * 
     * @param businesstrip 出差登记
     * @return 结果
     */
    public int insertBusinesstrip(Businesstrip businesstrip);

    /**
     * 修改出差登记
     * 
     * @param businesstrip 出差登记
     * @return 结果
     */
    public int updateBusinesstrip(Businesstrip businesstrip);

    /**
     * 批量删除出差登记
     * 
     * @param ids 需要删除的出差登记主键集合
     * @return 结果
     */
    public int deleteBusinesstripByIds(Long[] ids);

    /**
     * 删除出差登记信息
     * 
     * @param id 出差登记主键
     * @return 结果
     */
    public int deleteBusinesstripById(Long id);
}
