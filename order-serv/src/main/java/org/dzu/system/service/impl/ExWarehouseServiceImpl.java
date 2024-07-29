package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.ExWarehouseMapper;
import org.dzu.system.domain.ExWarehouse;
import org.dzu.system.service.IExWarehouseService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 出库Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class ExWarehouseServiceImpl implements IExWarehouseService
{
    @Autowired
    private ExWarehouseMapper exWarehouseMapper;

    /**
     * 查询出库
     *
     * @param id 出库主键
     * @return 出库
     */
    @Override
    public ExWarehouse selectExWarehouseById(Long id)
    {
        return exWarehouseMapper.selectExWarehouseById(id);
    }

    /**
     * 查询出库列表
     *
     * @param exWarehouse 出库
     * @return 出库
     */
    @Override
    public List<ExWarehouse> selectExWarehouseList(ExWarehouse exWarehouse)
    {
        return exWarehouseMapper.selectExWarehouseList(exWarehouse);
    }

    /**
     * 新增出库
     *
     * @param exWarehouse 出库
     * @return 结果
     */
    @Override
    public int insertExWarehouse(ExWarehouse exWarehouse)
    {
        exWarehouse.setAddtime(String.valueOf(DateUtils.getNowDate()));
        exWarehouse.setUserId(SecurityUtils.getUserId());
        exWarehouse.setUserName(SecurityUtils.getUserTruename());
        exWarehouse.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return exWarehouseMapper.insertExWarehouse(exWarehouse);
    }

    /**
     * 修改出库
     * 
     * @param exWarehouse 出库
     * @return 结果
     */
    @Override
    public int updateExWarehouse(ExWarehouse exWarehouse)
    {
        exWarehouse.setUpdateTime(DateUtils.getNowDate());
        exWarehouse.setUserId(SecurityUtils.getUserId());
        exWarehouse.setUserName(SecurityUtils.getUserTruename());
        return exWarehouseMapper.updateExWarehouse(exWarehouse);
    }

    /**
     * 批量删除出库
     * 
     * @param ids 需要删除的出库主键
     * @return 结果
     */
    @Override
    public int deleteExWarehouseByIds(Long[] ids)
    {
        return exWarehouseMapper.deleteExWarehouseByIds(ids);
    }

    /**
     * 删除出库信息
     * 
     * @param id 出库主键
     * @return 结果
     */
    @Override
    public int deleteExWarehouseById(Long id)
    {
        return exWarehouseMapper.deleteExWarehouseById(id);
    }
}
