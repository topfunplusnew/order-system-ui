package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.dzu.system.domain.TripReimbursement;

import java.util.List;

/**
 * 出差报销Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface TripReimbursementMapper extends BaseMapper<TripReimbursement>
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
     * 删除出差报销
     * 
     * @param id 出差报销主键
     * @return 结果
     */
    public int deleteTripReimbursementById(Long id);

    /**
     * 批量删除出差报销
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteTripReimbursementByIds(Long[] ids);
}
