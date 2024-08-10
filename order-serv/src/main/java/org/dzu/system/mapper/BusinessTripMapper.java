package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import java.util.List;
import org.dzu.system.domain.BusinessTrip;
import org.dzu.system.domain.TripReimbursement;

/**
 * 出差Mapper接口
 * 
 * @author ml
 * @date 2024-08-10
 */
public interface BusinessTripMapper extends BaseMapper<BusinessTrip>
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
     * 删除出差
     * 
     * @param id 出差主键
     * @return 结果
     */
    public int deleteBusinessTripById(Long id);

    /**
     * 批量删除出差
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteBusinessTripByIds(Long[] ids);

    /**
     * 批量删除出差报销
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteTripReimbursementByBTripIds(Long[] ids);
    
    /**
     * 批量新增出差报销
     * 
     * @param tripReimbursementList 出差报销列表
     * @return 结果
     */
    public int batchTripReimbursement(List<TripReimbursement> tripReimbursementList);
    

    /**
     * 通过出差主键删除出差报销信息
     * 
     * @param id 出差ID
     * @return 结果
     */
    public int deleteTripReimbursementByBTripId(Long id);
}
