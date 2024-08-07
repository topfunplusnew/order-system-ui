package org.dzu.system.service;

import org.dzu.system.domain.BusinessTrip;

import java.util.List;

/**
 * 出差Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IBusinessTripService 
{
    /**
     * 查询出差
     * 
     * @param id 出差主键
     * @return 出差
     */
    public BusinessTrip selectBusinessTripById(Long id);

    /**
     * 查询出差列表
     * 
     * @param businessTrip 出差
     * @return 出差集合
     */
    public List<BusinessTrip> selectBusinessTripList(BusinessTrip businessTrip);

    /**
     * 新增出差
     * 
     * @param businessTrip 出差
     * @return 结果
     */
    public int insertBusinessTrip(BusinessTrip businessTrip);

    /**
     * 修改出差
     * 
     * @param businessTrip 出差
     * @return 结果
     */
    public int updateBusinessTrip(BusinessTrip businessTrip);

    /**
     * 批量删除出差
     * 
     * @param ids 需要删除的出差主键集合
     * @return 结果
     */
    public int deleteBusinessTripByIds(Long[] ids);

    /**
     * 删除出差信息
     * 
     * @param id 出差主键
     * @return 结果
     */
    public int deleteBusinessTripById(Long id);
}
