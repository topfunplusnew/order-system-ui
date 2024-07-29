package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.TripReimbursement;

/**
 * 出差报销Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface ITripReimbursementService 
{
    /**
     * 查询出差报销
     * 
     * @param id 出差报销主键
     * @return 出差报销
     */
    public TripReimbursement selectTripReimbursementById(Long id);

    /**
     * 查询出差报销列表
     * 
     * @param tripReimbursement 出差报销
     * @return 出差报销集合
     */
    public List<TripReimbursement> selectTripReimbursementList(TripReimbursement tripReimbursement);

    /**
     * 新增出差报销
     * 
     * @param tripReimbursement 出差报销
     * @return 结果
     */
    public int insertTripReimbursement(TripReimbursement tripReimbursement);

    /**
     * 修改出差报销
     * 
     * @param tripReimbursement 出差报销
     * @return 结果
     */
    public int updateTripReimbursement(TripReimbursement tripReimbursement);

    /**
     * 批量删除出差报销
     * 
     * @param ids 需要删除的出差报销主键集合
     * @return 结果
     */
    public int deleteTripReimbursementByIds(Long[] ids);

    /**
     * 删除出差报销信息
     * 
     * @param id 出差报销主键
     * @return 结果
     */
    public int deleteTripReimbursementById(Long id);
}
