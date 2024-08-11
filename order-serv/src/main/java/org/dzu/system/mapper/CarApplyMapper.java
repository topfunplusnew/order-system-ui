package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.dzu.system.domain.CarApply;

import java.util.List;

/**
 * 车辆使用申请Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface CarApplyMapper extends BaseMapper<CarApply>
{
    public CarApply selectCarApplyByIds(Long[] ids);

    /**
     * 查询车辆使用申请
     * 
     * @param id 车辆使用申请主键
     * @return 车辆使用申请
     */
    public CarApply selectCarApplyById(Long id);

    /**
     * 查询车辆使用申请列表
     * 
     * @param carApply 车辆使用申请
     * @return 车辆使用申请集合
     */
    public List<CarApply> selectCarApplyList(CarApply carApply);

    /**
     * 新增车辆使用申请
     * 
     * @param carApply 车辆使用申请
     * @return 结果
     */
    public int insertCarApply(CarApply carApply);

    /**
     * 修改车辆使用申请
     * 
     * @param carApply 车辆使用申请
     * @return 结果
     */
    public int updateCarApply(CarApply carApply);

    /**
     * 删除车辆使用申请
     * 
     * @param id 车辆使用申请主键
     * @return 结果
     */
    public int deleteCarApplyById(Long id);

    /**
     * 批量删除车辆使用申请
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteCarApplyByIds(Long[] ids);
}
